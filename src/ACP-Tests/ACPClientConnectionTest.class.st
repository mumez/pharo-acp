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
		assert: (((request at: 'params') at: 'capabilities') at: 'terminal')
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
		assert: (((request at: 'params') at: 'capabilities') at: 'terminal')
		equals: true
]

{ #category : 'tests' }
ACPClientConnectionTest >> testInitializeWithRawDictionary [

	| request |
	[
	clientConnection initialize:
		{ ('protocolVersion' -> 1). ('capabilities' -> { ('terminal' -> true) } asDictionary) } asDictionary ]
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
	self assert: (result configOptions second at: 'id') equals: 'model'.
	self assert: (result configOptions second at: 'currentValue') equals: 'model-1'
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
