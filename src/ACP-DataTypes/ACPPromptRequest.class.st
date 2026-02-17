Class {
	#name : 'ACPPromptRequest',
	#superclass : 'ACPOptions',
	#instVars : [
		'sessionId',
		'prompt'
	],
	#category : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPPromptRequest >> asDictionary [

	| dict |
	dict := Dictionary new.
	self sessionId ifNotNil: [ :v | dict at: 'sessionId' put: v ].
	self prompt ifNotNil: [ :v | dict at: 'prompt' put: v ].
	self extraPropertiesOn: dict.
	^ dict
]

{ #category : 'accessing' }
ACPPromptRequest >> prompt [

	^ prompt
]

{ #category : 'accessing' }
ACPPromptRequest >> prompt: anArray [

	prompt := anArray
]

{ #category : 'accessing' }
ACPPromptRequest >> sessionId [

	^ sessionId
]

{ #category : 'accessing' }
ACPPromptRequest >> sessionId: aString [

	sessionId := aString
]
