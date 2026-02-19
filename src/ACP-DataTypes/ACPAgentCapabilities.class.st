Class {
	#name : 'ACPAgentCapabilities',
	#superclass : 'ACPReturnValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPAgentCapabilities >> loadSession [

	^ self rawValues at: 'loadSession' ifAbsent: []
]

{ #category : 'accessing' }
ACPAgentCapabilities >> mcpCapabilities [

	^ self rawValues at: 'mcpCapabilities' ifAbsent: []
]

{ #category : 'accessing' }
ACPAgentCapabilities >> promptCapabilities [

	^ self rawValues at: 'promptCapabilities' ifAbsent: []
]

{ #category : 'accessing' }
ACPAgentCapabilities >> sessionCapabilities [

	^ self rawValues at: 'sessionCapabilities' ifAbsent: []
]
