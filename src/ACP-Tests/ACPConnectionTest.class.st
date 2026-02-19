Class {
	#name : 'ACPConnectionTest',
	#superclass : 'TestCase',
	#instVars : [
		'clientConnection',
		'agentTransport'
	],
	#category : 'ACP-Tests',
	#package : 'ACP-Tests'
}

{ #category : 'helpers' }
ACPConnectionTest >> agentRespondTo: aRequest with: aResult [
	"Send a success response back through the agent transport."

	agentTransport writeMessage: {
		'jsonrpc' -> '2.0'.
		'id' -> (aRequest at: 'id').
		'result' -> aResult
	} asDictionary
]

{ #category : 'helpers' }
ACPConnectionTest >> agentRespondTo: aRequest withError: anErrorDict [
	"Send an error response back through the agent transport."

	agentTransport writeMessage: {
		'jsonrpc' -> '2.0'.
		'id' -> (aRequest at: 'id').
		'error' -> anErrorDict
	} asDictionary
]

{ #category : 'running' }
ACPConnectionTest >> setUp [

	| pair |
	super setUp.
	pair := ACPTestTransport loopbackPair.
	clientConnection := ACPConnection on: pair first.
	agentTransport := pair second
]

{ #category : 'running' }
ACPConnectionTest >> tearDown [

	clientConnection close.
	super tearDown
]

{ #category : 'tests - connection close' }
ACPConnectionTest >> testCloseMarksConnectionAsClosed [

	clientConnection close.
	self assert: clientConnection isClosed
]

{ #category : 'tests - request response' }
ACPConnectionTest >> testConcurrentRequests [

	| result1 result2 sem req1 req2 |
	sem := Semaphore new.
	result1 := nil.
	result2 := nil.
	clientConnection startReadLoop.
	[
		result1 := clientConnection sendRequest: 'first' params: Dictionary new.
		sem signal
	] forkAt: Processor userBackgroundPriority.
	[
		result2 := clientConnection sendRequest: 'second' params: Dictionary new.
		sem signal
	] forkAt: Processor userBackgroundPriority.
	req1 := agentTransport readMessage.
	req2 := agentTransport readMessage.
	"Respond in reverse order"
	self agentRespondTo: req2 with: { 'n' -> 2 } asDictionary.
	self agentRespondTo: req1 with: { 'n' -> 1 } asDictionary.
	sem wait.
	sem wait.
	self assert: (result1 at: 'n') equals: 1.
	self assert: (result2 at: 'n') equals: 2
]

{ #category : 'tests - connection close' }
ACPConnectionTest >> testConnectionCloseRejectsPendingRequests [

	| sem caught |
	caught := nil.
	sem := Semaphore new.
	clientConnection startReadLoop.
	[
		[ clientConnection sendRequest: 'slow' params: Dictionary new ]
			on: ACPRequestError
			do: [ :e | caught := e ].
		sem signal
	] forkAt: Processor userBackgroundPriority.
	"Wait for request to be sent"
	agentTransport readMessage.
	"Close the agent side"
	agentTransport close.
	sem wait.
	self assert: caught isNotNil.
	self assert: caught rpcMessage equals: 'Connection closed'
]

{ #category : 'tests - incoming' }
ACPConnectionTest >> testIncomingNotificationDispatch [

	| received sem |
	received := nil.
	sem := Semaphore new.
	clientConnection messageProcessor
		addHandlerNamed: 'test/event'
		block: [ :params |
			received := params.
			sem signal ].
	clientConnection startReadLoop.
	agentTransport writeMessage: {
		'jsonrpc' -> '2.0'.
		'method' -> 'test/event'.
		'params' -> { 'type' -> 'update' } asDictionary
	} asDictionary.
	sem wait.
	self assert: (received at: 'type') equals: 'update'
]

{ #category : 'tests - incoming' }
ACPConnectionTest >> testIncomingRequestDispatch [

	| received sem response |
	received := nil.
	sem := Semaphore new.
	clientConnection messageProcessor
		addHandlerNamed: 'test/ping'
		block: [ :params |
			received := params.
			sem signal.
			{ 'pong' -> true } asDictionary ].
	clientConnection startReadLoop.
	agentTransport writeMessage: {
		'jsonrpc' -> '2.0'.
		'id' -> 99.
		'method' -> 'test/ping'.
		'params' -> { 'data' -> 42 } asDictionary
	} asDictionary.
	sem wait.
	self assert: (received at: 'data') equals: 42.
	response := agentTransport readMessage.
	self assert: (response at: 'id') equals: 99.
	self assert: ((response at: 'result') at: 'pong') equals: true
]

{ #category : 'tests - id' }
ACPConnectionTest >> testNextIdIsMonotonicallyIncreasing [

	| id1 id2 id3 |
	id1 := clientConnection nextId.
	id2 := clientConnection nextId.
	id3 := clientConnection nextId.
	self assert: id2 > id1.
	self assert: id3 > id2
]

{ #category : 'tests - request response' }
ACPConnectionTest >> testRequestErrorResponse [

	| sem caught request |
	caught := nil.
	sem := Semaphore new.
	clientConnection startReadLoop.
	[
		[ clientConnection sendRequest: 'fail' params: Dictionary new ]
			on: ACPRequestError
			do: [ :e | caught := e ].
		sem signal
	] forkAt: Processor userBackgroundPriority.
	request := agentTransport readMessage.
	self agentRespondTo: request withError: {
		'code' -> -32601.
		'message' -> 'Method not found'
	} asDictionary.
	sem wait.
	self assert: caught isNotNil.
	self assert: caught code equals: -32601
]

{ #category : 'tests - request response' }
ACPConnectionTest >> testRequestResponseRoundTrip [

	| result sem request |
	result := nil.
	sem := Semaphore new.
	clientConnection startReadLoop.
	[
		result := clientConnection
			sendRequest: 'echo'
			params: { 'msg' -> 'hello' } asDictionary.
		sem signal
	] forkAt: Processor userBackgroundPriority.
	request := agentTransport readMessage.
	self agentRespondTo: request with: { 'reply' -> 'world' } asDictionary.
	sem wait.
	self assert: (result at: 'reply') equals: 'world'
]

{ #category : 'tests - sending' }
ACPConnectionTest >> testSendNotificationOmitsId [

	| sent |
	clientConnection sendNotification: 'notify' params: Dictionary new.
	sent := agentTransport readMessage.
	self deny: (sent includesKey: 'id')
]

{ #category : 'tests - sending' }
ACPConnectionTest >> testSendNotificationWritesJsonRpc [

	| sent |
	clientConnection sendNotification: 'test/notify' params: { 'a' -> 1 } asDictionary.
	sent := agentTransport readMessage.
	self assert: (sent at: 'jsonrpc') equals: '2.0'.
	self assert: (sent at: 'method') equals: 'test/notify'.
	self deny: (sent includesKey: 'id')
]

{ #category : 'tests - sending' }
ACPConnectionTest >> testSendRequestWritesJsonRpc [

	| sent |
	clientConnection startReadLoop.
	[ clientConnection sendRequest: 'test/method' params: { 'key' -> 'value' } asDictionary ]
		forkAt: Processor userBackgroundPriority.
	sent := agentTransport readMessage.
	self assert: (sent at: 'jsonrpc') equals: '2.0'.
	self assert: (sent at: 'method') equals: 'test/method'.
	self assert: ((sent at: 'params') at: 'key') equals: 'value'.
	self assert: (sent includesKey: 'id')
]
