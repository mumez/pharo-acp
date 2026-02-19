Class {
	#name : 'ACPSetSessionConfigOptionParams',
	#superclass : 'ACPParams',
	#instVars : [
		'sessionId',
		'configId',
		'value'
	],
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPSetSessionConfigOptionParams >> asDictionary [

	| dict |
	dict := Dictionary new.
	self sessionId ifNotNil: [ :v | dict at: 'sessionId' put: v ].
	self configId ifNotNil: [ :v | dict at: 'configId' put: v ].
	self value ifNotNil: [ :v | dict at: 'value' put: v ].
	self extraPropertiesOn: dict.
	^ dict
]

{ #category : 'accessing' }
ACPSetSessionConfigOptionParams >> configId [

	^ configId
]

{ #category : 'accessing' }
ACPSetSessionConfigOptionParams >> configId: aString [

	configId := aString
]

{ #category : 'accessing' }
ACPSetSessionConfigOptionParams >> sessionId [

	^ sessionId
]

{ #category : 'accessing' }
ACPSetSessionConfigOptionParams >> sessionId: aString [

	sessionId := aString
]

{ #category : 'accessing' }
ACPSetSessionConfigOptionParams >> value [

	^ value
]

{ #category : 'accessing' }
ACPSetSessionConfigOptionParams >> value: aString [

	value := aString
]
