Class {
	#name : 'ACPSetSessionConfigOptionRequest',
	#superclass : 'ACPOptions',
	#instVars : [
		'sessionId',
		'configId',
		'value'
	],
	#category : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPSetSessionConfigOptionRequest >> asDictionary [

	| dict |
	dict := Dictionary new.
	self sessionId ifNotNil: [ :v | dict at: 'sessionId' put: v ].
	self configId ifNotNil: [ :v | dict at: 'configId' put: v ].
	self value ifNotNil: [ :v | dict at: 'value' put: v ].
	self extraPropertiesOn: dict.
	^ dict
]

{ #category : 'accessing' }
ACPSetSessionConfigOptionRequest >> configId [

	^ configId
]

{ #category : 'accessing' }
ACPSetSessionConfigOptionRequest >> configId: aString [

	configId := aString
]

{ #category : 'accessing' }
ACPSetSessionConfigOptionRequest >> sessionId [

	^ sessionId
]

{ #category : 'accessing' }
ACPSetSessionConfigOptionRequest >> sessionId: aString [

	sessionId := aString
]

{ #category : 'accessing' }
ACPSetSessionConfigOptionRequest >> value [

	^ value
]

{ #category : 'accessing' }
ACPSetSessionConfigOptionRequest >> value: aString [

	value := aString
]
