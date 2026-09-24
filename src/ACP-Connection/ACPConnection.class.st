"
I am the bidirectional JSON-RPC engine that drives all communication with an ACP agent.

Responsibility:
- I maintain a background read loop that continuously reads incoming messages from the transport
- I dispatch responses to pending requests (via Semaphore signaling) and route incoming requests/notifications to a JRPCMessageProcessor
- I handle each incoming request in its own forked process, so a blocking handler does not stop the read loop
- I cancel an incoming request's ACPCancellationToken when the agent sends $/cancel_request for it
- I assign monotonically increasing IDs to outgoing requests and track them in a pending requests dictionary
- I handle connection closure gracefully, rejecting all outstanding pending requests

Collaborators:
- ACPNdJsonTransport: my transport layer — I read and write JSON messages through it
- ACPPendingRequest: one instance per in-flight request; I resolve or reject it when the response arrives
- JRPCMessageProcessor: I delegate incoming requests and notifications to it for handler dispatch
- ACPCancellationToken: one per incoming request; bound as ACPCurrentCancellationToken while its handler runs
- ACPRequestCancelled: when it escapes from a handler, I respond with error code -32800

Public API and Key Messages:
- #startReadLoop - fork a background process at lowIOPriority to read messages continuously
- #sendRequest:params: - send a JSON-RPC request; blocks caller until the response arrives
- #sendNotification:params: - send a fire-and-forget notification (no response expected)
- #close - terminate the read loop, the transport, and any running incoming request processes
- #cancelIncomingRequest: - cancel a running incoming request (as if $/cancel_request was received)
- #incomingRequestProcesses - copy of the running incoming request processes, keyed by request id
- #terminateIncomingRequests - emergency cleanup: terminate all running incoming request processes
- #waitForClose - block until the connection is closed (useful for scripting)

Internal Representation:
- transport - the ACPNdJsonTransport used for I/O
- pendingRequests - Dictionary mapping request id → ACPPendingRequest
- messageProcessor - JRPCMessageProcessor for dispatching incoming requests/notifications
- id - monotonically increasing request ID counter
- readProcess - the background Process running the read loop
- isClosed - true once close has been called
- closeSemaphore - signaled when the connection closes
- incomingRequests - Dictionary mapping incoming request id → the Process handling it
- cancellationTokens - Dictionary mapping incoming request id → its ACPCancellationToken
- incomingRequestsMutex - Mutex guarding incomingRequests and cancellationTokens

Implementation Points:
- The read loop runs at lowIOPriority to keep the Pharo IDE responsive
- Error in message processing sends a JSON-RPC error response back to the agent (for requests only)
- Incoming request processes run at userSchedulingPriority; notifications stay in the read loop to keep their order
- A process is registered before it starts and unregisters itself before writing its response,
  so every running handler process can be found for cancellation or cleanup
- Cancellation is cooperative: I only cancel the token; I never interrupt the handler process
- An incoming request whose id is already running is rejected with -32600
- On connection closed, all pending requests are rejected with code -32000
"
Class {
	#name : 'ACPConnection',
	#superclass : 'Object',
	#instVars : [
		'transport',
		'messageProcessor',
		'pendingRequests',
		'id',
		'readProcess',
		'isClosed',
		'closeSemaphore',
		'incomingRequests',
		'cancellationTokens',
		'incomingRequestsMutex'
	],
	#category : 'ACP-Connection',
	#package : 'ACP-Connection'
}

