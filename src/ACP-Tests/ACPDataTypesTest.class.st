Class {
	#name : 'ACPDataTypesTest',
	#superclass : 'TestCase',
	#category : 'ACP-Tests',
	#package : 'ACP-Tests'
}

{ #category : 'tests - leaf options' }
ACPDataTypesTest >> testAuthenticateParamsAsDictionary [

	| opts dict |
	opts := ACPAuthenticateParams new.
	opts methodId: 'oauth'.
	dict := opts asDictionary.
	self assert: (dict at: 'methodId') equals: 'oauth'
]

{ #category : 'tests - base' }
ACPDataTypesTest >> testBuildBy [

	| opts dict |
	opts := ACPNewSessionParams buildBy: [ :p |
		        p cwd: '/tmp'.
		        p mcpServers: #() ].
	dict := opts asDictionary.
	self assert: (dict at: 'cwd') equals: '/tmp'.
	self assert: (dict at: 'mcpServers') equals: #()
]

{ #category : 'tests - base' }
ACPDataTypesTest >> testBuildByEmptyBlock [

	| opts dict |
	opts := ACPNewSessionParams buildBy: [ :p | ].
	dict := opts asDictionary.
	self assert: dict size equals: 1.
	self assert: (dict at: 'mcpServers') equals: #()
]

{ #category : 'tests - leaf options' }
ACPDataTypesTest >> testCancelParamsAsDictionary [

	| opts dict |
	opts := ACPCancelParams new.
	opts sessionId: 'abc-123'.
	dict := opts asDictionary.
	self assert: (dict at: 'sessionId') equals: 'abc-123'
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

{ #category : 'tests - base' }
ACPDataTypesTest >> testExtraPropertiesOn [

	| opts dict props |
	opts := ACPNewSessionParams new.
	opts cwd: '/tmp'.
	props := { ('foo' -> 'bar') } asDictionary.
	opts extraProperties: props.
	dict := opts asDictionary.
	self assert: (dict at: 'cwd') equals: '/tmp'.
	self assert: ((dict at: '_meta') at: 'foo') equals: 'bar'
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

{ #category : 'tests - composite options' }
ACPDataTypesTest >> testInitializeParamsBuildByNested [

	| params dict |
	params := ACPInitializeParams buildBy: [ :p |
		          p capabilities terminal: true.
		          p clientInfo name: 'pharo-acp'; version: '0.1.0' ].
	dict := params asDictionary.
	self assert: ((dict at: 'capabilities') at: 'terminal') equals: true.
	self assert: ((dict at: 'clientInfo') at: 'name') equals: 'pharo-acp'
]

{ #category : 'tests - composite options' }
ACPDataTypesTest >> testInitializeParamsDefaultProtocolVersion [

	| params dict |
	params := ACPInitializeParams new.
	dict := params asDictionary.
	self assert: (dict at: 'protocolVersion') equals: 1
]

{ #category : 'tests - composite options' }
ACPDataTypesTest >> testInitializeParamsEmptyChildOmitted [

	| params dict |
	params := ACPInitializeParams new.
	params capabilities. "trigger lazy init but don't set anything"
	dict := params asDictionary.
	self deny: (dict includesKey: 'capabilities').
	self assert: (dict at: 'protocolVersion') equals: 1
]

{ #category : 'tests - composite options' }
ACPDataTypesTest >> testInitializeParamsExplicitProtocolVersion [

	| params dict |
	params := ACPInitializeParams new.
	params protocolVersion: 2.
	dict := params asDictionary.
	self assert: (dict at: 'protocolVersion') equals: 2
]

{ #category : 'tests - composite options' }
ACPDataTypesTest >> testInitializeParamsLazyInit [

	| params |
	params := ACPInitializeParams new.
	self assert: params capabilities class equals: ACPClientCapabilities.
	self assert: params clientInfo class equals: ACPImplementation
]

{ #category : 'tests - composite options' }
ACPDataTypesTest >> testInitializeParamsNonEmptyChildIncluded [

	| params dict |
	params := ACPInitializeParams new.
	params capabilities terminal: true.
	dict := params asDictionary.
	self assert: (dict includesKey: 'capabilities').
	self assert: ((dict at: 'capabilities') at: 'terminal') equals: true.
	self assert: (dict at: 'protocolVersion') equals: 1
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
ACPDataTypesTest >> testLoadSessionResponseFromDictionary [

	| resp |
	resp := ACPLoadSessionResponse fromDictionary: {
		        ('configOptions' -> #()).
		        ('modes' -> nil) } asDictionary.
	self assert: resp configOptions equals: #().
	self assert: resp models isNil
]

{ #category : 'tests - leaf options' }
ACPDataTypesTest >> testNewSessionParamsAsDictionary [

	| opts dict |
	opts := ACPNewSessionParams new.
	opts cwd: '/home/user/project'.
	opts mcpServers: #().
	dict := opts asDictionary.
	self assert: (dict at: 'cwd') equals: '/home/user/project'.
	self assert: (dict at: 'mcpServers') equals: #()
]

{ #category : 'tests - base' }
ACPDataTypesTest >> testNewSessionParamsIncludesMandatoryMcpServersByDefault [

	| opts dict |
	opts := ACPNewSessionParams new.
	dict := opts asDictionary.
	self assert: dict size equals: 1.
	self assert: (dict at: 'mcpServers') equals: #()
]

{ #category : 'tests - leaf options' }
ACPDataTypesTest >> testNewSessionParamsOmitsNilFields [

	| opts dict |
	opts := ACPNewSessionParams new.
	opts cwd: '/tmp'.
	dict := opts asDictionary.
	self assert: (dict includesKey: 'cwd').
	self assert: (dict includesKey: 'mcpServers')
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

{ #category : 'tests - leaf options' }
ACPDataTypesTest >> testPromptParamsAsDictionary [

	| opts dict prompt |
	prompt := { { 'type' -> 'text'. 'text' -> 'Hello' } asDictionary }.
	opts := ACPPromptParams new.
	opts sessionId: 'abc-123'.
	opts prompt: prompt.
	dict := opts asDictionary.
	self assert: (dict at: 'sessionId') equals: 'abc-123'.
	self assert: (dict at: 'prompt') equals: prompt
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
ACPDataTypesTest >> testResultPreservesUnknownKeys [

	| resp |
	resp := ACPInitializeResponse fromDictionary: {
		        ('protocolVersion' -> 1).
		        ('futureField' -> 42) } asDictionary.
	self assert: (resp rawValues at: 'futureField') equals: 42
]

{ #category : 'tests - leaf options' }
ACPDataTypesTest >> testSetSessionModeParamsAsDictionary [

	| opts dict |
	opts := ACPSetSessionModeParams new.
	opts sessionId: 'abc'.
	opts modeId: 'plan'.
	dict := opts asDictionary.
	self assert: (dict at: 'sessionId') equals: 'abc'.
	self assert: (dict at: 'modeId') equals: 'plan'
]

{ #category : 'tests - base' }
ACPDataTypesTest >> testValuesFromDictionary [

	| vals |
	vals := ACPValues fromDictionary: { ('key' -> 'value') } asDictionary.
	self assert: (vals rawValues at: 'key') equals: 'value'
]

{ #category : 'tests - base' }
ACPDataTypesTest >> testValuesSuperclassHierarchy [

	self assert: ACPNewSessionParams superclass equals: ACPValues.
	self assert: ACPPromptResponse superclass equals: ACPValues
]

{ #category : 'tests - capabilities' }
ACPDataTypesTest >> testMcpCapabilities [

	| caps |
	caps := ACPMcpCapabilities fromDictionary:
		        { ('http' -> true). ('sse' -> false) } asDictionary.
	self assert: caps http equals: true.
	self assert: caps sse equals: false
]

{ #category : 'tests - capabilities' }
ACPDataTypesTest >> testPromptCapabilities [

	| caps |
	caps := ACPPromptCapabilities fromDictionary:
		        { ('audio' -> true). ('image' -> false) } asDictionary.
	self assert: caps audio equals: true.
	self assert: caps image equals: false.
	self assert: caps embeddedContext isNil
]

{ #category : 'tests - capabilities' }
ACPDataTypesTest >> testSessionCapabilities [

	| caps forkDict |
	forkDict := { ('supported' -> true) } asDictionary.
	caps := ACPSessionCapabilities fromDictionary:
		        { ('fork' -> forkDict) } asDictionary.
	self assert: caps fork equals: forkDict.
	self assert: caps list isNil.
	self assert: caps resume isNil
]

{ #category : 'tests - capabilities' }
ACPDataTypesTest >> testAgentCapabilitiesTypedAccessors [

	| caps mcp prompt session |
	caps := ACPAgentCapabilities fromDictionary: {
		        ('mcpCapabilities' -> { ('http' -> true) } asDictionary).
		        ('promptCapabilities' -> { ('audio' -> true) } asDictionary).
		        ('sessionCapabilities' -> Dictionary new) } asDictionary.
	mcp := caps mcpCapabilities.
	prompt := caps promptCapabilities.
	session := caps sessionCapabilities.
	self assert: mcp class equals: ACPMcpCapabilities.
	self assert: mcp http equals: true.
	self assert: prompt class equals: ACPPromptCapabilities.
	self assert: prompt audio equals: true.
	self assert: session class equals: ACPSessionCapabilities
]

{ #category : 'tests - capabilities' }
ACPDataTypesTest >> testAgentCapabilitiesAbsentReturnsNil [

	| caps |
	caps := ACPAgentCapabilities fromDictionary: Dictionary new.
	self assert: caps mcpCapabilities isNil.
	self assert: caps promptCapabilities isNil.
	self assert: caps sessionCapabilities isNil
]

{ #category : 'tests - content block' }
ACPDataTypesTest >> testContentBlockText [

	| dict block |
	dict := { ('type' -> 'text'). ('text' -> 'Hello') } asDictionary.
	block := ACPContentBlock fromDictionary: dict.
	self assert: block type equals: 'text'.
	self assert: block text equals: 'Hello'.
	self assert: block asDictionary equals: dict
]

{ #category : 'tests - content block' }
ACPDataTypesTest >> testContentBlockImage [

	| block |
	block := ACPContentBlock fromDictionary:
		         { ('type' -> 'image'). ('data' -> 'base64abc'). ('mimeType' -> 'image/png') }
			         asDictionary.
	self assert: block type equals: 'image'.
	self assert: block data equals: 'base64abc'.
	self assert: block mimeType equals: 'image/png'
]

{ #category : 'tests - content block' }
ACPDataTypesTest >> testContentBlockAbsentFieldReturnsNil [

	| block |
	block := ACPContentBlock fromDictionary:
		         { ('type' -> 'text'). ('text' -> 'Hi') } asDictionary.
	self assert: block mimeType isNil.
	self assert: block data isNil.
	self assert: block uri isNil
]

{ #category : 'tests - content block' }
ACPDataTypesTest >> testContentChunk [

	| chunk content |
	chunk := ACPContentChunk fromDictionary:
		         { ('content' -> { ('type' -> 'text'). ('text' -> 'hello') } asDictionary) }
			         asDictionary.
	content := chunk content.
	self assert: content class equals: ACPContentBlock.
	self assert: content type equals: 'text'.
	self assert: content text equals: 'hello'
]
