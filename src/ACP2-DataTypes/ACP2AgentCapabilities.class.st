Class {
	#name : 'ACP2AgentCapabilities',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2AgentCapabilities >> loadSession [

	^ self rawValues at: 'loadSession' ifAbsent: []
]

{ #category : 'testing' }
ACP2AgentCapabilities >> isLoadSupported [

	^ self loadSession = true
]

{ #category : 'testing' }
ACP2AgentCapabilities >> isMcpServersSupported [

	| caps |
	caps := self rawValues at: 'mcpCapabilities' ifAbsent: [ nil ].
	^ (caps isNil or: [ caps isEmpty ]) not
]

{ #category : 'testing' }
ACP2AgentCapabilities >> isHttpMcpServersSupported [

	^ self isMcpServersSupported and: [ self mcpCapabilities http = true ]
]

{ #category : 'testing' }
ACP2AgentCapabilities >> isSseMcpServersSupported [

	^ self isMcpServersSupported and: [ self mcpCapabilities sse = true ]
]

{ #category : 'testing' }
ACP2AgentCapabilities >> isListSupported [

	^ self sessionCapabilities list notNil
]

{ #category : 'testing' }
ACP2AgentCapabilities >> isCloseSupported [

	^ self sessionCapabilities close notNil
]

{ #category : 'testing' }
ACP2AgentCapabilities >> isResumeSupported [

	^ self sessionCapabilities resume notNil
]

{ #category : 'accessing' }
ACP2AgentCapabilities >> loadSession: aBoolean [

	self rawValues at: 'loadSession' put: aBoolean
]

{ #category : 'accessing' }
ACP2AgentCapabilities >> mcpCapabilities [

	^ self rawValues at: 'mcpCapabilities' ifAbsentPut: [ ACP2McpCapabilities new ]
]

{ #category : 'accessing' }
ACP2AgentCapabilities >> mcpCapabilities: anObject [

	self rawValues at: 'mcpCapabilities' put: anObject
]

{ #category : 'accessing' }
ACP2AgentCapabilities >> promptCapabilities [

	^ self rawValues at: 'promptCapabilities' ifAbsentPut: [ ACP2PromptCapabilities new ]
]

{ #category : 'accessing' }
ACP2AgentCapabilities >> promptCapabilities: anObject [

	self rawValues at: 'promptCapabilities' put: anObject
]

{ #category : 'accessing' }
ACP2AgentCapabilities >> sessionCapabilities [

	^ self rawValues at: 'sessionCapabilities' ifAbsentPut: [ ACP2SessionCapabilities new ]
]

{ #category : 'accessing' }
ACP2AgentCapabilities >> sessionCapabilities: anObject [

	self rawValues at: 'sessionCapabilities' put: anObject
]

{ #category : 'instance creation' }
ACP2AgentCapabilities class >> fromDictionary: aDictionary [

	| instance |
	instance := super fromDictionary: aDictionary.
	instance rawValues at: 'mcpCapabilities' ifPresent: [ :dict | instance mcpCapabilities: (ACP2McpCapabilities fromDictionary: dict) ].
	instance rawValues at: 'promptCapabilities' ifPresent: [ :dict | instance promptCapabilities: (ACP2PromptCapabilities fromDictionary: dict) ].
	instance rawValues at: 'sessionCapabilities' ifPresent: [ :dict | instance sessionCapabilities: (ACP2SessionCapabilities fromDictionary: dict) ].
	^ instance
]

{ #category : 'converting' }
ACP2AgentCapabilities >> asDictionary [
	| dict |
	dict := super asDictionary.
	self trimNested: self mcpCapabilities named: 'mcpCapabilities' in: dict.
	self trimNested: self promptCapabilities named: 'promptCapabilities' in: dict.
	self trimNested: self sessionCapabilities named: 'sessionCapabilities' in: dict.
	^ dict
]