{ #category : 'instance creation' }
ACPConnection class >> on: anACPNdJsonTransport [

	^ self new
		  transport: anACPNdJsonTransport;
		  yourself
]

{ #category : 'accessing' }
ACPConnection class >> cancelRequestMethod [

	^ '$/cancel_request'
]

{ #category : 'operations' }
ACPConnection >> cancelIncomingRequest: aRequestId [
	"Cancel the token of a running incoming request. Unknown or finished requests are ignored."

	(incomingRequestsMutex critical: [
		 cancellationTokens at: aRequestId ifAbsent: [ nil ] ]) ifNotNil: [ :token |
		token cancel ]
]

{ #category : 'operations' }
ACPConnection >> close [

	self isClosed: true.
	self transport ifNotNil: [ :t | t close ].
	self terminateIncomingRequests.
	self readProcess ifNotNil: [ :p | p terminate ]
]

{ #category : 'accessing' }
ACPConnection >> closeSemaphore [

	^ closeSemaphore
]

{ #category : 'private' }
ACPConnection >> handleConnectionClosed [

	self isClosed: true.
	self pendingRequests valuesDo: [ :pending |
		pending rejectWith: {
			'code' -> -32000.
			'message' -> 'Connection closed'
		} asDictionary ].
	self pendingRequests removeAll.
	self terminateIncomingRequests.
	self closeSemaphore signal
]

{ #category : 'private' }
ACPConnection >> errorResponseForId: anId code: aCode message: aString [

	^ {
		'jsonrpc' -> '2.0'.
		'id' -> anId.
		'error' -> {
			'code' -> aCode.
			'message' -> aString
		} asDictionary
	} asDictionary
]

{ #category : 'private' }
ACPConnection >> handleCancelRequest: message [

	| params |
	params := message at: 'params' ifAbsent: [ ^ self ].
	params isDictionary ifFalse: [ ^ self ].
	self cancelIncomingRequest: (params at: 'requestId' ifAbsent: [ ^ self ])
]

{ #category : 'private' }
ACPConnection >> handleIncomingNotification: message [
	"Dispatch incoming notification via JRPCMessageProcessor using object API.
	 $/cancel_request is handled here and not forwarded."

	| notification |
	(message at: 'method') = self class cancelRequestMethod ifTrue: [
		^ self handleCancelRequest: message ].
	notification := JRPCNotificationObject new
		method: (message at: 'method');
		params: { message at: 'params' ifAbsent: [ Dictionary new ] };
		yourself.
	self messageProcessor handleJRPCNotificationObject: notification
]

{ #category : 'private' }
ACPConnection >> handleIncomingRequest: message [
	"Handle the request in its own process so that a blocking handler does not stop the read loop.
	 The process is registered before it starts, so it can always be found for cancellation or cleanup."

	| requestId token process |
	requestId := message at: 'id'.
	token := ACPCancellationToken new.
	process := [ self processIncomingRequest: message token: token ] newProcess.
	process
		priority: Processor userSchedulingPriority;
		name: 'ACP incoming request ' , requestId printString.
	(self registerIncomingRequest: requestId process: process token: token) ifFalse: [
		^ self transport writeMessage: (self
				   errorResponseForId: requestId
				   code: -32600
				   message: 'Duplicate request id: ' , requestId printString) ].
	process resume
]

{ #category : 'accessing' }
ACPConnection >> incomingRequestProcesses [
	"Answer a copy of the running incoming request processes, keyed by request id."

	^ incomingRequestsMutex critical: [ incomingRequests copy ]
]

{ #category : 'private' }
ACPConnection >> processIncomingRequest: message token: aToken [
	"Run in the forked process, with aToken bound as ACPCurrentCancellationToken."

	| requestId response |
	requestId := message at: 'id'.
	response := [
	            ACPCurrentCancellationToken
		            value: aToken
		            during: [ self responseForIncomingRequest: message ] ]
		            on: ACPRequestCancelled , Error
		            do: [ :e |
			            e return: (self
					             errorResponseForId: requestId
					             code: ((e isKindOf: ACPRequestCancelled)
							              ifTrue: [ ACPRequestCancelled code ]
							              ifFalse: [ -32603 ])
					             message: e messageText) ].
	self unregisterIncomingRequest: requestId.
	[ self transport writeMessage: response ]
		on: Error
		do: [ :e | self isClosed ifFalse: [ e pass ] ]
]

{ #category : 'private' }
ACPConnection >> registerIncomingRequest: aRequestId process: aProcess token: aToken [
	"Answer false if a request with the same id is already running."

	^ incomingRequestsMutex critical: [
		  (incomingRequests includesKey: aRequestId)
			  ifTrue: [ false ]
			  ifFalse: [
				  incomingRequests at: aRequestId put: aProcess.
				  cancellationTokens at: aRequestId put: aToken.
				  true ] ]
]

{ #category : 'private' }
ACPConnection >> responseForIncomingRequest: message [
	"Dispatch incoming request via JRPCMessageProcessor using object API.
	 Params are wrapped in an array for JRPCBlockHandler compatibility."

	| request response responseDict |
	request := JRPCRequestObject new
		method: (message at: 'method');
		id: (message at: 'id');
		params: { message at: 'params' ifAbsent: [ Dictionary new ] };
		yourself.
	response := self messageProcessor handleJRPCRequestObject: request.
	responseDict := Dictionary new.
	responseDict at: 'jsonrpc' put: '2.0'.
	responseDict at: 'id' put: response id.
	response isError
		ifTrue: [ responseDict at: 'error' put: {
			'code' -> response error code.
			'message' -> response error message } asDictionary ]
		ifFalse: [ responseDict at: 'result' put: response result ].
	^ responseDict
]

{ #category : 'private' }
ACPConnection >> handleResponse: message [

	| responseId pending |
	responseId := message at: 'id' ifAbsent: [ ^ self ].
	pending := self pendingRequests at: responseId ifAbsent: [ ^ self ].
	(message includesKey: 'result')
		ifTrue: [ pending resolveWith: (message at: 'result') ]
		ifFalse: [
			(message includesKey: 'error')
				ifTrue: [ pending rejectWith: (message at: 'error') ] ]
]

{ #category : 'accessing' }
ACPConnection >> id [

	^ id
]

{ #category : 'accessing' }
ACPConnection >> id: anInteger [

	id := anInteger
]

{ #category : 'initialization' }
ACPConnection >> initialize [

	super initialize.
	pendingRequests := Dictionary new.
	id := 0.
	isClosed := false.
	closeSemaphore := Semaphore new.
	messageProcessor := JRPCMessageProcessor new.
	incomingRequests := Dictionary new.
	cancellationTokens := Dictionary new.
	incomingRequestsMutex := Mutex new
]

{ #category : 'testing' }
ACPConnection >> isClosed [

	^ isClosed
]

{ #category : 'accessing' }
ACPConnection >> isClosed: aBoolean [

	isClosed := aBoolean
]

{ #category : 'accessing' }
ACPConnection >> messageProcessor [

	^ messageProcessor
]

{ #category : 'private' }
ACPConnection >> nextId [

	self id: self id + 1.
	^ self id
]

{ #category : 'accessing' }
ACPConnection >> pendingRequests [

	^ pendingRequests
]

{ #category : 'read loop' }
ACPConnection >> processMessage: message [

	(message includesKey: 'method')
		ifTrue: [
			(message includesKey: 'id')
				ifTrue: [ self handleIncomingRequest: message ]
				ifFalse: [ self handleIncomingNotification: message ] ]
		ifFalse: [
			(message includesKey: 'id')
				ifTrue: [ self handleResponse: message ] ]
]

{ #category : 'read loop' }
ACPConnection >> readLoop [

	[ self isClosed not ] whileTrue: [
			| message |
			message := self transport readMessage.
			message
				ifNil: [ self handleConnectionClosed ]
				ifNotNil: [
					[ self processMessage: message ]
						on: Error
						do: [ :e |
							(message includesKey: 'id') ifTrue: [
								self sendErrorResponseForId: (message at: 'id') error: e ] ] ] ]
]

{ #category : 'accessing' }
ACPConnection >> readProcess [

	^ readProcess
]

{ #category : 'accessing' }
ACPConnection >> readProcess: aProcess [

	readProcess := aProcess
]

{ #category : 'private' }
ACPConnection >> sendErrorResponseForId: anId error: anError [

	self transport writeMessage: {
		'jsonrpc' -> '2.0'.
		'id' -> anId.
		'error' -> {
			'code' -> -32603.
			'message' -> anError messageText
		} asDictionary
	} asDictionary
]

{ #category : 'sending' }
ACPConnection >> sendNotification: method params: params [

	self transport writeMessage: {
		'jsonrpc' -> '2.0'.
		'method' -> method.
		'params' -> params
	} asDictionary
]

{ #category : 'sending' }
ACPConnection >> sendRequest: method params: params [

	| requestId pending |
	requestId := self nextId.
	pending := ACPPendingRequest new.
	self pendingRequests at: requestId put: pending.
	self transport writeMessage: {
		'jsonrpc' -> '2.0'.
		'id' -> requestId.
		'method' -> method.
		'params' -> params
	} asDictionary.
	^ [ pending wait ]
		  ensure: [ self pendingRequests removeKey: requestId ifAbsent: [  ] ]
]

{ #category : 'read loop' }
ACPConnection >> startReadLoop [

	self readProcess: ([self readLoop] forkAt: Processor lowIOPriority named: 'ACP readLoop')
]

{ #category : 'operations' }
ACPConnection >> terminateIncomingRequests [
	"Terminate all running incoming request processes without responding.
	 Used on close and as an emergency cleanup; the calling process itself is never terminated."

	| processes |
	processes := incomingRequestsMutex critical: [
		             | all |
		             all := incomingRequests values.
		             incomingRequests removeAll.
		             cancellationTokens removeAll.
		             all ].
	processes do: [ :each |
		each == Processor activeProcess ifFalse: [ each terminate ] ]
]

{ #category : 'accessing' }
ACPConnection >> transport [

	^ transport
]

{ #category : 'accessing' }
ACPConnection >> transport: anACPNdJsonTransport [

	transport := anACPNdJsonTransport
]

{ #category : 'private' }
ACPConnection >> unregisterIncomingRequest: aRequestId [

	incomingRequestsMutex critical: [
		incomingRequests removeKey: aRequestId ifAbsent: [  ].
		cancellationTokens removeKey: aRequestId ifAbsent: [  ] ]
]

{ #category : 'operations' }
ACPConnection >> waitForClose [

	self closeSemaphore wait
]
