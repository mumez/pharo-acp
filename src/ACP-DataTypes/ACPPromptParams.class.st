Class {
	#name : 'ACPPromptParams',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPPromptParams >> prompt [

	^ self rawValues at: 'prompt' ifAbsentPut: [ #() ]
]

{ #category : 'accessing' }
ACPPromptParams >> prompt: anArray [

	self rawValues at: 'prompt' put: anArray
]

{ #category : 'accessing' }
ACPPromptParams >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACPPromptParams >> sessionId: aString [

	self rawValues at: 'sessionId' put: aString
]

{ #category : 'factory' }
ACPPromptParams >> contentBlockClass [
	^ ACPContentBlock
]

{ #category : 'builder' }
ACPPromptParams >> audioPrompt: aBase64String mimeType: aMimeType [
	^ self audioPrompt: aBase64String mimeType: aMimeType setting: [ :cb | ]
]

{ #category : 'builder' }
ACPPromptParams >> audioPrompt: aBase64String mimeType: aMimeType setting: aBlock [
	| contBlock |
	contBlock := self contentBlockClass audio: aBase64String mimeType: aMimeType.
	aBlock value: contBlock.
	self prompt: (self prompt , { contBlock asDictionary })
]

{ #category : 'builder' }
ACPPromptParams >> imagePrompt: aBase64String mimeType: aMimeType [
	^ self imagePrompt: aBase64String mimeType: aMimeType setting: [ :cb | ]
]

{ #category : 'builder' }
ACPPromptParams >> imagePrompt: aBase64String mimeType: aMimeType setting: aBlock [
	| contBlock |
	contBlock := self contentBlockClass image: aBase64String mimeType: aMimeType.
	aBlock value: contBlock.
	self prompt: (self prompt , { contBlock asDictionary })
]

{ #category : 'builder' }
ACPPromptParams >> resourceLinkPrompt: aUri name: aName [
	^ self resourceLinkPrompt: aUri name: aName setting: [ :cb | ]
]

{ #category : 'builder' }
ACPPromptParams >> resourceLinkPrompt: aUri name: aName setting: aBlock [
	| contBlock |
	contBlock := self contentBlockClass resourceLink: aUri name: aName.
	aBlock value: contBlock.
	self prompt: (self prompt , { contBlock asDictionary })
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
	self prompt: (self prompt , { contBlock asDictionary })
]