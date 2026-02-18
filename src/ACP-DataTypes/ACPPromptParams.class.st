Class {
	#name : 'ACPPromptParams',
	#superclass : 'ACPOptions',
	#instVars : [
		'sessionId',
		'prompt'
	],
	#category : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPPromptParams >> asDictionary [

	| dict |
	dict := Dictionary new.
	self sessionId ifNotNil: [ :v | dict at: 'sessionId' put: v ].
	self prompt ifNotNil: [ :v | dict at: 'prompt' put: v ].
	self extraPropertiesOn: dict.
	^ dict
]

{ #category : 'accessing' }
ACPPromptParams >> prompt [

	^ prompt
]

{ #category : 'accessing' }
ACPPromptParams >> prompt: anArray [

	prompt := anArray
]

{ #category : 'accessing' }
ACPPromptParams >> sessionId [

	^ sessionId
]

{ #category : 'accessing' }
ACPPromptParams >> sessionId: aString [

	sessionId := aString
]
