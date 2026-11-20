"
I represent the prompt content types an ACP v2 agent accepts beyond the baseline (session.prompt).

Responsibility:
- Baseline text and resource_link blocks are always accepted; I record the opt-in types: image, audio, embeddedContext (resource blocks)
- A type counts as supported only when its entry is present and non-null; {} means supported

Collaborators:
- ACP2SessionCapabilities: holds me under 'prompt'
- ACP2Values: my superclass

Public API:
- isImageSupported / isAudioSupported / isEmbeddedContextSupported - whether a type is advertised
- enableImage / enableAudio / enableEmbeddedContext - advertise a type
- image / audio / embeddedContext - raw capability dictionaries, or nil
"
Class {
	#name : 'ACP2PromptCapabilities',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2PromptCapabilities >> audio [

	^ self rawValues at: 'audio' ifAbsent: []
]

{ #category : 'accessing' }
ACP2PromptCapabilities >> embeddedContext [

	^ self rawValues at: 'embeddedContext' ifAbsent: []
]

{ #category : 'actions' }
ACP2PromptCapabilities >> enableAudio [

	self rawValues at: 'audio' put: Dictionary new
]

{ #category : 'actions' }
ACP2PromptCapabilities >> enableEmbeddedContext [

	self rawValues at: 'embeddedContext' put: Dictionary new
]

{ #category : 'actions' }
ACP2PromptCapabilities >> enableImage [

	self rawValues at: 'image' put: Dictionary new
]

{ #category : 'accessing' }
ACP2PromptCapabilities >> image [

	^ self rawValues at: 'image' ifAbsent: []
]

{ #category : 'testing' }
ACP2PromptCapabilities >> isAudioSupported [

	^ self audio notNil
]

{ #category : 'testing' }
ACP2PromptCapabilities >> isEmbeddedContextSupported [

	^ self embeddedContext notNil
]

{ #category : 'testing' }
ACP2PromptCapabilities >> isImageSupported [

	^ self image notNil
]
