Class {
	#name : 'ACP2InitializeResponse',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'instance creation' }
ACP2InitializeResponse class >> fromDictionary: aDictionary [

	| instance |
	instance := super fromDictionary: aDictionary.
	instance rawValues at: 'capabilities' ifPresent: [ :dict |
		instance capabilities: (ACP2AgentCapabilities fromDictionary: dict) ].
	^ instance
]

{ #category : 'accessing' }
ACP2InitializeResponse >> capabilities [

	^ self rawValues at: 'capabilities' ifAbsentPut: [ ACP2AgentCapabilities new ]
]

{ #category : 'accessing' }
ACP2InitializeResponse >> capabilities: anObject [

	self rawValues at: 'capabilities' put: anObject
]

{ #category : 'accessing' }
ACP2InitializeResponse >> info [

	^ self rawValues at: 'info' ifAbsent: []
]

{ #category : 'accessing' }
ACP2InitializeResponse >> protocolVersion [

	^ self rawValues at: 'protocolVersion' ifAbsent: []
]

{ #category : 'converting' }
ACP2InitializeResponse >> asDictionary [

	| dict |
	dict := super asDictionary.
	self trimNested: self capabilities named: 'capabilities' in: dict.
	^ dict
]
