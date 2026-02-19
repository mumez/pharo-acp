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

	^ (self rawValues at: 'mcpCapabilities' ifAbsent: [ ^ nil ])
		  ifNotNil: [ :dict | ACPMcpCapabilities fromDictionary: dict ]
]

{ #category : 'accessing' }
ACPAgentCapabilities >> promptCapabilities [

	^ (self rawValues at: 'promptCapabilities' ifAbsent: [ ^ nil ])
		  ifNotNil: [ :dict | ACPPromptCapabilities fromDictionary: dict ]
]

{ #category : 'accessing' }
ACPAgentCapabilities >> sessionCapabilities [

	^ (self rawValues at: 'sessionCapabilities' ifAbsent: [ ^ nil ])
		  ifNotNil: [ :dict | ACPSessionCapabilities fromDictionary: dict ]
]
