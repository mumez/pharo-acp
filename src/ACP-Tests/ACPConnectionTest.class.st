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

{ #category : 'helpers' }
ACPConnectionTest >> addBlockingHandlerNamed: aMethodName started: startedSemaphore release: releaseSemaphore [
	"Register a request handler that signals startedSemaphore and then blocks until releaseSemaphore is signaled."

	clientConnection messageProcessor
		addHandlerNamed: aMethodName
		block: [ :params |
			startedSemaphore signal.
			releaseSemaphore wait.
			{ ('done' -> true) } asDictionary ]
]

{ #category : 'helpers' }
ACPConnectionTest >> agentReadMessage [
	"Read the next message written by the client, failing instead of hanging if none arrives."

	| message received reader |
	received := Semaphore new.
	reader := [
	          message := agentTransport readMessage.
	          received signal ] fork.
	(received waitTimeoutSeconds: 2) ifTrue: [
		reader terminate.
		self fail: 'No message from the client within 2 seconds' ].
	^ message
]

{ #category : 'helpers' }
ACPConnectionTest >> agentSendCancelRequestFor: aRequestId [

	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('method' -> '$/cancel_request').
			('params' -> { ('requestId' -> aRequestId) } asDictionary) }
			asDictionary
]

{ #category : 'helpers' }
ACPConnectionTest >> agentSendRequest: aMethodName id: aRequestId [

	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('id' -> aRequestId).
			('method' -> aMethodName).
			('params' -> Dictionary new) } asDictionary
]

{ #category : 'helpers' }
ACPConnectionTest >> assertSemaphore: aSemaphore signaledWithin: seconds [

	self deny: (aSemaphore waitTimeoutSeconds: seconds)
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

	| result1 result2 sem req1 req2 firstReq secondReq |
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
	"Identify requests by method name regardless of arrival order"
	firstReq := { req1. req2 } detect: [ :r | (r at: 'method') = 'first' ].
	secondReq := { req1. req2 } detect: [ :r | (r at: 'method') = 'second' ].
	"Respond in reverse order to test ID-based matching"
	self agentRespondTo: secondReq with: { 'n' -> 2 } asDictionary.
	self agentRespondTo: firstReq with: { 'n' -> 1 } asDictionary.
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

{ #category : 'helpers' }
ACPConnectionTest >> addCooperativeHandlerNamed: aMethodName started: startedSemaphore onWake: aBlock [
	"Register a request handler that waits until its request is cancelled, then answers aBlock value: token."

	clientConnection messageProcessor
		addHandlerNamed: aMethodName
		block: [ :params |
			| token wake |
			token := ACPCancellationToken current.
			wake := Semaphore new.
			token whenCancelledDo: [ wake signal ].
			startedSemaphore signal.
			wake wait.
			aBlock value: token ]
]

{ #category : 'tests - cancellation' }
ACPConnectionTest >> testIncomingRequestDoesNotBlockReadLoop [

	| started release notified |
	started := Semaphore new.
	release := Semaphore new.
	notified := Semaphore new.
	self addBlockingHandlerNamed: 'test/block' started: started release: release.
	clientConnection messageProcessor
		addHandlerNamed: 'test/event'
		block: [ :params | notified signal ].
	clientConnection startReadLoop.
	self agentSendRequest: 'test/block' id: 1.
	self assertSemaphore: started signaledWithin: 2.
	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('method' -> 'test/event').
			('params' -> Dictionary new) } asDictionary.
	self assertSemaphore: notified signaledWithin: 2.
	release signal.
	self assert: (self agentReadMessage at: 'id') equals: 1
]

{ #category : 'tests - cancellation' }
ACPConnectionTest >> testCompletedIncomingRequestIsUnregistered [

	clientConnection messageProcessor
		addHandlerNamed: 'test/ping'
		block: [ :params | { ('pong' -> true) } asDictionary ].
	clientConnection startReadLoop.
	self agentSendRequest: 'test/ping' id: 1.
	self assert: (self agentReadMessage at: 'id') equals: 1.
	self assert: clientConnection incomingRequestProcesses isEmpty
]

{ #category : 'tests - cancellation' }
ACPConnectionTest >> testCancelRequestRespondsWithRequestCancelled [

	| started response |
	started := Semaphore new.
	self
		addCooperativeHandlerNamed: 'test/wait'
		started: started
		onWake: [ :token |
			token signalIfCancelled.
			{ ('done' -> true) } asDictionary ].
	clientConnection startReadLoop.
	self agentSendRequest: 'test/wait' id: 5.
	self assertSemaphore: started signaledWithin: 2.
	self agentSendCancelRequestFor: 5.
	response := self agentReadMessage.
	self assert: (response at: 'id') equals: 5.
	self assert: ((response at: 'error') at: 'code') equals: -32800.
	self assert: clientConnection incomingRequestProcesses isEmpty
]

{ #category : 'tests - cancellation' }
ACPConnectionTest >> testCancelledHandlerCanReturnPartialResult [

	| started response |
	started := Semaphore new.
	self
		addCooperativeHandlerNamed: 'test/wait'
		started: started
		onWake: [ :token | { ('partial' -> token isCancelled) } asDictionary ].
	clientConnection startReadLoop.
	self agentSendRequest: 'test/wait' id: 6.
	self assertSemaphore: started signaledWithin: 2.
	self agentSendCancelRequestFor: 6.
	response := self agentReadMessage.
	self assert: (response at: 'id') equals: 6.
	self assert: ((response at: 'result') at: 'partial') equals: true
]

{ #category : 'tests - cancellation' }
ACPConnectionTest >> testCancelRequestIsNotSwallowedByErrorHandler [

	| started response |
	started := Semaphore new.
	self
		addCooperativeHandlerNamed: 'test/wait'
		started: started
		onWake: [ :token |
			[
			token signalIfCancelled.
			{ ('done' -> true) } asDictionary ]
				on: Error
				do: [ :e | e return: { ('swallowed' -> true) } asDictionary ] ].
	clientConnection startReadLoop.
	self agentSendRequest: 'test/wait' id: 8.
	self assertSemaphore: started signaledWithin: 2.
	self agentSendCancelRequestFor: 8.
	response := self agentReadMessage.
	self assert: ((response at: 'error') at: 'code') equals: -32800
]

{ #category : 'tests - cancellation' }
ACPConnectionTest >> testHandlerIgnoringCancellationCompletesNormally [

	| started release response |
	started := Semaphore new.
	release := Semaphore new.
	self addBlockingHandlerNamed: 'test/block' started: started release: release.
	clientConnection startReadLoop.
	self agentSendRequest: 'test/block' id: 9.
	self assertSemaphore: started signaledWithin: 2.
	self agentSendCancelRequestFor: 9.
	release signal.
	response := self agentReadMessage.
	self assert: (response at: 'id') equals: 9.
	self assert: ((response at: 'result') at: 'done') equals: true
]

{ #category : 'tests - cancellation' }
ACPConnectionTest >> testCancelRequestForUnknownIdIsIgnored [

	clientConnection messageProcessor
		addHandlerNamed: 'test/ping'
		block: [ :params | { ('pong' -> true) } asDictionary ].
	clientConnection startReadLoop.
	self agentSendCancelRequestFor: 999.
	self agentSendRequest: 'test/ping' id: 1.
	self
		assert: ((self agentReadMessage at: 'result') at: 'pong')
		equals: true
]

{ #category : 'tests - cancellation' }
ACPConnectionTest >> testDuplicateIncomingRequestIdIsRejected [

	| started release response |
	started := Semaphore new.
	release := Semaphore new.
	self addBlockingHandlerNamed: 'test/block' started: started release: release.
	clientConnection startReadLoop.
	self agentSendRequest: 'test/block' id: 7.
	self assertSemaphore: started signaledWithin: 2.
	self agentSendRequest: 'test/block' id: 7.
	response := self agentReadMessage.
	self assert: (response at: 'id') equals: 7.
	self assert: ((response at: 'error') at: 'code') equals: -32600.
	self assert: clientConnection incomingRequestProcesses size equals: 1.
	release signal.
	self assert: (self agentReadMessage at: 'result') notNil
]

{ #category : 'tests - cancellation' }
ACPConnectionTest >> testCloseTerminatesIncomingRequests [

	| started release process |
	started := Semaphore new.
	release := Semaphore new.
	self addBlockingHandlerNamed: 'test/block' started: started release: release.
	clientConnection startReadLoop.
	self agentSendRequest: 'test/block' id: 1.
	self assertSemaphore: started signaledWithin: 2.
	process := clientConnection incomingRequestProcesses at: 1.
	clientConnection close.
	self assert: process isTerminated.
	self assert: clientConnection incomingRequestProcesses isEmpty
]

{ #category : 'tests - cancellation' }
ACPConnectionTest >> testTerminateIncomingRequests [

	| started release process |
	started := Semaphore new.
	release := Semaphore new.
	self addBlockingHandlerNamed: 'test/block' started: started release: release.
	clientConnection startReadLoop.
	self agentSendRequest: 'test/block' id: 1.
	self assertSemaphore: started signaledWithin: 2.
	process := clientConnection incomingRequestProcesses at: 1.
	clientConnection terminateIncomingRequests.
	self assert: process isTerminated.
	self assert: clientConnection incomingRequestProcesses isEmpty.
	self deny: clientConnection isClosed
]

{ #category : 'tests - incoming' }
ACPConnectionTest >> testIncomingRequestForUnknownMethodReturnsErrorResponse [

	| response |
	clientConnection startReadLoop.
	self agentSendRequest: 'test/unknown' id: 3.
	response := self agentReadMessage.
	self assert: (response at: 'jsonrpc') equals: '2.0'.
	self assert: (response at: 'id') equals: 3.
	self assert: ((response at: 'error') at: 'code') equals: -32601.
	self deny: (response includesKey: 'result')
]

{ #category : 'tests - incoming' }
ACPConnectionTest >> testIncomingRequestHandlerErrorReturnsErrorResponse [

	| response |
	clientConnection messageProcessor
		addHandlerNamed: 'test/fail'
		block: [ :params | Error signal: 'boom' ].
	clientConnection startReadLoop.
	self agentSendRequest: 'test/fail' id: 4.
	response := self agentReadMessage.
	self assert: (response at: 'jsonrpc') equals: '2.0'.
	self assert: (response at: 'id') equals: 4.
	self assert: ((response at: 'error') at: 'code') isInteger.
	self assert: clientConnection incomingRequestProcesses isEmpty
]
