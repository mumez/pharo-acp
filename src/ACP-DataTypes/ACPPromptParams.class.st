Class {
	#name : 'ACPPromptParams',
	#superclass : 'ACPValues',
	#instVars : [
		'sessionId',
		'prompt'
	],
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
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

	^ prompt ifNil: [ prompt := #() ]
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

{ #category : 'factory' }
ACPPromptParams >> contentBlockClass [
	^ ACPContentBlock
]

{ #category : 'builder' }
ACPPromptParams >> textPrompt: aString [
	^ self textPrompt: aString setting: [ :cb | ]
]

{ #category : 'builder' }
ACPPromptParams >> textPrompt: aString setting: aBlock [
	| contBlock |
	contBlock := self contentBlockClass text: aString.
	aBlock value: contBlock.
	self prompt: (self prompt , { contBlock asDictionary }).
]