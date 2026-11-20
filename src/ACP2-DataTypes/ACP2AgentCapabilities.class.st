"
I represent the capabilities an ACP v2 agent advertises in its initialize response (capabilities).

Responsibility:
- I decode the v2 structure: { session: ACP2SessionCapabilities, auth: ACP2AgentAuthCapabilities }
- I answer whether session methods and their extensions may be used

Collaborators:
- ACP2InitializeResponse: holds me under 'capabilities'
- ACP2SessionCapabilities: the session capabilities and their extensions
- ACP2AgentAuthCapabilities: authentication-related extension capabilities
- ACP2ClientConnection: asks me before sending capability-gated requests (e.g. systemPrompt)
- ACP2Values: my superclass

Public API:
- session / auth - typed sub-capabilities, or nil when not advertised
- isSessionSupported - session present: session/new, list, resume, close, prompt, cancel, update are supported
- isListSupported / isResumeSupported / isCloseSupported - same as isSessionSupported (baseline methods)
- isDeleteSupported / isAdditionalDirectoriesSupported / isSystemPromptSupported / isSystemPromptOverrideSupported
- isImagePromptSupported / isAudioPromptSupported / isEmbeddedContextPromptSupported
- isStdioMcpServersSupported / isHttpMcpServersSupported
- promptCapabilities / mcpCapabilities / systemPromptCapabilities - shortcuts into session, or nil

Implementation Points:
- Capabilities are presence-based: nil means not advertised, {} means advertised.
  They are therefore not lazily created and are serialized with includeNested:named:in:.
- auth/login and auth/logout are advertised by ACP2InitializeResponse >> authMethods, not by auth.
"
Class {
	#name : 'ACP2AgentCapabilities',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'instance creation' }
ACP2AgentCapabilities class >> fromDictionary: aDictionary [

	| instance |
	instance := super fromDictionary: aDictionary.
	instance
		decode: 'session' as: ACP2SessionCapabilities;
		decode: 'auth' as: ACP2AgentAuthCapabilities.
	^ instance
]

{ #category : 'converting' }
ACP2AgentCapabilities >> asDictionary [

	| dict |
	dict := super asDictionary.
	self includeNested: self session named: 'session' in: dict.
	self includeNested: self auth named: 'auth' in: dict.
	^ dict
]

{ #category : 'accessing' }
ACP2AgentCapabilities >> auth [

	^ self rawValues at: 'auth' ifAbsent: []
]

{ #category : 'accessing' }
ACP2AgentCapabilities >> auth: anACP2AgentAuthCapabilities [

	self rawValues at: 'auth' put: anACP2AgentAuthCapabilities
]

{ #category : 'testing' }
ACP2AgentCapabilities >> isAdditionalDirectoriesSupported [

	^ self session notNil and: [ self session isAdditionalDirectoriesSupported ]
]

{ #category : 'testing' }
ACP2AgentCapabilities >> isAudioPromptSupported [

	^ self promptCapabilities notNil and: [ self promptCapabilities isAudioSupported ]
]

{ #category : 'testing' }
ACP2AgentCapabilities >> isCloseSupported [

	^ self isSessionSupported
]

{ #category : 'testing' }
ACP2AgentCapabilities >> isDeleteSupported [

	^ self session notNil and: [ self session isDeleteSupported ]
]

{ #category : 'testing' }
ACP2AgentCapabilities >> isEmbeddedContextPromptSupported [

	^ self promptCapabilities notNil and: [
		  self promptCapabilities isEmbeddedContextSupported ]
]

{ #category : 'testing' }
ACP2AgentCapabilities >> isHttpMcpServersSupported [

	^ self mcpCapabilities notNil and: [ self mcpCapabilities isHttpSupported ]
]

{ #category : 'testing' }
ACP2AgentCapabilities >> isImagePromptSupported [

	^ self promptCapabilities notNil and: [ self promptCapabilities isImageSupported ]
]

{ #category : 'testing' }
ACP2AgentCapabilities >> isListSupported [

	^ self isSessionSupported
]

{ #category : 'testing' }
ACP2AgentCapabilities >> isResumeSupported [

	^ self isSessionSupported
]

{ #category : 'testing' }
ACP2AgentCapabilities >> isSessionSupported [
	"A present session object, even {}, means the baseline session methods are supported."

	^ self session notNil
]

{ #category : 'testing' }
ACP2AgentCapabilities >> isStdioMcpServersSupported [

	^ self mcpCapabilities notNil and: [ self mcpCapabilities isStdioSupported ]
]

{ #category : 'testing' }
ACP2AgentCapabilities >> isSystemPromptOverrideSupported [

	^ self isSystemPromptSupported and: [
		  self systemPromptCapabilities isOverrideSupported ]
]

{ #category : 'testing' }
ACP2AgentCapabilities >> isSystemPromptSupported [

	^ self systemPromptCapabilities notNil
]

{ #category : 'accessing' }
ACP2AgentCapabilities >> mcpCapabilities [
	"ACP2McpCapabilities from session.mcp, or nil when not advertised."

	^ self session ifNotNil: [ :session | session mcp ]
]

{ #category : 'accessing' }
ACP2AgentCapabilities >> promptCapabilities [
	"ACP2PromptCapabilities from session.prompt, or nil when not advertised."

	^ self session ifNotNil: [ :session | session prompt ]
]

{ #category : 'accessing' }
ACP2AgentCapabilities >> session [

	^ self rawValues at: 'session' ifAbsent: []
]

{ #category : 'accessing' }
ACP2AgentCapabilities >> session: anACP2SessionCapabilities [

	self rawValues at: 'session' put: anACP2SessionCapabilities
]

{ #category : 'accessing' }
ACP2AgentCapabilities >> systemPromptCapabilities [
	"ACP2SessionSystemPromptCapabilities from session.systemPrompt, or nil when not advertised."

	^ self session ifNotNil: [ :session | session systemPrompt ]
]
