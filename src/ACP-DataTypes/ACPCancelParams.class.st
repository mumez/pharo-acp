Class {
	#name : 'ACPCancelParams',
	#superclass : 'ACPParams',
	#instVars : [
		'sessionId'
	],
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPCancelParams >> asDictionary [

	| dict |
	dict := Dictionary new.
	self sessionId ifNotNil: [ :v | dict at: 'sessionId' put: v ].
	self extraPropertiesOn: dict.
	^ dict
]

{ #category : 'accessing' }
ACPCancelParams >> sessionId [

	^ sessionId
]

{ #category : 'accessing' }
ACPCancelParams >> sessionId: aString [

	sessionId := aString
]
