Class {
	#name : 'ACPInitializeResponse',
	#superclass : 'ACPResult',
	#category : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPInitializeResponse >> agentCapabilities [

	^ self rawDictionary at: 'agentCapabilities' ifAbsent: []
]

{ #category : 'accessing' }
ACPInitializeResponse >> agentInfo [

	^ self rawDictionary at: 'agentInfo' ifAbsent: []
]

{ #category : 'accessing' }
ACPInitializeResponse >> authMethods [

	^ self rawDictionary at: 'authMethods' ifAbsent: []
]

{ #category : 'accessing' }
ACPInitializeResponse >> protocolVersion [

	^ self rawDictionary at: 'protocolVersion' ifAbsent: []
]
