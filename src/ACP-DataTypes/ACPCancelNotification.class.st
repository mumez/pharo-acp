Class {
	#name : 'ACPCancelNotification',
	#superclass : 'ACPOptions',
	#instVars : [
		'sessionId'
	],
	#category : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPCancelNotification >> asDictionary [

	| dict |
	dict := Dictionary new.
	self sessionId ifNotNil: [ :v | dict at: 'sessionId' put: v ].
	self extraPropertiesOn: dict.
	^ dict
]

{ #category : 'accessing' }
ACPCancelNotification >> sessionId [

	^ sessionId
]

{ #category : 'accessing' }
ACPCancelNotification >> sessionId: aString [

	sessionId := aString
]
