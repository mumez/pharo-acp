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
ACP2ClientConnectionTest >> testBasicExchangeMimicsDualVersionAgent [
	"Mimics the TypeScript SDK's dual-version-agent.ts v2 handler: initialize -> session/new ->
	session/prompt, with session/update notifications (user_message, agent_message, state_update)
	delivered to the handler before prompt: returns."

	| sem sessionId request initResult sessionResult promptResult |
	sem := Semaphore new.
	connection startReadLoop.

	[
	initResult := clientConnection initializeBy: [ :p | ].
	sessionResult := clientConnection newSessionBy: [ :p | p cwd: '/tmp' ].
	promptResult := clientConnection promptBy: [ :p |
		p sessionId: sessionResult sessionId.
		p textPrompt: 'Hello, agent!' ].
	sem signal ] forkAt: Processor userBackgroundPriority.

	"initialize"
	request := agentTransport readMessage.
	self assert: (request at: 'method') equals: 'initialize'.
	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('id' -> (request at: 'id')).
			('result' -> {
				 ('protocolVersion' -> 2).
				 ('info' -> { ('name' -> 'dual-version-example') } asDictionary) }
				 asDictionary) } asDictionary.

	"session/new"
	request := agentTransport readMessage.
	self assert: (request at: 'method') equals: 'session/new'.
	sessionId := 'sess-001'.
	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('id' -> (request at: 'id')).
			('result' -> { ('sessionId' -> sessionId) } asDictionary) } asDictionary.

	"session/prompt"
	request := agentTransport readMessage.
	self assert: (request at: 'method') equals: 'session/prompt'.
	self assert: ((request at: 'params') at: 'sessionId') equals: sessionId.

	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('method' -> 'session/update').
			('params' -> {
				 ('sessionId' -> sessionId).
				 ('update' -> { ('sessionUpdate' -> 'user_message') } asDictionary) }
				 asDictionary) } asDictionary.
	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('method' -> 'session/update').
			('params' -> {
				 ('sessionId' -> sessionId).
				 ('update' -> { ('sessionUpdate' -> 'agent_message') } asDictionary) }
				 asDictionary) } asDictionary.
	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('method' -> 'session/update').
			('params' -> {
				 ('sessionId' -> sessionId).
				 ('update' -> {
					  ('sessionUpdate' -> 'state_update').
					  ('state' -> 'idle').
					  ('stopReason' -> 'end_turn') } asDictionary) }
				 asDictionary) } asDictionary.
	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('id' -> (request at: 'id')).
			('result' -> Dictionary new) } asDictionary.

	sem wait.

	self assert: initResult protocolVersion equals: 2.
	self assert: sessionResult sessionId equals: sessionId.
	self assert: promptResult notNil.

	self assert: handler updates size equals: 3.
	self assert: handler updates first sessionUpdate equals: 'user_message'.
	self assert: handler updates second sessionUpdate equals: 'agent_message'.
	self assert: handler updates third sessionUpdate equals: 'state_update'.
	self assert: handler updates last stopReason equals: 'end_turn'
]

