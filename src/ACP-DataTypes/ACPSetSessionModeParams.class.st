Class {
	#name : 'ACPSetSessionModeParams',
	#superclass : 'ACPParams',
	#instVars : [
		'sessionId',
		'modeId'
	],
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPSetSessionModeParams >> asDictionary [

	| dict |
	dict := Dictionary new.
	self sessionId ifNotNil: [ :v | dict at: 'sessionId' put: v ].
	self modeId ifNotNil: [ :v | dict at: 'modeId' put: v ].
	self extraPropertiesOn: dict.
	^ dict
]

{ #category : 'accessing' }
ACPSetSessionModeParams >> modeId [

	^ modeId
]

{ #category : 'accessing' }
ACPSetSessionModeParams >> modeId: aString [

	modeId := aString
]

{ #category : 'accessing' }
ACPSetSessionModeParams >> sessionId [

	^ sessionId
]

{ #category : 'accessing' }
ACPSetSessionModeParams >> sessionId: aString [

	sessionId := aString
]
