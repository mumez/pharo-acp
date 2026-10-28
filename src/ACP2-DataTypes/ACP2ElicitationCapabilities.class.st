"
I represent the elicitation capabilities a client advertises in clientCapabilities.elicitation.

Responsibility:
- I record which elicitation modes (form, url) the client supports.
- A mode counts as supported only when its entry is present and non-null; #enableForm / #enableUrl set it to {}.

Collaborators:
- ACP2ClientCapabilities: holds me under 'elicitation'
- ACP2Values: my superclass

Public API:
- enableForm / enableUrl - advertise support for a mode
- isFormSupported / isUrlSupported - whether a mode is advertised
- form / url - raw capability dictionaries, or nil

Implementation Points:
- Advertise a mode only when the client's handler implements it; agents must not request unadvertised modes
"
Class {
	#name : 'ACP2ElicitationCapabilities',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'actions' }
ACP2ElicitationCapabilities >> enableForm [

	self rawValues at: 'form' put: Dictionary new
]

{ #category : 'actions' }
ACP2ElicitationCapabilities >> enableUrl [

	self rawValues at: 'url' put: Dictionary new
]

{ #category : 'accessing' }
ACP2ElicitationCapabilities >> form [

	^ self rawValues at: 'form' ifAbsent: []
]

{ #category : 'testing' }
ACP2ElicitationCapabilities >> isFormSupported [

	^ self form notNil
]

{ #category : 'testing' }
ACP2ElicitationCapabilities >> isUrlSupported [

	^ self url notNil
]

{ #category : 'accessing' }
ACP2ElicitationCapabilities >> url [

	^ self rawValues at: 'url' ifAbsent: []
]
