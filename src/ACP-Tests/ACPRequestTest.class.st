Class {
	#name : 'ACPRequestTest',
	#superclass : 'TestCase',
	#category : 'ACP-Tests'
}

{ #category : 'tests' }
ACPRequestTest >> testInitializeFactory [

	| request |
	request := ACPRequest initialize: (ACPInitializeParams buildBy: [ :p |
			           p protocolVersion: 1.
			           p capabilities terminal: true ]).
	self assert: request method equals: 'initialize'.
	self assert: (request params at: 'protocolVersion') equals: 1.
	self assert: ((request params at: 'capabilities') at: 'terminal') equals: true
]

{ #category : 'tests' }
ACPRequestTest >> testInitializeFactoryWithRawDictionary [

	| request |
	request := ACPRequest initialize: { ('protocolVersion' -> 1) } asDictionary.
	self assert: request method equals: 'initialize'.
	self assert: (request params at: 'protocolVersion') equals: 1
]

{ #category : 'tests' }
ACPRequestTest >> testNewSessionFactory [

	| request |
	request := ACPRequest newSession: (ACPNewSessionParams buildBy: [ :p |
			           p cwd: '/tmp'.
			           p mcpServers: #() ]).
	self assert: request method equals: 'session/new'.
	self assert: (request params at: 'cwd') equals: '/tmp'.
	self assert: (request params at: 'mcpServers') equals: #()
]

{ #category : 'tests' }
ACPRequestTest >> testPromptFactory [

	| request |
	request := ACPRequest prompt: (ACPPromptParams buildBy: [ :p |
			           p sessionId: 'abc'.
			           p prompt: #() ]).
	self assert: request method equals: 'session/prompt'.
	self assert: (request params at: 'sessionId') equals: 'abc'
]

{ #category : 'tests' }
ACPRequestTest >> testCancelFactory [

	| request |
	request := ACPRequest cancel: (ACPCancelParams buildBy: [ :p |
			           p sessionId: 'abc-123' ]).
	self assert: request method equals: 'session/cancel'.
	self assert: (request params at: 'sessionId') equals: 'abc-123'
]

{ #category : 'tests' }
ACPRequestTest >> testAuthenticateFactory [

	| request |
	request := ACPRequest authenticate: (ACPAuthenticateParams buildBy: [ :p |
			           p methodId: 'oauth' ]).
	self assert: request method equals: 'authenticate'.
	self assert: (request params at: 'methodId') equals: 'oauth'
]

{ #category : 'tests' }
ACPRequestTest >> testLoadSessionFactory [

	| request |
	request := ACPRequest loadSession: (ACPLoadSessionParams buildBy: [ :p |
			           p sessionId: 'abc'.
			           p cwd: '/tmp' ]).
	self assert: request method equals: 'session/load'.
	self assert: (request params at: 'sessionId') equals: 'abc'
]

{ #category : 'tests' }
ACPRequestTest >> testSetSessionModeFactory [

	| request |
	request := ACPRequest setSessionMode: (ACPSetSessionModeParams buildBy: [ :p |
			           p sessionId: 'abc'.
			           p modeId: 'plan' ]).
	self assert: request method equals: 'session/set_mode'.
	self assert: (request params at: 'modeId') equals: 'plan'
]

{ #category : 'tests' }
ACPRequestTest >> testSetSessionModelFactory [

	| request |
	request := ACPRequest setSessionModel: (ACPSetSessionModelParams buildBy: [ :p |
			           p sessionId: 'abc'.
			           p modelId: 'claude-opus-4-6' ]).
	self assert: request method equals: 'session/set_model'.
	self assert: (request params at: 'modelId') equals: 'claude-opus-4-6'
]

{ #category : 'tests' }
ACPRequestTest >> testSetSessionConfigOptionFactory [

	| request |
	request := ACPRequest setSessionConfigOption: (ACPSetSessionConfigOptionParams buildBy: [ :p |
			           p sessionId: 'abc'.
			           p configId: 'temperature'.
			           p value: '0.7' ]).
	self assert: request method equals: 'session/set_config_option'.
	self assert: (request params at: 'configId') equals: 'temperature'.
	self assert: (request params at: 'value') equals: '0.7'
]

{ #category : 'tests' }
ACPRequestTest >> testFactoryWithRawDictionary [

	| request |
	request := ACPRequest newSession: { ('cwd' -> '/tmp') } asDictionary.
	self assert: request method equals: 'session/new'.
	self assert: (request params at: 'cwd') equals: '/tmp'
]
