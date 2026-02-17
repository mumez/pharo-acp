Class {
	#name : 'ACPSetSessionModeRequest',
	#superclass : 'ACPOptions',
	#instVars : [
		'sessionId',
		'modeId'
	],
	#category : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPSetSessionModeRequest >> asDictionary [

	| dict |
	dict := Dictionary new.
	self sessionId ifNotNil: [ :v | dict at: 'sessionId' put: v ].
	self modeId ifNotNil: [ :v | dict at: 'modeId' put: v ].
	self extraPropertiesOn: dict.
	^ dict
]

{ #category : 'accessing' }
ACPSetSessionModeRequest >> modeId [

	^ modeId
]

{ #category : 'accessing' }
ACPSetSessionModeRequest >> modeId: aString [

	modeId := aString
]

{ #category : 'accessing' }
ACPSetSessionModeRequest >> sessionId [

	^ sessionId
]

{ #category : 'accessing' }
ACPSetSessionModeRequest >> sessionId: aString [

	sessionId := aString
]
