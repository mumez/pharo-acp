"
I test the ACP v2 capability structures and the v2 initialize/prompt response shapes.

Responsibility:
- I verify ACP2AgentCapabilities decodes { session: {...}, auth: {...} }, where presence ({}) means supported
- I verify ACP2ClientCapabilities encodes { auth: { terminal }, elicitation }
- I verify login/logout support comes from authMethods, and session/prompt answers messageId

Collaborators:
- ACP2AgentCapabilities, ACP2SessionCapabilities, ACP2PromptCapabilities, ACP2McpCapabilities
- ACP2ClientCapabilities, ACP2ClientAuthCapabilities, ACP2InitializeResponse, ACP2PromptResponse
"
Class {
	#name : 'ACP2CapabilitiesTest',
	#superclass : 'TestCase',
	#category : 'ACP2-Tests',
	#package : 'ACP2-Tests'
}

{ #category : 'helpers' }
ACP2CapabilitiesTest >> agentCapabilitiesWithSession: aDictionary [

	^ ACP2AgentCapabilities fromDictionary:
		  { ('session' -> aDictionary) } asDictionary
]

{ #category : 'helpers' }
ACP2CapabilitiesTest >> fullSessionDictionary [

	^ {
		  ('prompt' -> {
			   ('image' -> Dictionary new).
			   ('audio' -> Dictionary new).
			   ('embeddedContext' -> Dictionary new) } asDictionary).
		  ('mcp' -> {
			   ('stdio' -> Dictionary new).
			   ('http' -> Dictionary new) } asDictionary).
		  ('delete' -> Dictionary new).
		  ('additionalDirectories' -> Dictionary new).
		  ('systemPrompt' -> Dictionary new) } asDictionary
]

{ #category : 'tests - agent' }
ACP2CapabilitiesTest >> testAgentCapabilitiesAbsentMeansNothingSupported [

	| caps |
	caps := ACP2AgentCapabilities fromDictionary: Dictionary new.
	self assert: caps session isNil.
	self assert: caps auth isNil.
	self deny: caps isSessionSupported.
	self deny: caps isListSupported.
	self deny: caps isResumeSupported.
	self deny: caps isCloseSupported.
	self deny: caps isDeleteSupported.
	self deny: caps isAdditionalDirectoriesSupported.
	self deny: caps isSystemPromptSupported.
	self deny: caps isImagePromptSupported.
	self deny: caps isStdioMcpServersSupported.
	self assert: caps promptCapabilities isNil.
	self assert: caps mcpCapabilities isNil
]

{ #category : 'tests - agent' }
ACP2CapabilitiesTest >> testAgentCapabilitiesAuthIsDecoded [

	| caps |
	caps := ACP2AgentCapabilities fromDictionary:
		        { ('auth' -> Dictionary new) } asDictionary.
	self assert: caps auth class equals: ACP2AgentAuthCapabilities
]

{ #category : 'tests - agent' }
ACP2CapabilitiesTest >> testAgentCapabilitiesBuildAndSerialize [

	| caps session |
	session := ACP2SessionCapabilities new.
	session enableDelete.
	session mcp: (ACP2McpCapabilities new
			 enableStdio;
			 yourself).
	caps := ACP2AgentCapabilities buildBy: [ :c | c session: session ].
	self assert: caps asDictionary equals: { ('session' -> {
				 ('delete' -> Dictionary new).
				 ('mcp' -> { ('stdio' -> Dictionary new) } asDictionary) }
				 asDictionary) } asDictionary
]

{ #category : 'tests - agent' }
ACP2CapabilitiesTest >> testAgentCapabilitiesEmptySessionIsBaseline [

	| caps |
	caps := self agentCapabilitiesWithSession: Dictionary new.
	self assert: caps session class equals: ACP2SessionCapabilities.
	self assert: caps isSessionSupported.
	self assert: caps isListSupported.
	self assert: caps isResumeSupported.
	self assert: caps isCloseSupported.
	self deny: caps isDeleteSupported.
	self deny: caps isAdditionalDirectoriesSupported.
	self deny: caps isSystemPromptSupported.
	self deny: caps isImagePromptSupported.
	self deny: caps isHttpMcpServersSupported
]

{ #category : 'tests - agent' }
ACP2CapabilitiesTest >> testAgentCapabilitiesFullSession [

	| caps |
	caps := self agentCapabilitiesWithSession: self fullSessionDictionary.
	self assert: caps isDeleteSupported.
	self assert: caps isAdditionalDirectoriesSupported.
	self assert: caps isSystemPromptSupported.
	self assert: caps isImagePromptSupported.
	self assert: caps isAudioPromptSupported.
	self assert: caps isEmbeddedContextPromptSupported.
	self assert: caps isStdioMcpServersSupported.
	self assert: caps isHttpMcpServersSupported.
	self assert: caps promptCapabilities class equals: ACP2PromptCapabilities.
	self assert: caps mcpCapabilities class equals: ACP2McpCapabilities
]

{ #category : 'tests - agent' }
ACP2CapabilitiesTest >> testAgentCapabilitiesIgnoresV1Keys [

	| caps |
	caps := ACP2AgentCapabilities fromDictionary: {
			        ('loadSession' -> true).
			        ('sessionCapabilities' -> { ('resume' -> Dictionary new) } asDictionary).
			        ('promptCapabilities' -> { ('image' -> true) } asDictionary) }
			        asDictionary.
	self deny: caps isSessionSupported.
	self deny: caps isResumeSupported.
	self deny: caps isImagePromptSupported
]

{ #category : 'tests - agent' }
ACP2CapabilitiesTest >> testAgentCapabilitiesNullSessionIsDropped [

	| caps |
	caps := ACP2AgentCapabilities fromDictionary: {
			        ('session' -> nil).
			        ('auth' -> nil) } asDictionary.
	self deny: caps isSessionSupported.
	self assert: caps asDictionary isEmpty
]

{ #category : 'tests - agent' }
ACP2CapabilitiesTest >> testAgentCapabilitiesRoundTripKeepsEmptyObjects [

	| raw |
	raw := {
		       ('session' -> self fullSessionDictionary).
		       ('auth' -> Dictionary new) } asDictionary.
	self
		assert: (ACP2AgentCapabilities fromDictionary: raw copy) asDictionary
		equals: raw.
	self
		assert: (self agentCapabilitiesWithSession: Dictionary new) asDictionary
		equals: { ('session' -> Dictionary new) } asDictionary
]

{ #category : 'tests - agent' }
ACP2CapabilitiesTest >> testInitializeResponseDecodesV2Capabilities [

	| resp |
	resp := ACP2InitializeResponse fromDictionary: {
			        ('protocolVersion' -> 2).
			        ('info' -> { ('name' -> 'agent') } asDictionary).
			        ('capabilities' -> { ('session' -> Dictionary new) } asDictionary) }
			        asDictionary.
	self assert: resp capabilities class equals: ACP2AgentCapabilities.
	self assert: resp capabilities isSessionSupported
]

{ #category : 'tests - auth methods' }
ACP2CapabilitiesTest >> testInitializeResponseLoginSupportedWithAuthMethods [

	| resp |
	resp := ACP2InitializeResponse fromDictionary: { ('authMethods' -> { {
				         ('id' -> 'oauth').
				         ('name' -> 'OAuth') } asDictionary }) } asDictionary.
	self assert: resp authMethods size equals: 1.
	self assert: resp isLoginSupported.
	self assert: resp isLogoutSupported
]

{ #category : 'tests - auth methods' }
ACP2CapabilitiesTest >> testInitializeResponseNoAuthMethods [

	self deny: ACP2InitializeResponse new isLoginSupported.
	self deny: (ACP2InitializeResponse fromDictionary:
			 { ('authMethods' -> #(  )) } asDictionary) isLogoutSupported.
	self deny: (ACP2InitializeResponse fromDictionary:
			 { ('authMethods' -> nil) } asDictionary) isLogoutSupported
]

{ #category : 'tests - client' }
ACP2CapabilitiesTest >> testClientCapabilitiesDecodesAuthAndElicitation [

	| caps |
	caps := ACP2ClientCapabilities fromDictionary: {
			        ('auth' -> { ('terminal' -> Dictionary new) } asDictionary).
			        ('elicitation' -> { ('form' -> Dictionary new) } asDictionary) }
			        asDictionary.
	self assert: caps auth class equals: ACP2ClientAuthCapabilities.
	self assert: caps auth isTerminalSupported.
	self assert: caps elicitation isFormSupported
]

{ #category : 'tests - client' }
ACP2CapabilitiesTest >> testClientCapabilitiesEmptyIsOmitted [

	| caps |
	caps := ACP2ClientCapabilities new.
	caps auth.
	caps elicitation.
	self assert: caps asDictionary isEmpty.
	self deny: caps auth isTerminalSupported
]

{ #category : 'tests - client' }
ACP2CapabilitiesTest >> testClientCapabilitiesHasNoV1Fields [

	| caps |
	caps := ACP2ClientCapabilities new.
	self deny: (caps respondsTo: #fs).
	self deny: (caps respondsTo: #terminal:).
	self deny: (caps asDictionary includesKey: 'fs')
]

{ #category : 'tests - client' }
ACP2CapabilitiesTest >> testClientCapabilitiesTerminalAuth [

	| caps |
	caps := ACP2ClientCapabilities new.
	caps auth enableTerminal.
	self
		assert: caps asDictionary
		equals: { ('auth' -> { ('terminal' -> Dictionary new) } asDictionary) }
				asDictionary
]

{ #category : 'tests - prompt response' }
ACP2CapabilitiesTest >> testPromptResponseMessageId [

	| resp |
	resp := ACP2PromptResponse fromDictionary:
		        { ('messageId' -> 'msg-1') } asDictionary.
	self assert: resp messageId equals: 'msg-1'.
	self deny: (resp respondsTo: #stopReason)
]

{ #category : 'tests - session' }
ACP2CapabilitiesTest >> testPromptCapabilitiesEnable [

	| caps |
	caps := ACP2PromptCapabilities new.
	self deny: caps isImageSupported.
	caps enableImage; enableAudio; enableEmbeddedContext.
	self assert: caps isImageSupported.
	self assert: caps isAudioSupported.
	self assert: caps isEmbeddedContextSupported
]

{ #category : 'tests - session' }
ACP2CapabilitiesTest >> testMcpCapabilitiesEnable [

	| caps |
	caps := ACP2McpCapabilities new.
	self deny: caps isStdioSupported.
	caps enableStdio; enableHttp.
	self assert: caps isStdioSupported.
	self assert: caps isHttpSupported.
	self deny: (caps respondsTo: #sse)
]
