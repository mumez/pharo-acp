Class {
	#name : 'ACPAuthenticateRequest',
	#superclass : 'ACPOptions',
	#instVars : [
		'methodId'
	],
	#category : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPAuthenticateRequest >> asDictionary [

	| dict |
	dict := Dictionary new.
	self methodId ifNotNil: [ :v | dict at: 'methodId' put: v ].
	self extraPropertiesOn: dict.
	^ dict
]

{ #category : 'accessing' }
ACPAuthenticateRequest >> methodId [

	^ methodId
]

{ #category : 'accessing' }
ACPAuthenticateRequest >> methodId: aString [

	methodId := aString
]
