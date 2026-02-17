Class {
	#name : 'ACPDataTypesTest',
	#superclass : 'TestCase',
	#category : 'ACP-Tests'
}

{ #category : 'tests - base' }
ACPDataTypesTest >> testOptionsEmptyAsDictionary [

	| opts |
	opts := ACPNewSessionRequest new.
	self assert: opts asDictionary isEmpty
]

{ #category : 'tests - base' }
ACPDataTypesTest >> testExtraPropertiesOn [

	| opts dict |
	opts := ACPNewSessionRequest new.
	opts cwd: '/tmp'.
	opts extraProperties at: '_meta' put: 'test'.
	dict := opts asDictionary.
	self assert: (dict at: 'cwd') equals: '/tmp'.
	self assert: (dict at: '_meta') equals: 'test'
]

{ #category : 'tests - leaf options' }
ACPDataTypesTest >> testNewSessionRequestAsDictionary [

	| opts dict |
	opts := ACPNewSessionRequest new.
	opts cwd: '/home/user/project'.
	opts mcpServers: #().
	dict := opts asDictionary.
	self assert: (dict at: 'cwd') equals: '/home/user/project'.
	self assert: (dict at: 'mcpServers') equals: #()
]

{ #category : 'tests - leaf options' }
ACPDataTypesTest >> testNewSessionRequestOmitsNilFields [

	| opts dict |
	opts := ACPNewSessionRequest new.
	opts cwd: '/tmp'.
	dict := opts asDictionary.
	self assert: (dict includesKey: 'cwd').
	self deny: (dict includesKey: 'mcpServers')
]

{ #category : 'tests - leaf options' }
ACPDataTypesTest >> testPromptRequestAsDictionary [

	| opts dict prompt |
	prompt := { { 'type' -> 'text'. 'text' -> 'Hello' } asDictionary }.
	opts := ACPPromptRequest new.
	opts sessionId: 'abc-123'.
	opts prompt: prompt.
	dict := opts asDictionary.
	self assert: (dict at: 'sessionId') equals: 'abc-123'.
	self assert: (dict at: 'prompt') equals: prompt
]

{ #category : 'tests - leaf options' }
ACPDataTypesTest >> testAuthenticateRequestAsDictionary [

	| opts dict |
	opts := ACPAuthenticateRequest new.
	opts methodId: 'oauth'.
	dict := opts asDictionary.
	self assert: (dict at: 'methodId') equals: 'oauth'
]

{ #category : 'tests - leaf options' }
ACPDataTypesTest >> testSetSessionModeRequestAsDictionary [

	| opts dict |
	opts := ACPSetSessionModeRequest new.
	opts sessionId: 'abc'.
	opts modeId: 'plan'.
	dict := opts asDictionary.
	self assert: (dict at: 'sessionId') equals: 'abc'.
	self assert: (dict at: 'modeId') equals: 'plan'
]

{ #category : 'tests - leaf options' }
ACPDataTypesTest >> testCancelNotificationAsDictionary [

	| opts dict |
	opts := ACPCancelNotification new.
	opts sessionId: 'abc-123'.
	dict := opts asDictionary.
	self assert: (dict at: 'sessionId') equals: 'abc-123'
]

{ #category : 'tests - leaf options' }
ACPDataTypesTest >> testFileSystemCapabilityAsDictionary [

	| opts dict |
	opts := ACPFileSystemCapability new.
	opts readTextFile: true.
	dict := opts asDictionary.
	self assert: (dict at: 'readTextFile') equals: true.
	self deny: (dict includesKey: 'writeTextFile')
]

{ #category : 'tests - composite options' }
ACPDataTypesTest >> testInitializeRequestLazyInit [

	| req |
	req := ACPInitializeRequest new.
	self assert: req clientCapabilities class equals: ACPClientCapabilities.
	self assert: req clientInfo class equals: ACPImplementation
]

{ #category : 'tests - composite options' }
ACPDataTypesTest >> testInitializeRequestEmptyChildOmitted [

	| req dict |
	req := ACPInitializeRequest new.
	req clientCapabilities. "trigger lazy init but don't set anything"
	dict := req asDictionary.
	self deny: (dict includesKey: 'clientCapabilities')
]

{ #category : 'tests - composite options' }
ACPDataTypesTest >> testInitializeRequestNonEmptyChildIncluded [

	| req dict |
	req := ACPInitializeRequest new.
	req clientCapabilities terminal: true.
	dict := req asDictionary.
	self assert: (dict includesKey: 'clientCapabilities').
	self assert: ((dict at: 'clientCapabilities') at: 'terminal') equals: true
]

{ #category : 'tests - composite options' }
ACPDataTypesTest >> testClientCapabilitiesNestedFs [

	| caps dict |
	caps := ACPClientCapabilities new.
	caps fs readTextFile: true.
	caps fs writeTextFile: true.
	caps terminal: true.
	dict := caps asDictionary.
	self assert: (dict at: 'terminal') equals: true.
	self assert: ((dict at: 'fs') at: 'readTextFile') equals: true.
	self assert: ((dict at: 'fs') at: 'writeTextFile') equals: true
]

{ #category : 'tests - implementation' }
ACPDataTypesTest >> testImplementationAsDictionary [

	| impl dict |
	impl := ACPImplementation new.
	impl name: 'pharo-acp'.
	impl version: '0.1.0'.
	dict := impl asDictionary.
	self assert: (dict at: 'name') equals: 'pharo-acp'.
	self assert: (dict at: 'version') equals: '0.1.0'.
	self deny: (dict includesKey: 'title')
]

{ #category : 'tests - implementation' }
ACPDataTypesTest >> testImplementationFromDictionary [

	| impl |
	impl := ACPImplementation fromDictionary: {
		        ('name' -> 'gemini').
		        ('version' -> '1.0').
		        ('title' -> 'Gemini CLI') } asDictionary.
	self assert: impl name equals: 'gemini'.
	self assert: impl version equals: '1.0'.
	self assert: impl title equals: 'Gemini CLI'
]

{ #category : 'tests - result' }
ACPDataTypesTest >> testPromptResponseFromDictionary [

	| resp |
	resp := ACPPromptResponse fromDictionary:
		        { ('stopReason' -> 'end_turn') } asDictionary.
	self assert: resp stopReason equals: 'end_turn'.
	self assert: resp usage isNil
]

{ #category : 'tests - result' }
ACPDataTypesTest >> testInitializeResponseFromDictionary [

	| resp |
	resp := ACPInitializeResponse fromDictionary: {
		        ('protocolVersion' -> 1).
		        ('agentInfo' -> { ('name' -> 'gemini') } asDictionary) }
		        asDictionary.
	self assert: resp protocolVersion equals: 1.
	self assert: (resp agentInfo at: 'name') equals: 'gemini'
]

{ #category : 'tests - result' }
ACPDataTypesTest >> testNewSessionResponseFromDictionary [

	| resp |
	resp := ACPNewSessionResponse fromDictionary:
		        { ('sessionId' -> 'sess-001') } asDictionary.
	self assert: resp sessionId equals: 'sess-001'.
	self assert: resp configOptions isNil.
	self assert: resp modes isNil
]

{ #category : 'tests - result' }
ACPDataTypesTest >> testResultPreservesUnknownKeys [

	| resp |
	resp := ACPInitializeResponse fromDictionary: {
		        ('protocolVersion' -> 1).
		        ('futureField' -> 42) } asDictionary.
	self assert: (resp rawDictionary at: 'futureField') equals: 42
]

{ #category : 'tests - result' }
ACPDataTypesTest >> testLoadSessionResponseFromDictionary [

	| resp |
	resp := ACPLoadSessionResponse fromDictionary: {
		        ('configOptions' -> #()).
		        ('modes' -> nil) } asDictionary.
	self assert: resp configOptions equals: #().
	self assert: resp models isNil
]
