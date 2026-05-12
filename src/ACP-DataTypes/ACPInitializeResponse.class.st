Class {
	#name : 'ACPInitializeResponse',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'instance creation' }
ACPInitializeResponse class >> fromDictionary: aDictionary [

	| instance |
	instance := super fromDictionary: aDictionary.
	instance rawValues at: 'agentCapabilities' ifPresent: [ :dict |
		instance agentCapabilities: (ACPAgentCapabilities fromDictionary: dict) ].
	^ instance
]

{ #category : 'accessing' }
ACPInitializeResponse >> agentCapabilities [

	^ self rawValues at: 'agentCapabilities' ifAbsentPut: [ ACPAgentCapabilities new ]
]

{ #category : 'accessing' }
ACPInitializeResponse >> agentCapabilities: anObject [

	self rawValues at: 'agentCapabilities' put: anObject
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

{ #category : 'converting' }
ACPInitializeResponse >> asDictionary [

	| dict |
	dict := super asDictionary.
	self trimNested: self agentCapabilities named: 'agentCapabilities' in: dict.
	^ dict
]
