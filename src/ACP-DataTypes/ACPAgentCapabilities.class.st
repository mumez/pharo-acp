Class {
	#name : 'ACPAgentCapabilities',
	#superclass : 'ACPResult',
	#category : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPAgentCapabilities >> loadSession [

	^ self rawDictionary at: 'loadSession' ifAbsent: []
]

{ #category : 'accessing' }
ACPAgentCapabilities >> mcpCapabilities [

	^ self rawDictionary at: 'mcpCapabilities' ifAbsent: []
]

{ #category : 'accessing' }
ACPAgentCapabilities >> promptCapabilities [

	^ self rawDictionary at: 'promptCapabilities' ifAbsent: []
]

{ #category : 'accessing' }
ACPAgentCapabilities >> sessionCapabilities [

	^ self rawDictionary at: 'sessionCapabilities' ifAbsent: []
]
