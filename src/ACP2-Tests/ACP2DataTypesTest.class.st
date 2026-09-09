Class {
	#name : 'ACP2DataTypesTest',
	#superclass : 'TestCase',
	#category : 'ACP2-Tests',
	#package : 'ACP2-Tests'
}

{ #category : 'tests - leaf options' }
ACP2DataTypesTest >> testAuthenticateParamsAsDictionary [

	| opts dict |
	opts := ACP2AuthenticateParams new.
	opts methodId: 'oauth'.
	dict := opts asDictionary.
	self assert: (dict at: 'methodId') equals: 'oauth'
]

{ #category : 'tests - base' }
ACP2DataTypesTest >> testBuildBy [

	| opts dict |
	opts := ACP2SessionParams buildBy: [ :p | p cwd: '/tmp' ].
	dict := opts asDictionary.
	self assert: (dict at: 'cwd') equals: '/tmp'
]

{ #category : 'tests - base' }
ACP2DataTypesTest >> testBuildByEmptyBlock [

	| opts dict |
	opts := ACP2SessionParams buildBy: [ :p | ].
	dict := opts asDictionary.
	self assert: dict isEmpty
]

{ #category : 'tests - leaf options' }
ACP2DataTypesTest >> testCancelParamsAsDictionary [

	| opts dict |
	opts := ACP2CancelParams new.
	opts sessionId: 'abc-123'.
	dict := opts asDictionary.
	self assert: (dict at: 'sessionId') equals: 'abc-123'
]

{ #category : 'tests - composite options' }
ACP2DataTypesTest >> testClientCapabilitiesNestedFs [

	| caps dict |
	caps := ACP2ClientCapabilities new.
	caps fs readTextFile: true.
	caps fs writeTextFile: true.
	caps terminal: true.
	dict := caps asDictionary.
	self assert: (dict at: 'terminal') equals: true.
	self assert: ((dict at: 'fs') at: 'readTextFile') equals: true.
	self assert: ((dict at: 'fs') at: 'writeTextFile') equals: true
]

{ #category : 'tests - base' }
ACP2DataTypesTest >> testExtraPropertiesOn [

	| opts dict props |
	opts := ACP2SessionParams new.
	opts cwd: '/tmp'.
	props := { ('foo' -> 'bar') } asDictionary.
	opts extraProperties: props.
	dict := opts asDictionary.
	self assert: (dict at: 'cwd') equals: '/tmp'.
	self assert: ((dict at: '_meta') at: 'foo') equals: 'bar'
]

{ #category : 'tests - leaf options' }
ACP2DataTypesTest >> testFileSystemCapabilityAsDictionary [

	| opts dict |
	opts := ACP2FileSystemCapability new.
	opts readTextFile: true.
	dict := opts asDictionary.
	self assert: (dict at: 'readTextFile') equals: true.
	self deny: (dict includesKey: 'writeTextFile')
]

{ #category : 'tests - implementation' }
ACP2DataTypesTest >> testImplementationAsDictionary [

	| impl dict |
	impl := ACP2Implementation new.
	impl name: 'pharo-acp'.
	impl version: '0.1.0'.
	dict := impl asDictionary.
	self assert: (dict at: 'name') equals: 'pharo-acp'.
	self assert: (dict at: 'version') equals: '0.1.0'.
	self deny: (dict includesKey: 'title')
]

{ #category : 'tests - implementation' }
ACP2DataTypesTest >> testImplementationFromDictionary [

	| impl |
	impl := ACP2Implementation fromDictionary: {
		        ('name' -> 'gemini').
		        ('version' -> '1.0').
		        ('title' -> 'Gemini CLI') } asDictionary.
	self assert: impl name equals: 'gemini'.
	self assert: impl version equals: '1.0'.
	self assert: impl title equals: 'Gemini CLI'
]

{ #category : 'tests - composite options' }
ACP2DataTypesTest >> testInitializeParamsBuildByNested [

	| params dict |
	params := ACP2InitializeParams buildBy: [ :p |
		          p capabilities terminal: true.
		          p info name: 'pharo-acp'; version: '0.1.0' ].
	dict := params asDictionary.
	self assert: ((dict at: 'capabilities') at: 'terminal') equals: true.
	self assert: ((dict at: 'info') at: 'name') equals: 'pharo-acp'
]

{ #category : 'tests - composite options' }
ACP2DataTypesTest >> testInitializeParamsDefaultProtocolVersion [

	| params dict |
	params := ACP2InitializeParams new.
	dict := params asDictionary.
	self assert: (dict at: 'protocolVersion') equals: 2
]

{ #category : 'tests - composite options' }
ACP2DataTypesTest >> testInitializeParamsEmptyChildOmitted [

	| params dict |
	params := ACP2InitializeParams new.
	params capabilities. "trigger lazy init but don't set anything"
	dict := params asDictionary.
	self deny: (dict includesKey: 'capabilities').
	self assert: (dict at: 'protocolVersion') equals: 2
]

{ #category : 'tests - composite options' }
ACP2DataTypesTest >> testInitializeParamsExplicitProtocolVersion [

	| params dict |
	params := ACP2InitializeParams new.
	params protocolVersion: 2.
	dict := params asDictionary.
	self assert: (dict at: 'protocolVersion') equals: 2
]

{ #category : 'tests - composite options' }
ACP2DataTypesTest >> testInitializeParamsLazyInit [

	| params |
	params := ACP2InitializeParams new.
	self assert: params capabilities class equals: ACP2ClientCapabilities.
	self assert: params info class equals: ACP2Implementation
]

{ #category : 'tests - composite options' }
ACP2DataTypesTest >> testInitializeParamsNonEmptyChildIncluded [

	| params dict |
	params := ACP2InitializeParams new.
	params capabilities terminal: true.
	dict := params asDictionary.
	self assert: (dict includesKey: 'capabilities').
	self assert: ((dict at: 'capabilities') at: 'terminal') equals: true.
	self assert: (dict at: 'protocolVersion') equals: 2
]

{ #category : 'tests - result' }
ACP2DataTypesTest >> testInitializeResponseFromDictionary [

	| resp |
	resp := ACP2InitializeResponse fromDictionary: {
		        ('protocolVersion' -> 1).
		        ('info' -> { ('name' -> 'gemini') } asDictionary) }
		        asDictionary.
	self assert: resp protocolVersion equals: 1.
	self assert: (resp info at: 'name') equals: 'gemini'
]

{ #category : 'tests - result' }
ACP2DataTypesTest >> testInitializeResponseParsesAgentCapabilities [

	| resp |
	resp := ACP2InitializeResponse fromDictionary: {
		        ('protocolVersion' -> 1).
		        ('capabilities' -> { ('loadSession' -> true) } asDictionary) }
		        asDictionary.
	self assert: resp protocolVersion equals: 1.
	self assert: resp capabilities class equals: ACP2AgentCapabilities.
	self assert: resp capabilities loadSession equals: true
]

{ #category : 'tests - result' }
ACP2DataTypesTest >> testListSessionsResponseFromDictionary [

	| resp sessions |
	resp := ACP2ListSessionsResponse fromDictionary: {
		        ('sessions' -> {
			         { ('sessionId' -> 'abc'). ('cwd' -> '/home/user') } asDictionary.
			         { ('sessionId' -> 'def'). ('cwd' -> '/tmp'). ('title' -> 'My Session') } asDictionary }
			         asOrderedCollection).
		        ('nextCursor' -> 'tok123') } asDictionary.
	sessions := resp sessions.
	self assert: sessions size equals: 2.
	self assert: sessions first class equals: ACP2SessionInfo.
	self assert: sessions first sessionId equals: 'abc'.
	self assert: sessions last title equals: 'My Session'.
	self assert: resp nextCursor equals: 'tok123'.
	self assert: resp hasNextPage
]

{ #category : 'tests - result' }
ACP2DataTypesTest >> testListSessionsResponseNoNextCursor [

	| resp |
	resp := ACP2ListSessionsResponse fromDictionary: {
		        ('sessions' -> OrderedCollection new) } asDictionary.
	self assert: resp sessions isEmpty.
	self assert: resp nextCursor isNil.
	self deny: resp hasNextPage
]

{ #category : 'tests - result' }
ACP2DataTypesTest >> testSessionInfoFields [

	| info |
	info := ACP2SessionInfo fromDictionary: {
		        ('sessionId' -> 'abc-123').
		        ('cwd' -> '/home/user/project').
		        ('title' -> 'My Session').
		        ('updatedAt' -> '2026-04-22T10:00:00Z') } asDictionary.
	self assert: info sessionId equals: 'abc-123'.
	self assert: info cwd equals: '/home/user/project'.
	self assert: info title equals: 'My Session'.
	self assert: info updatedAt equals: '2026-04-22T10:00:00Z'
]

{ #category : 'tests - result' }
ACP2DataTypesTest >> testListSessionsParamsAsDictionary [

	| params dict |
	params := ACP2ListSessionsParams new.
	params cwd: '/home/user'.
	params cursor: 'tok456'.
	dict := params asDictionary.
	self assert: (dict at: 'cwd') equals: '/home/user'.
	self assert: (dict at: 'cursor') equals: 'tok456'
]

{ #category : 'tests - result' }
ACP2DataTypesTest >> testLoadSessionResponseFromDictionary [

	| resp |
	resp := ACP2SessionSetupResponse fromDictionary: {
		        ('configOptions' -> {
			         {
				         ('id' -> 'mode').
				         ('name' -> 'Mode').
				         ('type' -> 'select').
				         ('currentValue' -> 'ask').
				         ('options' -> #()) } asDictionary } asOrderedCollection).
		        ('modes' -> {
			         { ('id' -> 'ask'). ('name' -> 'Ask') } asDictionary } asOrderedCollection).
		        ('models' -> {
			         { ('modelId' -> 'model-1'). ('name' -> 'Model 1') } asDictionary } asOrderedCollection) } asDictionary.
	self assert: resp configOptions size equals: 1.
	self assert: resp configOptions first class equals: ACP2ConfigOption.
	self assert: resp configOptions first id equals: 'mode'.
	self assert: resp modes size equals: 1.
	self assert: resp modes first class equals: ACP2SessionMode.
	self assert: resp modes first id equals: 'ask'.
	self assert: resp availableModes size equals: 1.
	self assert: resp availableModes first id equals: 'ask'.
	self assert: resp models size equals: 1.
	self assert: resp models first class equals: ACP2SessionModel.
	self assert: resp models first modelId equals: 'model-1'.
	self assert: resp availableModels size equals: 1.
	self assert: resp availableModels first modelId equals: 'model-1'
]

{ #category : 'tests - result' }
ACP2DataTypesTest >> testLoadSessionResponseParsesModesFromModeState [

	| resp |
	resp := ACP2SessionSetupResponse fromDictionary: {
		        ('modes' -> {
			         ('currentModeId' -> 'code').
			         ('availableModes' -> {
				          { ('id' -> 'ask'). ('name' -> 'Ask') } asDictionary.
				          { ('id' -> 'code'). ('name' -> 'Code') } asDictionary }
					         asOrderedCollection) } asDictionary) } asDictionary.
	self assert: resp modes size equals: 2.
	self assert: resp availableModes size equals: 2.
	self assert: resp modes second class equals: ACP2SessionMode.
	self assert: resp modes second id equals: 'code'
]

{ #category : 'tests - result' }
ACP2DataTypesTest >> testLoadSessionResponseParsesModelsFromModelState [

	| resp |
	resp := ACP2SessionSetupResponse fromDictionary: {
		        ('models' -> {
			         ('currentModelId' -> 'model-2').
			         ('availableModels' -> {
				          { ('modelId' -> 'model-1'). ('name' -> 'Model 1') } asDictionary.
				          { ('modelId' -> 'model-2'). ('name' -> 'Model 2') } asDictionary }
					         asOrderedCollection) } asDictionary) } asDictionary.
	self assert: resp models size equals: 2.
	self assert: resp availableModels size equals: 2.
	self assert: resp models second class equals: ACP2SessionModel.
	self assert: resp models second modelId equals: 'model-2'
]

{ #category : 'tests - leaf options' }
ACP2DataTypesTest >> testNewSessionParamsAsDictionary [

	| opts dict |
	opts := ACP2SessionParams new.
	opts cwd: '/home/user/project'.
	dict := opts asDictionary.
	self assert: dict equals: { ('cwd' -> '/home/user/project') } asDictionary
]

{ #category : 'tests - leaf options' }
ACP2DataTypesTest >> testNewSessionParamsOmitsNilFields [

	| opts dict |
	opts := ACP2SessionParams new.
	dict := opts asDictionary.
	self deny: (dict includesKey: 'cwd')
]

{ #category : 'tests - leaf options' }
ACP2DataTypesTest >> testSessionResumeParamsAsDictionary [

	| opts dict |
	opts := ACP2SessionResumeParams new.
	opts sessionId: 'abc'.
	opts cwd: '/tmp'.
	opts replayFrom: { ('type' -> 'start') } asDictionary.
	dict := opts asDictionary.
	self assert: (dict at: 'sessionId') equals: 'abc'.
	self assert: (dict at: 'cwd') equals: '/tmp'.
	self assert: ((dict at: 'replayFrom') at: 'type') equals: 'start'
]

{ #category : 'tests - leaf options' }
ACP2DataTypesTest >> testSessionCloseParamsAsDictionary [

	| opts dict |
	opts := ACP2SessionCloseParams new.
	opts sessionId: 'abc'.
	dict := opts asDictionary.
	self assert: dict equals: { ('sessionId' -> 'abc') } asDictionary
]

{ #category : 'tests - leaf options' }
ACP2DataTypesTest >> testAuthLogoutParamsAsDictionary [

	| opts dict |
	opts := ACP2AuthLogoutParams new.
	dict := opts asDictionary.
	self assert: dict isEmpty
]

{ #category : 'tests - result' }
ACP2DataTypesTest >> testNewSessionResponseFromDictionary [

	| resp |
	resp := ACP2SessionSetupResponse fromDictionary:
		        { ('sessionId' -> 'sess-001') } asDictionary.
	self assert: resp sessionId equals: 'sess-001'.
	self assert: resp configOptions isEmpty.
	self assert: resp modes isEmpty.
	self assert: resp models isEmpty
]

{ #category : 'tests - result' }
ACP2DataTypesTest >> testBaseSessionResponsePluralFieldsFallbackToEmptyCollection [

	| resp |
	resp := ACP2SessionSetupResponse fromDictionary: {
		        ('sessionId' -> 'sess-001').
		        ('configOptions' -> nil).
		        ('modes' -> nil).
		        ('models' -> nil) } asDictionary.
	self assert: resp configOptions isEmpty.
	self assert: resp modes isEmpty.
	self assert: resp models isEmpty
]

{ #category : 'tests - leaf options' }
ACP2DataTypesTest >> testPromptParamsAsDictionary [

	| opts dict prompt |
	prompt := { { 'type' -> 'text'. 'text' -> 'Hello' } asDictionary }.
	opts := ACP2PromptParams new.
	opts sessionId: 'abc-123'.
	opts prompt: prompt.
	dict := opts asDictionary.
	self assert: (dict at: 'sessionId') equals: 'abc-123'.
	self assert: (dict at: 'prompt') equals: prompt
]

{ #category : 'tests - prompt builder' }
ACP2DataTypesTest >> testPromptParamsTextPromptBuilder [

	| opts block |
	opts := ACP2PromptParams new.
	opts textPrompt: 'Hello'.
	block := (opts prompt) first.
	self assert: (block at: 'type') equals: 'text'.
	self assert: (block at: 'text') equals: 'Hello'
]

{ #category : 'tests - prompt builder' }
ACP2DataTypesTest >> testPromptParamsImagePromptBuilder [

	| opts block |
	opts := ACP2PromptParams new.
	opts imagePrompt: 'base64data' mimeType: 'image/png'.
	block := (opts prompt) first.
	self assert: (block at: 'type') equals: 'image'.
	self assert: (block at: 'data') equals: 'base64data'.
	self assert: (block at: 'mimeType') equals: 'image/png'
]

{ #category : 'tests - prompt builder' }
ACP2DataTypesTest >> testPromptParamsAudioPromptBuilder [

	| opts block |
	opts := ACP2PromptParams new.
	opts audioPrompt: 'base64audio' mimeType: 'audio/mp3'.
	block := (opts prompt) first.
	self assert: (block at: 'type') equals: 'audio'.
	self assert: (block at: 'data') equals: 'base64audio'.
	self assert: (block at: 'mimeType') equals: 'audio/mp3'
]

{ #category : 'tests - prompt builder' }
ACP2DataTypesTest >> testPromptParamsResourceTextPromptBuilder [

	| opts block resourceDict |
	opts := ACP2PromptParams new.
	opts resourcePrompt: 'file:///tmp/foo.txt' text: 'hello' mimeType: 'text/plain'.
	block := opts prompt first.
	self assert: (block at: 'type') equals: 'resource'.
	resourceDict := block at: 'resource'.
	self assert: (resourceDict at: 'uri') equals: 'file:///tmp/foo.txt'.
	self assert: (resourceDict at: 'text') equals: 'hello'.
	self assert: (resourceDict at: 'mimeType') equals: 'text/plain'
]

{ #category : 'tests - prompt builder' }
ACP2DataTypesTest >> testPromptParamsResourceTextPromptBuilderNoMimeType [

	| opts block resourceDict |
	opts := ACP2PromptParams new.
	opts resourcePrompt: 'file:///tmp/foo.txt' text: 'hello'.
	block := opts prompt first.
	self assert: (block at: 'type') equals: 'resource'.
	resourceDict := block at: 'resource'.
	self assert: (resourceDict at: 'uri') equals: 'file:///tmp/foo.txt'.
	self assert: (resourceDict at: 'text') equals: 'hello'.
	self deny: (resourceDict includesKey: 'mimeType')
]

{ #category : 'tests - prompt builder' }
ACP2DataTypesTest >> testPromptParamsResourceBlobPromptBuilder [

	| opts block resourceDict |
	opts := ACP2PromptParams new.
	opts resourcePrompt: 'file:///tmp/img.png' blob: 'base64data' mimeType: 'image/png'.
	block := opts prompt first.
	self assert: (block at: 'type') equals: 'resource'.
	resourceDict := block at: 'resource'.
	self assert: (resourceDict at: 'uri') equals: 'file:///tmp/img.png'.
	self assert: (resourceDict at: 'blob') equals: 'base64data'.
	self assert: (resourceDict at: 'mimeType') equals: 'image/png'
]

{ #category : 'tests - prompt builder' }
ACP2DataTypesTest >> testPromptParamsResourceBlobPromptBuilderNoMimeType [

	| opts block resourceDict |
	opts := ACP2PromptParams new.
	opts resourcePrompt: 'file:///tmp/img.png' blob: 'base64data'.
	block := opts prompt first.
	self assert: (block at: 'type') equals: 'resource'.
	resourceDict := block at: 'resource'.
	self assert: (resourceDict at: 'uri') equals: 'file:///tmp/img.png'.
	self assert: (resourceDict at: 'blob') equals: 'base64data'.
	self deny: (resourceDict includesKey: 'mimeType')
]

{ #category : 'tests - prompt builder' }
ACP2DataTypesTest >> testPromptParamsResourceLinkPromptBuilder [

	| opts block |
	opts := ACP2PromptParams new.
	opts resourceLinkPrompt: 'file:///tmp/foo.txt' name: 'foo'.
	block := (opts prompt) first.
	self assert: (block at: 'type') equals: 'resource_link'.
	self assert: (block at: 'uri') equals: 'file:///tmp/foo.txt'.
	self assert: (block at: 'name') equals: 'foo'
]

{ #category : 'tests - prompt builder' }
ACP2DataTypesTest >> testPromptParamsMultipleBlocksBuilder [

	| opts |
	opts := ACP2PromptParams new.
	opts textPrompt: 'Look at this image:'.
	opts imagePrompt: 'base64data' mimeType: 'image/png'.
	self assert: opts prompt size equals: 2.
	self assert: ((opts prompt first) at: 'type') equals: 'text'.
	self assert: ((opts prompt last) at: 'type') equals: 'image'
]

{ #category : 'tests - prompt builder' }
ACP2DataTypesTest >> testPromptParamsSettingBlock [

	| opts block |
	opts := ACP2PromptParams new.
	opts resourceLinkPrompt: 'file:///tmp/foo.txt' name: 'foo' setting: [ :cb |
		cb title: 'Foo File'.
		cb size: 512 ].
	block := (opts prompt) first.
	self assert: (block at: 'title') equals: 'Foo File'.
	self assert: (block at: 'size') equals: 512
]

{ #category : 'tests - result' }
ACP2DataTypesTest >> testPromptResponseFromDictionary [

	| resp |
	resp := ACP2PromptResponse fromDictionary:
		        { ('stopReason' -> 'end_turn') } asDictionary.
	self assert: resp stopReason equals: 'end_turn'.
	self assert: resp usage isNil
]

{ #category : 'tests - result' }
ACP2DataTypesTest >> testResultPreservesUnknownKeys [

	| resp |
	resp := ACP2InitializeResponse fromDictionary: {
		        ('protocolVersion' -> 1).
		        ('futureField' -> 42) } asDictionary.
	self assert: (resp rawValues at: 'futureField') equals: 42
]

{ #category : 'tests - result' }
ACP2DataTypesTest >> testInitializeResponseOmitsAgentCapabilitiesWhenAbsent [

	| resp dict |
	resp := ACP2InitializeResponse new.
	dict := resp asDictionary.
	self deny: (dict includesKey: 'capabilities')
]

{ #category : 'tests - leaf options' }
ACP2DataTypesTest >> testSetSessionModeParamsAsDictionary [

	| opts dict |
	opts := ACP2SetSessionModeParams new.
	opts sessionId: 'abc'.
	opts modeId: 'plan'.
	dict := opts asDictionary.
	self assert: (dict at: 'sessionId') equals: 'abc'.
	self assert: (dict at: 'modeId') equals: 'plan'
]

{ #category : 'tests - base' }
ACP2DataTypesTest >> testValuesFromDictionary [

	| vals |
	vals := ACP2Values fromDictionary: { ('key' -> 'value') } asDictionary.
	self assert: (vals rawValues at: 'key') equals: 'value'
]

{ #category : 'tests - base' }
ACP2DataTypesTest >> testValuesSuperclassHierarchy [

	self assert: ACP2SessionParams superclass equals: ACP2Values.
	self assert: ACP2PromptResponse superclass equals: ACP2Values
]

{ #category : 'tests - capabilities' }
ACP2DataTypesTest >> testMcpCapabilities [

	| caps |
	caps := ACP2McpCapabilities fromDictionary:
		        { ('http' -> true). ('sse' -> false) } asDictionary.
	self assert: caps http equals: true.
	self assert: caps sse equals: false
]

{ #category : 'tests - capabilities' }
ACP2DataTypesTest >> testPromptCapabilities [

	| caps |
	caps := ACP2PromptCapabilities fromDictionary:
		        { ('audio' -> true). ('image' -> false) } asDictionary.
	self assert: caps audio equals: true.
	self assert: caps image equals: false.
	self assert: caps embeddedContext isNil
]

{ #category : 'tests - capabilities' }
ACP2DataTypesTest >> testSessionCapabilities [

	| caps forkDict |
	forkDict := { ('supported' -> true) } asDictionary.
	caps := ACP2SessionCapabilities fromDictionary:
		        { ('fork' -> forkDict) } asDictionary.
	self assert: caps fork equals: forkDict.
	self assert: caps list isNil.
	self assert: caps resume isNil
]

{ #category : 'tests - capabilities' }
ACP2DataTypesTest >> testAgentCapabilitiesTypedAccessors [

	| caps mcp prompt session |
	caps := ACP2AgentCapabilities fromDictionary: {
		        ('mcpCapabilities' -> { ('http' -> true) } asDictionary).
		        ('promptCapabilities' -> { ('audio' -> true) } asDictionary).
		        ('sessionCapabilities' -> Dictionary new) } asDictionary.
	mcp := caps mcpCapabilities.
	prompt := caps promptCapabilities.
	session := caps sessionCapabilities.
	self assert: mcp class equals: ACP2McpCapabilities.
	self assert: mcp http equals: true.
	self assert: prompt class equals: ACP2PromptCapabilities.
	self assert: prompt audio equals: true.
	self assert: session class equals: ACP2SessionCapabilities
]

{ #category : 'tests - capabilities' }
ACP2DataTypesTest >> testAgentCapabilitiesAbsentReturnsEmpty [

	| caps dict |
	caps := ACP2AgentCapabilities fromDictionary: Dictionary new.
	self assert: caps mcpCapabilities isEmpty.
	self assert: caps promptCapabilities isEmpty.
	self assert: caps sessionCapabilities isEmpty.
	dict := caps asDictionary.
	self deny: (dict includesKey: 'mcpCapabilities').
	self deny: (dict includesKey: 'promptCapabilities').
	self deny: (dict includesKey: 'sessionCapabilities')
]

{ #category : 'tests - capabilities' }
ACP2DataTypesTest >> testAgentCapabilitiesHasNoDefaultLoadSession [

	| caps dict |
	caps := ACP2AgentCapabilities new.
	self assert: caps loadSession isNil.
	dict := caps asDictionary.
	self deny: (dict includesKey: 'loadSession')
]

{ #category : 'tests - capabilities' }
ACP2DataTypesTest >> testAgentCapabilitiesIsLoadSupported [

	| supported unsupported |
	supported := ACP2AgentCapabilities fromDictionary: { ('loadSession' -> true) } asDictionary.
	unsupported := ACP2AgentCapabilities new.
	self assert: supported isLoadSupported.
	self deny: unsupported isLoadSupported
]

{ #category : 'tests - capabilities' }
ACP2DataTypesTest >> testAgentCapabilitiesIsResumeSupported [

	| supported unsupported |
	supported := ACP2AgentCapabilities fromDictionary: {
			        ('sessionCapabilities' -> { ('resume' -> Dictionary new) } asDictionary) }
		             asDictionary.
	unsupported := ACP2AgentCapabilities new.
	self assert: supported isResumeSupported.
	self deny: unsupported isResumeSupported
]

{ #category : 'tests - capabilities' }
ACP2DataTypesTest >> testAgentCapabilitiesIsListSupported [

	| supported unsupported |
	supported := ACP2AgentCapabilities fromDictionary: {
			        ('sessionCapabilities' -> { ('list' -> Dictionary new) } asDictionary) }
		             asDictionary.
	unsupported := ACP2AgentCapabilities new.
	self assert: supported isListSupported.
	self deny: unsupported isListSupported
]

{ #category : 'tests - capabilities' }
ACP2DataTypesTest >> testAgentCapabilitiesIsCloseSupported [

	| supported unsupported |
	supported := ACP2AgentCapabilities fromDictionary: {
			        ('sessionCapabilities' -> { ('close' -> Dictionary new) } asDictionary) }
		             asDictionary.
	unsupported := ACP2AgentCapabilities new.
	self assert: supported isCloseSupported.
	self deny: unsupported isCloseSupported
]

{ #category : 'tests - agent capabilities' }
ACP2DataTypesTest >> testAgentCapabilitiesIsHttpMcpServersSupported [

	| httpSupported sseOnly noCaps |
	httpSupported := ACP2AgentCapabilities fromDictionary: {
			         ('mcpCapabilities' -> { ('http' -> true). ('sse' -> false) } asDictionary) }
		                 asDictionary.
	sseOnly := ACP2AgentCapabilities fromDictionary: {
			   ('mcpCapabilities' -> { ('http' -> false). ('sse' -> true) } asDictionary) }
		           asDictionary.
	noCaps := ACP2AgentCapabilities new.
	self assert: httpSupported isHttpMcpServersSupported.
	self deny: sseOnly isHttpMcpServersSupported.
	self deny: noCaps isHttpMcpServersSupported
]

{ #category : 'tests - agent capabilities' }
ACP2DataTypesTest >> testAgentCapabilitiesIsSseMcpServersSupported [

	| sseSupported httpOnly noCaps |
	sseSupported := ACP2AgentCapabilities fromDictionary: {
			        ('mcpCapabilities' -> { ('http' -> false). ('sse' -> true) } asDictionary) }
		                asDictionary.
	httpOnly := ACP2AgentCapabilities fromDictionary: {
			    ('mcpCapabilities' -> { ('http' -> true). ('sse' -> false) } asDictionary) }
		            asDictionary.
	noCaps := ACP2AgentCapabilities new.
	self assert: sseSupported isSseMcpServersSupported.
	self deny: httpOnly isSseMcpServersSupported.
	self deny: noCaps isSseMcpServersSupported
]

{ #category : 'tests - content block' }
ACP2DataTypesTest >> testContentBlockText [

	| dict block |
	dict := { ('type' -> 'text'). ('text' -> 'Hello') } asDictionary.
	block := ACP2ContentBlock fromDictionary: dict.
	self assert: block type equals: 'text'.
	self assert: block text equals: 'Hello'.
	self assert: block asDictionary equals: dict
]

{ #category : 'tests - content block' }
ACP2DataTypesTest >> testContentBlockImage [

	| block |
	block := ACP2ContentBlock fromDictionary:
		         { ('type' -> 'image'). ('data' -> 'base64abc'). ('mimeType' -> 'image/png') }
			         asDictionary.
	self assert: block type equals: 'image'.
	self assert: block data equals: 'base64abc'.
	self assert: block mimeType equals: 'image/png'
]

{ #category : 'tests - content block' }
ACP2DataTypesTest >> testContentBlockAbsentFieldReturnsNil [

	| block |
	block := ACP2ContentBlock fromDictionary:
		         { ('type' -> 'text'). ('text' -> 'Hi') } asDictionary.
	self assert: block mimeType isNil.
	self assert: block data isNil.
	self assert: block uri isNil
]

{ #category : 'tests - content block' }
ACP2DataTypesTest >> testContentBlockAudio [

	| block dict |
	block := ACP2ContentBlock audio: 'base64audio' mimeType: 'audio/mp3'.
	dict := block asDictionary.
	self assert: (dict at: 'type') equals: 'audio'.
	self assert: (dict at: 'data') equals: 'base64audio'.
	self assert: (dict at: 'mimeType') equals: 'audio/mp3'
]

{ #category : 'tests - content block' }
ACP2DataTypesTest >> testContentBlockImage [

	| block dict |
	block := ACP2ContentBlock image: 'base64abc' mimeType: 'image/png'.
	dict := block asDictionary.
	self assert: (dict at: 'type') equals: 'image'.
	self assert: (dict at: 'data') equals: 'base64abc'.
	self assert: (dict at: 'mimeType') equals: 'image/png'
]

{ #category : 'tests - content block' }
ACP2DataTypesTest >> testContentBlockResourceTextWithMimeType [

	| block dict resourceDict |
	block := ACP2ContentBlock resource: 'file:///tmp/foo.txt' text: 'hello' mimeType: 'text/plain'.
	dict := block asDictionary.
	self assert: (dict at: 'type') equals: 'resource'.
	resourceDict := dict at: 'resource'.
	self assert: (resourceDict at: 'uri') equals: 'file:///tmp/foo.txt'.
	self assert: (resourceDict at: 'text') equals: 'hello'.
	self assert: (resourceDict at: 'mimeType') equals: 'text/plain'
]

{ #category : 'tests - content block' }
ACP2DataTypesTest >> testContentBlockResourceTextNoMimeType [

	| block dict resourceDict |
	block := ACP2ContentBlock resource: 'file:///tmp/foo.txt' text: 'hello'.
	dict := block asDictionary.
	self assert: (dict at: 'type') equals: 'resource'.
	resourceDict := dict at: 'resource'.
	self assert: (resourceDict at: 'uri') equals: 'file:///tmp/foo.txt'.
	self assert: (resourceDict at: 'text') equals: 'hello'.
	self deny: (resourceDict includesKey: 'mimeType')
]

{ #category : 'tests - content block' }
ACP2DataTypesTest >> testContentBlockResourceBlobWithMimeType [

	| block dict resourceDict |
	block := ACP2ContentBlock resource: 'file:///tmp/img.png' blob: 'base64data' mimeType: 'image/png'.
	dict := block asDictionary.
	self assert: (dict at: 'type') equals: 'resource'.
	resourceDict := dict at: 'resource'.
	self assert: (resourceDict at: 'uri') equals: 'file:///tmp/img.png'.
	self assert: (resourceDict at: 'blob') equals: 'base64data'.
	self assert: (resourceDict at: 'mimeType') equals: 'image/png'
]

{ #category : 'tests - content block' }
ACP2DataTypesTest >> testContentBlockResourceBlobNoMimeType [

	| block dict resourceDict |
	block := ACP2ContentBlock resource: 'file:///tmp/img.png' blob: 'base64data'.
	dict := block asDictionary.
	self assert: (dict at: 'type') equals: 'resource'.
	resourceDict := dict at: 'resource'.
	self assert: (resourceDict at: 'uri') equals: 'file:///tmp/img.png'.
	self assert: (resourceDict at: 'blob') equals: 'base64data'.
	self deny: (resourceDict includesKey: 'mimeType')
]

{ #category : 'tests - content block' }
ACP2DataTypesTest >> testContentBlockResourceLink [

	| block dict |
	block := ACP2ContentBlock resourceLink: 'file:///tmp/foo.txt' name: 'foo'.
	dict := block asDictionary.
	self assert: (dict at: 'type') equals: 'resource_link'.
	self assert: (dict at: 'uri') equals: 'file:///tmp/foo.txt'.
	self assert: (dict at: 'name') equals: 'foo'.
	self deny: (dict includesKey: 'title').
	self deny: (dict includesKey: 'size')
]

{ #category : 'tests - content block' }
ACP2DataTypesTest >> testContentBlockResourceLinkWithOptions [

	| block dict |
	block := ACP2ContentBlock resourceLink: 'file:///tmp/foo.txt' name: 'foo'.
	block title: 'Foo File'.
	block size: 1024.
	dict := block asDictionary.
	self assert: (dict at: 'title') equals: 'Foo File'.
	self assert: (dict at: 'size') equals: 1024
]

{ #category : 'tests - content block' }
ACP2DataTypesTest >> testContentBlockText [

	| chunk content |
	chunk := ACP2ContentChunk fromDictionary:
		         { ('content' -> { ('type' -> 'text'). ('text' -> 'hello') } asDictionary) }
			         asDictionary.
	content := chunk content.
	self assert: content class equals: ACP2ContentBlock.
	self assert: content type equals: 'text'.
	self assert: content text equals: 'hello'
]

{ #category : 'tests - content block' }
ACP2DataTypesTest >> testContentBlockResourceFromDictionary [

	| chunk content embedded |
	chunk := ACP2ContentChunk fromDictionary:
		         { ('content' -> {
				           ('type' -> 'resource').
				           ('resource' -> {
					            ('uri' -> 'file:///tmp/foo.txt').
					            ('mimeType' -> 'text/plain').
					            ('text' -> 'hello') } asDictionary) } asDictionary) }
			         asDictionary.
	content := chunk content.
	self assert: content class equals: ACP2ContentBlock.
	self assert: content type equals: 'resource'.
	embedded := content resource.
	self assert: embedded class equals: ACP2EmbeddedResource.
	self assert: embedded uri equals: 'file:///tmp/foo.txt'.
	self assert: embedded mimeType equals: 'text/plain'.
	self assert: embedded text equals: 'hello'
]

{ #category : 'tests - config option' }
ACP2DataTypesTest >> testConfigOptionBooleanFromDictionary [

	| opt |
	opt := ACP2ConfigOption fromDictionary: {
		       ('id' -> 'autoApprove').
		       ('name' -> 'Auto Approve').
		       ('type' -> 'boolean').
		       ('currentValue' -> true) } asDictionary.
	self assert: opt id equals: 'autoApprove'.
	self assert: opt name equals: 'Auto Approve'.
	self assert: opt type equals: 'boolean'.
	self assert: opt currentValue equals: true.
	self assert: opt isBoolean.
	self deny: opt isSelect
]

{ #category : 'tests - config option' }
ACP2DataTypesTest >> testConfigOptionSelectFromDictionary [

	| opt options |
	opt := ACP2ConfigOption fromDictionary: {
		       ('id' -> 'model').
		       ('name' -> 'Model').
		       ('type' -> 'select').
		       ('currentValue' -> 'claude-3').
		       ('options' -> {
			        { ('value' -> 'claude-3'). ('name' -> 'Claude 3') } asDictionary.
			        { ('value' -> 'claude-4'). ('name' -> 'Claude 4') } asDictionary }
			        asOrderedCollection) } asDictionary.
	self assert: opt id equals: 'model'.
	self assert: opt type equals: 'select'.
	self assert: opt currentValue equals: 'claude-3'.
	self assert: opt isSelect.
	options := opt options.
	self assert: options size equals: 2.
	self assert: options first class equals: ACP2ConfigSelectOption.
	self assert: options first value equals: 'claude-3'.
	self assert: options first name equals: 'Claude 3'
]

{ #category : 'tests - config option' }
ACP2DataTypesTest >> testConfigOptionSelectWithGroupsFromDictionary [

	| opt groups |
	opt := ACP2ConfigOption fromDictionary: {
		       ('id' -> 'theme').
		       ('name' -> 'Theme').
		       ('type' -> 'select').
		       ('currentValue' -> 'dark').
		       ('options' -> {
			        {
				        ('group' -> 'basic').
				        ('name' -> 'Basic Themes').
				        ('options' -> {
					         { ('value' -> 'dark'). ('name' -> 'Dark') } asDictionary.
					         { ('value' -> 'light'). ('name' -> 'Light') } asDictionary }
					         asOrderedCollection) } asDictionary }
			        asOrderedCollection) } asDictionary.
	groups := opt options.
	self assert: groups size equals: 1.
	self assert: groups first class equals: ACP2ConfigSelectGroup.
	self assert: groups first group equals: 'basic'.
	self assert: groups first name equals: 'Basic Themes'.
	self assert: groups first options size equals: 2.
	self assert: groups first options first value equals: 'dark'
]

{ #category : 'tests - config option' }
ACP2DataTypesTest >> testConfigOptionOptionalFieldsAbsent [

	| opt |
	opt := ACP2ConfigOption fromDictionary: {
		       ('id' -> 'flag').
		       ('name' -> 'Flag').
		       ('type' -> 'boolean').
		       ('currentValue' -> false) } asDictionary.
	self assert: opt description isNil.
	self assert: opt category isNil.
	self assert: opt options isEmpty
]

{ #category : 'tests - config option' }
ACP2DataTypesTest >> testConfigOptionWithCategoryAndDescription [

	| opt |
	opt := ACP2ConfigOption fromDictionary: {
		       ('id' -> 'model').
		       ('name' -> 'Model').
		       ('type' -> 'select').
		       ('currentValue' -> 'opus').
		       ('category' -> 'model').
		       ('description' -> 'Choose AI model').
		       ('options' -> OrderedCollection new) } asDictionary.
	self assert: opt category equals: 'model'.
	self assert: opt description equals: 'Choose AI model'
]

{ #category : 'tests - config option' }
ACP2DataTypesTest >> testConfigOptionCategoryPredicates [

	| model mode thoughtLevel |
	model := ACP2ConfigOption fromDictionary: { ('category' -> 'model') }
		         asDictionary.
	mode := ACP2ConfigOption fromDictionary: { ('category' -> 'mode') }
		        asDictionary.
	thoughtLevel := ACP2ConfigOption fromDictionary:
		                { ('category' -> 'thought_level') } asDictionary.

	self assert: model isModelCategory.
	self deny: model isModeCategory.
	self deny: model isThoughtLevelCategory.

	self assert: mode isModeCategory.
	self deny: mode isModelCategory.
	self deny: mode isThoughtLevelCategory.

	self assert: thoughtLevel isThoughtLevelCategory.
	self deny: thoughtLevel isModelCategory.
	self deny: thoughtLevel isModeCategory
]

{ #category : 'tests - config option' }
ACP2DataTypesTest >> testConfigOptionCategoryMutators [

	| opt |
	opt := ACP2ConfigOption new.

	opt beModelCategory.
	self assert: opt category equals: 'model'.

	opt beModeCategory.
	self assert: opt category equals: 'mode'.

	opt beThoughtLevelCategory.
	self assert: opt category equals: 'thought_level'
]
