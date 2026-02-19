Class {
	#name : 'ACPAuthenticateParams',
	#superclass : 'ACPValues',
	#instVars : [
		'methodId'
	],
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPAuthenticateParams >> asDictionary [

	| dict |
	dict := Dictionary new.
	self methodId ifNotNil: [ :v | dict at: 'methodId' put: v ].
	self extraPropertiesOn: dict.
	^ dict
]

{ #category : 'accessing' }
ACPAuthenticateParams >> methodId [

	^ methodId
]

{ #category : 'accessing' }
ACPAuthenticateParams >> methodId: aString [

	methodId := aString
]
