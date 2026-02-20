Class {
	#name : 'ACPInitializeResponse',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPInitializeResponse >> agentCapabilities [

	^ self rawValues at: 'agentCapabilities' ifAbsent: []
]

{ #category : 'accessing' }
ACPInitializeResponse >> agentInfo [

	^ self rawValues at: 'agentInfo' ifAbsent: []
]

{ #category : 'accessing' }
ACPInitializeResponse >> authMethods [

	^ self rawValues at: 'authMethods' ifAbsent: []
]

{ #category : 'accessing' }
ACPInitializeResponse >> protocolVersion [

	^ self rawValues at: 'protocolVersion' ifAbsent: []
]
