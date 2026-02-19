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
		'closeSemaphore'
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

{ #category : 'operations' }
ACPConnection >> close [

	self isClosed: true.
	self transport ifNotNil: [ :t | t close ].
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
	self closeSemaphore signal
]

{ #category : 'private' }
ACPConnection >> handleIncomingNotification: message [
	"Dispatch incoming notification via JRPCMessageProcessor using object API."

	| notification |
	notification := JRPCNotificationObject new
		method: (message at: 'method');
		params: { message at: 'params' ifAbsent: [ Dictionary new ] };
		yourself.
	self messageProcessor handleJRPCNotificationObject: notification
]

{ #category : 'private' }
ACPConnection >> handleIncomingRequest: message [
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
	self transport writeMessage: responseDict
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
	messageProcessor := JRPCMessageProcessor new
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

{ #category : 'accessing' }
ACPConnection >> transport [

	^ transport
]

{ #category : 'accessing' }
ACPConnection >> transport: anACPNdJsonTransport [

	transport := anACPNdJsonTransport
]

{ #category : 'operations' }
ACPConnection >> waitForClose [

	self closeSemaphore wait
]
