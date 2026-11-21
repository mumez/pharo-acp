Class {
	#name : 'ACP2RequestTest',
	#superclass : 'TestCase',
	#category : 'ACP2-Tests',
	#package : 'ACP2-Tests'
}

{ #category : 'tests' }
ACP2RequestTest >> testCancelFactory [

	| request |
	request := ACP2Request cancel: (ACP2CancelParams buildBy: [ :p |
			           p sessionId: 'abc-123' ]).
	self assert: request method equals: 'session/cancel'.
	self assert: (request params at: 'sessionId') equals: 'abc-123'
]

{ #category : 'tests' }
ACP2RequestTest >> testFactoryWithRawDictionary [

	| request |
	request := ACP2Request newSession: { ('cwd' -> '/tmp') } asDictionary.
	self assert: request method equals: 'session/new'.
	self assert: (request params at: 'cwd') equals: '/tmp'
]

{ #category : 'tests' }
ACP2RequestTest >> testInitializeFactory [

	| request |
	request := ACP2Request initialize: (ACP2InitializeParams buildBy: [ :p |
			           p protocolVersion: 2.
			           p capabilities auth enableTerminal ]).
	self assert: request method equals: 'initialize'.
	self assert: (request params at: 'protocolVersion') equals: 2.
	self assert: (((request params at: 'capabilities') at: 'auth') at: 'terminal') equals: Dictionary new
]

{ #category : 'tests' }
ACP2RequestTest >> testInitializeFactoryWithRawDictionary [

	| request |
	request := ACP2Request initialize: { ('protocolVersion' -> 2) } asDictionary.
	self assert: request method equals: 'initialize'.
	self assert: (request params at: 'protocolVersion') equals: 2
]

{ #category : 'tests' }
ACP2RequestTest >> testListSessionsFactory [

	| request |
	request := ACP2Request listSessions: (ACP2ListSessionsParams buildBy: [ :p |
			           p cwd: '/home/user/project' ]).
	self assert: request method equals: 'session/list'.
	self assert: (request params at: 'cwd') equals: '/home/user/project'
]

{ #category : 'tests' }
ACP2RequestTest >> testListSessionsFactoryEmptyParams [

	| request |
	request := ACP2Request listSessions: Dictionary new.
	self assert: request method equals: 'session/list'
]

{ #category : 'tests' }
ACP2RequestTest >> testResumeSessionFactory [

	| request |
	request := ACP2Request resumeSession: (ACP2SessionResumeParams buildBy: [ :p |
			           p sessionId: 'abc'.
			           p cwd: '/tmp' ]).
	self assert: request method equals: 'session/resume'.
	self assert: (request params at: 'sessionId') equals: 'abc'
]

{ #category : 'tests' }
ACP2RequestTest >> testLogoutFactory [

	| request |
	request := ACP2Request logout: ACP2AuthLogoutParams new.
	self assert: request method equals: 'auth/logout'.
	self assert: request params isEmpty
]

{ #category : 'tests' }
ACP2RequestTest >> testNewSessionFactory [

	| request |
	request := ACP2Request newSession: (ACP2SessionParams buildBy: [ :p |
			           p cwd: '/tmp' ]).
	self assert: request method equals: 'session/new'.
	self assert: (request params at: 'cwd') equals: '/tmp'
]

{ #category : 'tests' }
ACP2RequestTest >> testPromptFactory [

	| request |
	request := ACP2Request prompt: (ACP2PromptParams buildBy: [ :p |
			           p sessionId: 'abc'.
			           p prompt: #() ]).
	self assert: request method equals: 'session/prompt'.
	self assert: (request params at: 'sessionId') equals: 'abc'
]

{ #category : 'tests' }
ACP2RequestTest >> testDeleteSessionFactory [

	| request |
	request := ACP2Request deleteSession:
		           (ACP2DeleteSessionParams buildBy: [ :p | p sessionId: 'abc' ]).
	self assert: request method equals: 'session/delete'.
	self assert: (request params at: 'sessionId') equals: 'abc'
]

{ #category : 'tests' }
ACP2RequestTest >> testCloseSessionFactory [

	| request |
	request := ACP2Request closeSession:
		           (ACP2CloseSessionParams buildBy: [ :p | p sessionId: 'abc' ]).
	self assert: request method equals: 'session/close'.
	self assert: (request params at: 'sessionId') equals: 'abc'
]

{ #category : 'tests' }
ACP2RequestTest >> testLoginFactory [

	| request |
	request := ACP2Request login: (ACP2AuthLoginParams buildBy: [ :p |
			           p methodId: 'oauth' ]).
	self assert: request method equals: 'auth/login'.
	self assert: (request params at: 'methodId') equals: 'oauth'
]

{ #category : 'tests' }
ACP2RequestTest >> testSetConfigOptionFactory [

	| request |
	request := ACP2Request setConfigOption: (ACP2SetSessionConfigOptionParams buildBy: [ :p |
			           p sessionId: 'abc'.
			           p configId: 'model'.
			           p idValue: 'fast' ]).
	self assert: request method equals: 'session/set_config_option'.
	self assert: (request params at: 'sessionId') equals: 'abc'.
	self assert: (request params at: 'configId') equals: 'model'.
	self assert: (request params at: 'type') equals: 'id'.
	self assert: (request params at: 'value') equals: 'fast'
]

{ #category : 'tests' }
ACP2RequestTest >> testCancelToolCallFactory [

	| request |
	request := ACP2Request cancelToolCall: (ACP2CancelToolCallParams buildBy: [ :p |
			           p sessionId: 'abc'.
			           p toolCallId: 'call_001' ]).
	self assert: request method equals: 'tool_call/cancel'.
	self assert: (request params at: 'sessionId') equals: 'abc'.
	self assert: (request params at: 'toolCallId') equals: 'call_001'
]

{ #category : 'tests' }
ACP2RequestTest >> testCancelTerminalFactory [

	| request |
	request := ACP2Request cancelTerminal: (ACP2CancelTerminalParams buildBy: [ :p |
			           p sessionId: 'abc'.
			           p terminalId: 'dev' ]).
	self assert: request method equals: 'terminal/cancel'.
	self assert: (request params at: 'sessionId') equals: 'abc'.
	self assert: (request params at: 'terminalId') equals: 'dev'
]
