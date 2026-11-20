"
I represent the session capabilities of an ACP v2 agent (capabilities.session).

Responsibility:
- My presence (even as {}) means the agent supports the baseline session methods:
  session/new, session/list, session/resume, session/close, session/prompt, session/cancel, session/update
- I decode the optional extensions: prompt content types, MCP transports, session/delete,
  additionalDirectories, and client-provided systemPrompt

Collaborators:
- ACP2AgentCapabilities: holds me under 'session'
- ACP2PromptCapabilities, ACP2McpCapabilities, ACP2SessionSystemPromptCapabilities: my typed sub-capabilities
- ACP2Values: my superclass

Public API:
- prompt / mcp / systemPrompt - typed sub-capabilities, or nil when not advertised
- delete / additionalDirectories - raw capability dictionaries, or nil
- isDeleteSupported / isAdditionalDirectoriesSupported - whether an extension is advertised
- enableDelete / enableAdditionalDirectories, prompt: / mcp: / systemPrompt: - build capabilities

Implementation Points:
- Sub-capabilities are presence-based: nil means not advertised, {} means advertised.
  They are therefore not lazily created and are serialized with includeNested:named:in:.
"
Class {
	#name : 'ACP2SessionCapabilities',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'instance creation' }
ACP2SessionCapabilities class >> fromDictionary: aDictionary [

	| instance |
	instance := super fromDictionary: aDictionary.
	instance
		decode: 'prompt' as: ACP2PromptCapabilities;
		decode: 'mcp' as: ACP2McpCapabilities;
		decode: 'systemPrompt' as: ACP2SessionSystemPromptCapabilities.
	^ instance
]

{ #category : 'accessing' }
ACP2SessionCapabilities >> additionalDirectories [

	^ self rawValues at: 'additionalDirectories' ifAbsent: []
]

{ #category : 'converting' }
ACP2SessionCapabilities >> asDictionary [

	| dict |
	dict := super asDictionary.
	self includeNested: self prompt named: 'prompt' in: dict.
	self includeNested: self mcp named: 'mcp' in: dict.
	self includeNested: self systemPrompt named: 'systemPrompt' in: dict.
	^ dict
]

{ #category : 'accessing' }
ACP2SessionCapabilities >> delete [

	^ self rawValues at: 'delete' ifAbsent: []
]

{ #category : 'actions' }
ACP2SessionCapabilities >> enableAdditionalDirectories [

	self rawValues at: 'additionalDirectories' put: Dictionary new
]

{ #category : 'actions' }
ACP2SessionCapabilities >> enableDelete [

	self rawValues at: 'delete' put: Dictionary new
]

{ #category : 'testing' }
ACP2SessionCapabilities >> isAdditionalDirectoriesSupported [

	^ self additionalDirectories notNil
]

{ #category : 'testing' }
ACP2SessionCapabilities >> isDeleteSupported [

	^ self delete notNil
]

{ #category : 'accessing' }
ACP2SessionCapabilities >> mcp [

	^ self rawValues at: 'mcp' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionCapabilities >> mcp: anACP2McpCapabilities [

	self rawValues at: 'mcp' put: anACP2McpCapabilities
]

{ #category : 'accessing' }
ACP2SessionCapabilities >> prompt [

	^ self rawValues at: 'prompt' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionCapabilities >> prompt: anACP2PromptCapabilities [

	self rawValues at: 'prompt' put: anACP2PromptCapabilities
]

{ #category : 'accessing' }
ACP2SessionCapabilities >> systemPrompt [

	^ self rawValues at: 'systemPrompt' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionCapabilities >> systemPrompt: anACP2SessionSystemPromptCapabilities [

	self rawValues at: 'systemPrompt' put: anACP2SessionSystemPromptCapabilities
]
