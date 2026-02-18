Class {
	#name : 'ACPSetSessionModelParams',
	#superclass : 'ACPOptions',
	#instVars : [
		'sessionId',
		'modelId'
	],
	#category : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPSetSessionModelParams >> asDictionary [

	| dict |
	dict := Dictionary new.
	self sessionId ifNotNil: [ :v | dict at: 'sessionId' put: v ].
	self modelId ifNotNil: [ :v | dict at: 'modelId' put: v ].
	self extraPropertiesOn: dict.
	^ dict
]

{ #category : 'accessing' }
ACPSetSessionModelParams >> modelId [

	^ modelId
]

{ #category : 'accessing' }
ACPSetSessionModelParams >> modelId: aString [

	modelId := aString
]

{ #category : 'accessing' }
ACPSetSessionModelParams >> sessionId [

	^ sessionId
]

{ #category : 'accessing' }
ACPSetSessionModelParams >> sessionId: aString [

	sessionId := aString
]
