Class {
	#name : 'ACP2PromptParams',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2PromptParams >> prompt [

	^ self rawValues at: 'prompt' ifAbsentPut: [ #() ]
]

{ #category : 'accessing' }
ACP2PromptParams >> prompt: anArray [

	self rawValues at: 'prompt' put: anArray
]

{ #category : 'accessing' }
ACP2PromptParams >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2PromptParams >> sessionId: aString [

	self rawValues at: 'sessionId' put: aString
]

{ #category : 'factory' }
ACP2PromptParams >> contentBlockClass [
	^ ACP2ContentBlock
]

{ #category : 'builder' }
ACP2PromptParams >> audioPrompt: aBase64String mimeType: aMimeType [
	^ self audioPrompt: aBase64String mimeType: aMimeType setting: [ :cb | ]
]

{ #category : 'builder' }
ACP2PromptParams >> audioPrompt: aBase64String mimeType: aMimeType setting: aBlock [
	| contBlock |
	contBlock := self contentBlockClass audio: aBase64String mimeType: aMimeType.
	aBlock value: contBlock.
	self prompt: (self prompt , { contBlock asDictionary })
]

{ #category : 'builder' }
ACP2PromptParams >> imagePrompt: aBase64String mimeType: aMimeType [
	^ self imagePrompt: aBase64String mimeType: aMimeType setting: [ :cb | ]
]

{ #category : 'builder' }
ACP2PromptParams >> imagePrompt: aBase64String mimeType: aMimeType setting: aBlock [
	| contBlock |
	contBlock := self contentBlockClass image: aBase64String mimeType: aMimeType.
	aBlock value: contBlock.
	self prompt: (self prompt , { contBlock asDictionary })
]

{ #category : 'builder' }
ACP2PromptParams >> resourcePrompt: aUri blob: aContent [
	^ self resourcePrompt: aUri blob: aContent mimeType: nil
]

{ #category : 'builder' }
ACP2PromptParams >> resourcePrompt: aUri blob: aContent mimeType: aMimeType [
	^ self resourcePrompt: aUri blob: aContent mimeType: aMimeType setting: [ :cb | ]
]

{ #category : 'builder' }
ACP2PromptParams >> resourcePrompt: aUri blob: aContent mimeType: aMimeType setting: aBlock [
	| contBlock |
	contBlock := self contentBlockClass resource: aUri blob: aContent mimeType: aMimeType.
	aBlock value: contBlock.
	self prompt: (self prompt , { contBlock asDictionary })
]

{ #category : 'builder' }
ACP2PromptParams >> resourcePrompt: aUri text: aContent [
	^ self resourcePrompt: aUri text: aContent mimeType: nil
]

{ #category : 'builder' }
ACP2PromptParams >> resourcePrompt: aUri text: aContent mimeType: aMimeType [
	^ self resourcePrompt: aUri text: aContent mimeType: aMimeType setting: [ :cb | ]
]

{ #category : 'builder' }
ACP2PromptParams >> resourcePrompt: aUri text: aContent mimeType: aMimeType setting: aBlock [
	| contBlock |
	contBlock := self contentBlockClass resource: aUri text: aContent mimeType: aMimeType.
	aBlock value: contBlock.
	self prompt: (self prompt , { contBlock asDictionary })
]

{ #category : 'builder' }
ACP2PromptParams >> resourceLinkPrompt: aUri name: aName [
	^ self resourceLinkPrompt: aUri name: aName setting: [ :cb | ]
]

{ #category : 'builder' }
ACP2PromptParams >> resourceLinkPrompt: aUri name: aName setting: aBlock [
	| contBlock |
	contBlock := self contentBlockClass resourceLink: aUri name: aName.
	aBlock value: contBlock.
	self prompt: (self prompt , { contBlock asDictionary })
]

{ #category : 'builder' }
ACP2PromptParams >> textPrompt: aString [
	^ self textPrompt: aString setting: [ :cb | ]
]

{ #category : 'builder' }
ACP2PromptParams >> textPrompt: aString setting: aBlock [
	| contBlock |
	contBlock := self contentBlockClass text: aString.
	aBlock value: contBlock.
	self prompt: (self prompt , { contBlock asDictionary })
]