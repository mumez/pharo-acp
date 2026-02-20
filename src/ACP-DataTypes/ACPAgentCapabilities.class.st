Class {
	#name : 'ACPAgentCapabilities',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPAgentCapabilities >> loadSession [

	^ self rawValues at: 'loadSession' ifAbsent: []
]

{ #category : 'accessing' }
ACPAgentCapabilities >> mcpCapabilities [

	^ self rawValues at: 'mcpCapabilities' ifAbsentPut: [ ACPMcpCapabilities new ]
]

{ #category : 'accessing' }
ACPAgentCapabilities >> promptCapabilities [

	^ self rawValues at: 'promptCapabilities' ifAbsentPut: [ ACPPromptCapabilities new ]
]

{ #category : 'accessing' }
ACPAgentCapabilities >> sessionCapabilities [

	^ self rawValues at: 'sessionCapabilities' ifAbsentPut: [ ACPSessionCapabilities new ]
]

{ #category : 'instance creation' }
ACPAgentCapabilities class >> fromDictionary: aDictionary [

	| instance |
	instance := super fromDictionary: aDictionary.
	instance rawValues at: 'mcpCapabilities' ifPresent: [ :dict | instance mcpCapabilities: ACPMcpCapabilities fromDictionary: dict ].
	instance rawValues at: 'promptCapabilities' ifPresent: [ :dict | instance promptCapabilities: ACPPromptCapabilities fromDictionary: dict ].
	instance rawValues at: 'sessionCapabilities' ifPresent: [ :dict | instance sessionCapabilities: ACPSessionCapabilities fromDictionary: dict ].
	^ instance
]

{ #category : 'converting' }
ACPAgentCapabilities >> asDictionary [
	| dict |
	dict := super asDictionary.
	dict at: 'mcpCapabilities' put: self mcpCapabilities asDictionary.
	dict at: 'promptCapabilities' put: self promptCapabilities asDictionary.
	dict at: 'sessionCapabilities' put: self sessionCapabilities asDictionary.
	^ dict
]