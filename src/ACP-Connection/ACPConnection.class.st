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
	#category : 'ACP-Connection'
}

{ #category : 'instance creation' }
ACPConnection class >> on: anACPNdJsonTransport [

	^ self new
		  transport: anACPNdJsonTransport;
		  yourself
]

{ #category : 'accessing' }
ACPConnection >> closeSemaphore [

	^ closeSemaphore
]

{ #category : 'accessing' }
ACPConnection >> id [

	^ id
]

{ #category : 'accessing' }
ACPConnection >> id: anInteger [

	id := anInteger
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

{ #category : 'accessing' }
ACPConnection >> pendingRequests [

	^ pendingRequests
]

{ #category : 'accessing' }
ACPConnection >> readProcess [

	^ readProcess
]

{ #category : 'accessing' }
ACPConnection >> readProcess: aProcess [

	readProcess := aProcess
]

{ #category : 'accessing' }
ACPConnection >> transport [

	^ transport
]

{ #category : 'accessing' }
ACPConnection >> transport: anACPNdJsonTransport [

	transport := anACPNdJsonTransport
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

{ #category : 'private' }
ACPConnection >> nextId [

	self id: self id + 1.
	^ self id
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

{ #category : 'sending' }
ACPConnection >> sendNotification: method params: params [

	self transport writeMessage: {
		'jsonrpc' -> '2.0'.
		'method' -> method.
		'params' -> params
	} asDictionary
]

{ #category : 'read loop' }
ACPConnection >> startReadLoop [

	self readProcess: ([self readLoop] forkAt: Processor lowIOPriority named: 'ACP readLoop')
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

{ #category : 'private' }
ACPConnection >> handleIncomingRequest: message [

	| jsonString responseJson |
	jsonString := STONJSON toString: message.
	responseJson := self messageProcessor handleJSON: jsonString.
	(responseJson isNil or: [ responseJson isEmpty ]) ifTrue: [ ^ self ].
	self transport writeMessage: (STONJSON fromString: responseJson)
]

{ #category : 'private' }
ACPConnection >> handleIncomingNotification: message [

	| jsonString |
	jsonString := STONJSON toString: message.
	self messageProcessor handleJSON: jsonString
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

{ #category : 'operations' }
ACPConnection >> close [

	self isClosed: true.
	self transport ifNotNil: [ :t | t close ].
	self readProcess ifNotNil: [ :p | p terminate ]
]

{ #category : 'operations' }
ACPConnection >> waitForClose [

	self closeSemaphore wait
]
