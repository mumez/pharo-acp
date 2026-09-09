Class {
	#name : 'ACP2ClientConnectionTest',
	#superclass : 'TestCase',
	#instVars : [
		'clientConnection',
		'agentTransport',
		'handler',
		'connection'
	],
	#category : 'ACP2-Tests',
	#package : 'ACP2-Tests'
}

{ #category : 'running' }
ACP2ClientConnectionTest >> setUp [

	| pair |
	super setUp.
	pair := ACP2TestTransport loopbackPair.
	connection := ACP2Connection on: pair first.
	handler := ACP2MockHandler new.
	clientConnection := ACP2ClientConnection on: connection handler: handler.
	agentTransport := pair second
]

{ #category : 'running' }
ACP2ClientConnectionTest >> tearDown [

	connection ifNotNil: [ :c | c close ].
	super tearDown
]

{ #category : 'tests' }
ACP2ClientConnectionTest >> testInitializeBySendsCorrectRequest [

	| request |
	[
	clientConnection initializeBy: [ :p |
		p capabilities terminal: true ] ]
		forkAt: Processor userBackgroundPriority.
	request := agentTransport readMessage.
	self assert: (request at: 'method') equals: 'initialize'.
	self
		assert: (((request at: 'params') at: 'capabilities') at: 'terminal')
		equals: true
]

{ #category : 'tests' }
ACP2ClientConnectionTest >> testInitializeSendsCorrectRequest [

	| request sem response |
	sem := Semaphore new.
	connection startReadLoop.
	[
	response := clientConnection initialize: (ACP2InitializeParams buildBy: [ :p |
			 p capabilities terminal: true ]).
	sem signal ] forkAt: Processor userBackgroundPriority.
	request := agentTransport readMessage.
	self assert: (request at: 'method') equals: 'initialize'.
	self
		assert: ((request at: 'params') at: 'protocolVersion')
		equals: 2.
	self
		assert: (((request at: 'params') at: 'capabilities') at: 'terminal')
		equals: true.
	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('id' -> (request at: 'id')).
			('result' -> {
				 ('protocolVersion' -> 2).
				 ('info' -> { ('name' -> 'dual-version-example') } asDictionary) }
				 asDictionary) } asDictionary.
	sem wait.
	self assert: response protocolVersion equals: 2
]

{ #category : 'tests' }
ACP2ClientConnectionTest >> testInitializeWithRawDictionary [

	| request |
	[
	clientConnection initialize:
		{ ('protocolVersion' -> 2). ('capabilities' -> { ('terminal' -> true) } asDictionary) } asDictionary ]
		forkAt: Processor userBackgroundPriority.
	request := agentTransport readMessage.
	self assert: (request at: 'method') equals: 'initialize'.
	self assert: ((request at: 'params') at: 'protocolVersion') equals: 2
]

{ #category : 'tests' }
ACP2ClientConnectionTest >> testRequestPermissionIsDelegatedToHandler [

	| response sem |
	sem := Semaphore new.
	connection startReadLoop.
	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('id' -> 1).
			('method' -> 'session/request_permission').
			('params' -> { ('tool' -> 'ls') } asDictionary) } asDictionary.

	[ response := agentTransport readMessage. sem signal ] fork.
	sem wait.

	self assert: handler permissionRequest notNil.
	self assert: handler permissionRequest class equals: ACP2RequestPermission.
	self assert: ((response at: 'result') at: 'outcome') notNil
]

{ #category : 'tests' }
ACP2ClientConnectionTest >> testSessionUpdateIsDelegatedToHandler [

	| sem |
	sem := Semaphore new.
	connection startReadLoop.
	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('method' -> 'session/update').
			('params' -> {
				('sessionId' -> 'sess-001').
				('update' -> { ('sessionUpdate' -> 'agent_message_chunk') } asDictionary) }
				asDictionary) } asDictionary.

	"Wait a bit for the read loop to process"
	[
	(Delay forMilliseconds: 200) wait.
	sem signal ] fork.
	sem wait.

	self assert: handler lastUpdate notNil.
	self assert: handler lastUpdate class equals: ACP2SessionUpdate.
	self assert: handler lastUpdate sessionUpdate equals: 'agent_message_chunk'
]

{ #category : 'tests' }
ACP2ClientConnectionTest >> testResumeSessionBySendsCorrectRequest [

	| request sem |
	sem := Semaphore new.
	connection startReadLoop.
	[
	clientConnection resumeSessionBy: [ :p |
		p sessionId: 'sess-001'.
		p cwd: '/tmp' ].
	sem signal ]
		forkAt: Processor userBackgroundPriority.
	request := agentTransport readMessage.
	self assert: (request at: 'method') equals: 'session/resume'.
	self assert: ((request at: 'params') at: 'sessionId') equals: 'sess-001'.
	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('id' -> (request at: 'id')).
			('result' -> Dictionary new) } asDictionary.
	sem wait
]

{ #category : 'tests' }
ACP2ClientConnectionTest >> testCloseSessionSendsCorrectRequest [

	| request sem |
	sem := Semaphore new.
	connection startReadLoop.
	[
	clientConnection closeSessionBy: [ :p | p sessionId: 'sess-001' ].
	sem signal ]
		forkAt: Processor userBackgroundPriority.
	request := agentTransport readMessage.
	self assert: (request at: 'method') equals: 'session/close'.
	self assert: ((request at: 'params') at: 'sessionId') equals: 'sess-001'.
	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('id' -> (request at: 'id')).
			('result' -> Dictionary new) } asDictionary.
	sem wait
]

{ #category : 'tests' }
ACP2ClientConnectionTest >> testLogoutSendsCorrectRequest [

	| request sem |
	sem := Semaphore new.
	connection startReadLoop.
	[
	clientConnection logout: ACP2AuthLogoutParams new.
	sem signal ]
		forkAt: Processor userBackgroundPriority.
	request := agentTransport readMessage.
	self assert: (request at: 'method') equals: 'auth/logout'.
	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('id' -> (request at: 'id')).
			('result' -> Dictionary new) } asDictionary.
	sem wait
]

{ #category : 'tests' }
ACP2ClientConnectionTest >> testListSessionsSendsCorrectRequest [

	| request sem |
	sem := Semaphore new.
	connection startReadLoop.
	[
	clientConnection listSessionsBy: [ :p | p cwd: '/tmp' ].
	sem signal ]
		forkAt: Processor userBackgroundPriority.
	request := agentTransport readMessage.
	self assert: (request at: 'method') equals: 'session/list'.
	self assert: ((request at: 'params') at: 'cwd') equals: '/tmp'.
	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('id' -> (request at: 'id')).
			('result' -> { ('sessions' -> #()) } asDictionary) } asDictionary.
	sem wait
]

{ #category : 'tests' }
ACP2ClientConnectionTest >> testCancelSendsNotificationWithoutWaitingForResponse [

	| notification |
	clientConnection cancelBy: [ :p | p sessionId: 'sess-001' ].
	notification := agentTransport readMessage.
	self assert: (notification at: 'method') equals: 'session/cancel'.
	self deny: (notification includesKey: 'id')
]