{ #category : 'tests' }
ACP2ClientConnectionTest >> testCancelSendsNotificationWithoutWaitingForResponse [

	| notification |
	clientConnection cancelBy: [ :p | p sessionId: 'sess-001' ].
	notification := agentTransport readMessage.
	self assert: (notification at: 'method') equals: 'session/cancel'.
	self deny: (notification includesKey: 'id')
]

{ #category : 'tests' }
ACP2ClientConnectionTest >> testCloseSessionBySendsCorrectRequest [

	| request sem |
	sem := Semaphore new.
	connection startReadLoop.
	[
	clientConnection closeSessionBy: [ :p | p sessionId: 'sess-001' ].
	sem signal ] forkAt: Processor userBackgroundPriority.
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
ACP2ClientConnectionTest >> testDeleteSessionBySendsCorrectRequest [

	| request sem |
	sem := Semaphore new.
	connection startReadLoop.
	[
	clientConnection deleteSessionBy: [ :p | p sessionId: 'sess-001' ].
	sem signal ] forkAt: Processor userBackgroundPriority.
	request := agentTransport readMessage.
	self assert: (request at: 'method') equals: 'session/delete'.
	self assert: ((request at: 'params') at: 'sessionId') equals: 'sess-001'.
	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('id' -> (request at: 'id')).
			('result' -> Dictionary new) } asDictionary.
	sem wait
]

{ #category : 'tests' }
ACP2ClientConnectionTest >> testUnimplementedTerminalRequestReturnsMethodNotFound [

	| response sem |
	sem := Semaphore new.
	connection startReadLoop.
	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('id' -> 1).
			('method' -> 'terminal/create').
			('params' -> { ('command' -> 'ls') } asDictionary) } asDictionary.
	[
	response := agentTransport readMessage.
	sem signal ] fork.
	self deny: (sem waitTimeoutSeconds: 2).
	self assert: ((response at: 'error') at: 'code') equals: -32601
]

{ #category : 'helpers - elicitation' }
ACP2ClientConnectionTest >> advertiseElicitationForm [

	clientConnection clientCapabilities elicitation enableForm
]

{ #category : 'helpers - elicitation' }
ACP2ClientConnectionTest >> agentReadMessage [
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

{ #category : 'helpers - elicitation' }
ACP2ClientConnectionTest >> agentSendElicitationMode: aMode id: aRequestId [

	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('id' -> aRequestId).
			('method' -> 'elicitation/create').
			('params' -> {
				 ('sessionId' -> 'sess-001').
				 ('mode' -> aMode).
				 ('message' -> 'Project name?').
				 ('requestedSchema' -> {
					  ('type' -> 'object').
					  ('properties'
					   -> { ('name' -> { ('type' -> 'string') } asDictionary) } asDictionary) }
					  asDictionary).
				 ('elicitationId' -> 'elic-001').
				 ('url' -> 'https://example.com/form') } asDictionary) } asDictionary
]

{ #category : 'tests - elicitation' }
ACP2ClientConnectionTest >> testClientCapabilitiesAreEmptyBeforeInitialize [

	self deny: clientConnection clientCapabilities elicitation isFormSupported.
	self deny: clientConnection clientCapabilities elicitation isUrlSupported
]

{ #category : 'tests - elicitation' }
ACP2ClientConnectionTest >> testCompleteElicitationIsDelegatedToHandler [

	connection startReadLoop.
	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('method' -> 'elicitation/complete').
			('params' -> { ('elicitationId' -> 'elic-001') } asDictionary) } asDictionary.
	"Notifications are handled in order in the read loop, so once the next request is answered
	 the notification has been handled."
	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('id' -> 2).
			('method' -> 'session/request_permission').
			('params' -> { ('sessionId' -> 'sess-001') } asDictionary) } asDictionary.
	self agentReadMessage.
	self assert: handler completedElicitationIds asArray equals: #( 'elic-001' )
]

{ #category : 'tests - elicitation' }
ACP2ClientConnectionTest >> testCreateElicitationIsDelegatedToHandler [

	| response |
	self advertiseElicitationForm.
	connection startReadLoop.
	self agentSendElicitationMode: 'form' id: 7.
	response := self agentReadMessage.
	self assert: (response at: 'id') equals: 7.
	self assert: ((response at: 'result') at: 'action') equals: 'accept'.
	self assert: (((response at: 'result') at: 'content') at: 'name') equals: 'mock'.
	self assert: handler elicitationRequest class equals: ACP2CreateElicitation.
	self assert: handler elicitationRequest message equals: 'Project name?'.
	self assert: handler elicitationRequest requestedSchema class equals: ACP2ElicitationSchema
]

{ #category : 'tests - elicitation' }
ACP2ClientConnectionTest >> testCreateElicitationWithDefaultHandlerIsRejected [

	| response |
	clientConnection handler: ACP2TranscriptHandler new.
	self advertiseElicitationForm.
	connection startReadLoop.
	self agentSendElicitationMode: 'form' id: 8.
	response := self agentReadMessage.
	self assert: ((response at: 'error') at: 'code') equals: -32602
]

{ #category : 'tests - elicitation' }
ACP2ClientConnectionTest >> testCreateElicitationWithUnadvertisedModeIsRejected [

	| response |
	connection startReadLoop.
	self agentSendElicitationMode: 'form' id: 9.
	response := self agentReadMessage.
	self assert: (response at: 'id') equals: 9.
	self assert: ((response at: 'error') at: 'code') equals: -32602.
	self assert: handler elicitationRequest isNil
]

{ #category : 'tests - elicitation' }
ACP2ClientConnectionTest >> testCreateElicitationWithUrlModeNeedsUrlCapability [

	| response |
	self advertiseElicitationForm.
	connection startReadLoop.
	self agentSendElicitationMode: 'url' id: 10.
	response := self agentReadMessage.
	self assert: ((response at: 'error') at: 'code') equals: -32602.
	self assert: handler elicitationRequest isNil
]

{ #category : 'tests - elicitation' }
ACP2ClientConnectionTest >> testInitializeRemembersClientCapabilities [

	| request |
	connection startReadLoop.
	[
	clientConnection initializeBy: [ :p |
		p capabilities elicitation enableForm ] ] forkAt:
		Processor userBackgroundPriority.
	request := self agentReadMessage.
	self
		assert: (((request at: 'params') at: 'capabilities') at: 'elicitation')
		equals: { ('form' -> Dictionary new) } asDictionary.
	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('id' -> (request at: 'id')).
			('result' -> { ('protocolVersion' -> 2) } asDictionary) } asDictionary.
	self assert: clientConnection clientCapabilities elicitation isFormSupported.
	self deny: clientConnection clientCapabilities elicitation isUrlSupported
]
