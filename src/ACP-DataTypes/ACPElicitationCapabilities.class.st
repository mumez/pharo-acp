"
I represent the elicitation capabilities a client advertises in clientCapabilities.elicitation.

Responsibility:
- I record which elicitation modes (form, url) the client supports.
- A mode counts as supported only when its entry is present and non-null; #enableForm / #enableUrl set it to {}.

Collaborators:
- ACPClientCapabilities: holds me under 'elicitation'
- ACPValues: my superclass

Public API:
- enableForm / enableUrl - advertise support for a mode
- isFormSupported / isUrlSupported - whether a mode is advertised
- form / url - raw capability dictionaries, or nil

Implementation Points:
- Advertise a mode only when the client's handler implements it; agents must not request unadvertised modes
"
Class {
	#name : 'ACPElicitationCapabilities',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'actions' }
ACPElicitationCapabilities >> enableForm [

	self rawValues at: 'form' put: Dictionary new
]

{ #category : 'actions' }
ACPElicitationCapabilities >> enableUrl [

	self rawValues at: 'url' put: Dictionary new
]

{ #category : 'accessing' }
ACPElicitationCapabilities >> form [

	^ self rawValues at: 'form' ifAbsent: []
]

{ #category : 'testing' }
ACPElicitationCapabilities >> isFormSupported [

	^ self form notNil
]

{ #category : 'testing' }
ACPElicitationCapabilities >> isUrlSupported [

	^ self url notNil
]

{ #category : 'accessing' }
ACPElicitationCapabilities >> url [

	^ self rawValues at: 'url' ifAbsent: []
]
