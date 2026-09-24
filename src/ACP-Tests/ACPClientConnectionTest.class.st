Class {
	#name : 'ACPClientConnectionTest',
	#superclass : 'TestCase',
	#instVars : [
		'clientConnection',
		'agentTransport',
		'handler',
		'connection'
	],
	#category : 'ACP-Tests',
	#package : 'ACP-Tests'
}

{ #category : 'running' }
ACPClientConnectionTest >> setUp [

	| pair |
	super setUp.
	pair := ACPTestTransport loopbackPair.
	connection := ACPConnection on: pair first.
	handler := ACPMockHandler new.
	clientConnection := ACPClientConnection on: connection handler: handler.
	agentTransport := pair second
]

{ #category : 'running' }
ACPClientConnectionTest >> tearDown [

	connection ifNotNil: [ :c | c close ].
	super tearDown
]

{ #category : 'tests' }
ACPClientConnectionTest >> testInitializeBySendsCorrectRequest [

	| request |
	[
	clientConnection initializeBy: [ :p |
		p capabilities terminal: true ] ]
		forkAt: Processor userBackgroundPriority.
	request := agentTransport readMessage.
	self assert: (request at: 'method') equals: 'initialize'.
	self
		assert: (((request at: 'params') at: 'clientCapabilities') at: 'terminal')
		equals: true
]

{ #category : 'tests' }
ACPClientConnectionTest >> testInitializeSendsCorrectRequest [

	| request |
	[
	clientConnection initialize: (ACPInitializeParams buildBy: [ :p |
			 p capabilities terminal: true ]) ]
		forkAt: Processor userBackgroundPriority.
	request := agentTransport readMessage.
	self assert: (request at: 'method') equals: 'initialize'.
	self
		assert: ((request at: 'params') at: 'protocolVersion')
		equals: 1.
	self
		assert: (((request at: 'params') at: 'clientCapabilities') at: 'terminal')
		equals: true
]

{ #category : 'tests' }
ACPClientConnectionTest >> testInitializeWithRawDictionary [

	| request |
	[
	clientConnection initialize:
		{ ('protocolVersion' -> 1). ('clientCapabilities' -> { ('terminal' -> true) } asDictionary) } asDictionary ]
		forkAt: Processor userBackgroundPriority.
	request := agentTransport readMessage.
	self assert: (request at: 'method') equals: 'initialize'.
	self assert: ((request at: 'params') at: 'protocolVersion') equals: 1
]

{ #category : 'tests' }
ACPClientConnectionTest >> testRequestPermissionIsDelegatedToHandler [

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
	self assert: handler permissionRequest class equals: ACPRequestPermission.
	self assert: ((response at: 'result') at: 'outcome') notNil
]

{ #category : 'tests' }
ACPClientConnectionTest >> testSessionUpdateIsDelegatedToHandler [

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
	self assert: handler lastUpdate class equals: ACPSessionUpdate.
	self assert: handler lastUpdate sessionId equals: 'sess-001'
]

{ #category : 'tests' }
ACPClientConnectionTest >> testResumeSessionBySendsCorrectRequest [

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
ACPClientConnectionTest >> testSetSessionConfigOptionReturnsBaseSessionResponse [

	| request sem result |
	sem := Semaphore new.
	connection startReadLoop.

	[ result := clientConnection setSessionConfigOption:
		          (ACPSetSessionConfigOptionParams buildBy: [ :p |
			           p sessionId: 'sess-001'.
			           p configId: 'model'.
			           p value: 'model-1' ]).
	sem signal ] forkAt: Processor userBackgroundPriority.

	request := agentTransport readMessage.
	self assert: (request at: 'method') equals: 'session/set_config_option'.
	agentTransport writeMessage: (self setConfigOptionResponseFor: request).

	sem wait.
	self assertSetConfigOptionResult: result
]

{ #category : 'private' }
ACPClientConnectionTest >> assertSetConfigOptionResult: result [

	self assert: result class equals: ACPBaseSessionResponse.
	self assert: result configOptions size equals: 2.
	self assert: result configOptions second class equals: ACPConfigOption.
	self assert: result configOptions second id equals: 'model'.
	self assert: result configOptions second currentValue equals: 'model-1'
]

{ #category : 'private' }
ACPClientConnectionTest >> setConfigOptionResponseFor: request [

	^ {
		  ('jsonrpc' -> '2.0').
		  ('id' -> (request at: 'id')).
		  ('result' -> {
			   ('configOptions' -> {
			    {
				    ('id' -> 'mode').
				    ('name' -> 'Session Mode').
				    ('type' -> 'select').
				    ('currentValue' -> 'code').
				    ('options' -> #()) } asDictionary.
			    {
				    ('id' -> 'model').
				    ('name' -> 'Model').
				    ('type' -> 'select').
				    ('currentValue' -> 'model-1').
				    ('options' -> #()) } asDictionary } asArray) } asDictionary) }
		  asDictionary
]

{ #category : 'tests' }
ACPClientConnectionTest >> testCloseSessionBySendsCorrectRequest [

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
ACPClientConnectionTest >> testDeleteSessionBySendsCorrectRequest [

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
ACPClientConnectionTest >> testLogoutSendsCorrectRequest [

	| request sem |
	sem := Semaphore new.
	connection startReadLoop.
	[
	clientConnection logout.
	sem signal ] forkAt: Processor userBackgroundPriority.
	request := agentTransport readMessage.
	self assert: (request at: 'method') equals: 'logout'.
	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('id' -> (request at: 'id')).
			('result' -> Dictionary new) } asDictionary.
	sem wait
]

{ #category : 'tests' }
ACPClientConnectionTest >> testUnimplementedTerminalRequestReturnsMethodNotFound [

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
ACPClientConnectionTest >> advertiseElicitationForm [

	clientConnection clientCapabilities elicitation enableForm
]

{ #category : 'helpers - elicitation' }
ACPClientConnectionTest >> agentReadMessage [
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
ACPClientConnectionTest >> agentSendElicitationMode: aMode id: aRequestId [

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
ACPClientConnectionTest >> testClientCapabilitiesAreEmptyBeforeInitialize [

	self deny: clientConnection clientCapabilities elicitation isFormSupported.
	self deny: clientConnection clientCapabilities elicitation isUrlSupported
]

{ #category : 'tests - elicitation' }
ACPClientConnectionTest >> testCompleteElicitationIsDelegatedToHandler [

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
ACPClientConnectionTest >> testCreateElicitationIsDelegatedToHandler [

	| response |
	self advertiseElicitationForm.
	connection startReadLoop.
	self agentSendElicitationMode: 'form' id: 7.
	response := self agentReadMessage.
	self assert: (response at: 'id') equals: 7.
	self assert: ((response at: 'result') at: 'action') equals: 'accept'.
	self assert: (((response at: 'result') at: 'content') at: 'name') equals: 'mock'.
	self assert: handler elicitationRequest class equals: ACPCreateElicitation.
	self assert: handler elicitationRequest message equals: 'Project name?'.
	self assert: handler elicitationRequest requestedSchema class equals: ACPElicitationSchema
]

{ #category : 'tests - elicitation' }
ACPClientConnectionTest >> testCreateElicitationWithDefaultHandlerIsRejected [

	| response |
	clientConnection handler: ACPTranscriptHandler new.
	self advertiseElicitationForm.
	connection startReadLoop.
	self agentSendElicitationMode: 'form' id: 8.
	response := self agentReadMessage.
	self assert: ((response at: 'error') at: 'code') equals: -32602
]

{ #category : 'tests - elicitation' }
ACPClientConnectionTest >> testCreateElicitationWithUnadvertisedModeIsRejected [

	| response |
	connection startReadLoop.
	self agentSendElicitationMode: 'form' id: 9.
	response := self agentReadMessage.
	self assert: (response at: 'id') equals: 9.
	self assert: ((response at: 'error') at: 'code') equals: -32602.
	self assert: handler elicitationRequest isNil
]

{ #category : 'tests - elicitation' }
ACPClientConnectionTest >> testCreateElicitationWithUrlModeNeedsUrlCapability [

	| response |
	self advertiseElicitationForm.
	connection startReadLoop.
	self agentSendElicitationMode: 'url' id: 10.
	response := self agentReadMessage.
	self assert: ((response at: 'error') at: 'code') equals: -32602.
	self assert: handler elicitationRequest isNil
]

{ #category : 'tests - elicitation' }
ACPClientConnectionTest >> testInitializeRemembersClientCapabilities [

	| request |
	connection startReadLoop.
	[
	clientConnection initializeBy: [ :p |
		p capabilities elicitation enableForm ] ] forkAt:
		Processor userBackgroundPriority.
	request := self agentReadMessage.
	self
		assert: (((request at: 'params') at: 'clientCapabilities') at: 'elicitation')
		equals: { ('form' -> Dictionary new) } asDictionary.
	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('id' -> (request at: 'id')).
			('result' -> { ('protocolVersion' -> 1) } asDictionary) } asDictionary.
	self assert: clientConnection clientCapabilities elicitation isFormSupported.
	self deny: clientConnection clientCapabilities elicitation isUrlSupported
]
