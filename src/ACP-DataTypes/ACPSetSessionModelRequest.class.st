Class {
	#name : 'ACPSetSessionModelRequest',
	#superclass : 'ACPOptions',
	#instVars : [
		'sessionId',
		'modelId'
	],
	#category : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPSetSessionModelRequest >> asDictionary [

	| dict |
	dict := Dictionary new.
	self sessionId ifNotNil: [ :v | dict at: 'sessionId' put: v ].
	self modelId ifNotNil: [ :v | dict at: 'modelId' put: v ].
	self extraPropertiesOn: dict.
	^ dict
]

{ #category : 'accessing' }
ACPSetSessionModelRequest >> modelId [

	^ modelId
]

{ #category : 'accessing' }
ACPSetSessionModelRequest >> modelId: aString [

	modelId := aString
]

{ #category : 'accessing' }
ACPSetSessionModelRequest >> sessionId [

	^ sessionId
]

{ #category : 'accessing' }
ACPSetSessionModelRequest >> sessionId: aString [

	sessionId := aString
]
