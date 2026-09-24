"
I represent one choice of a single- or multi-select elicitation property.

Responsibility:
- I expose the choice's value (the schema's 'const') with a display title and optional description
- For untitled choices (declared with 'enum'), the title is the value itself

Collaborators:
- ACPElicitationProperty: creates me in #choices
- ACPValues: my superclass

Public API:
- value: (class side) - an untitled choice
- value - the value to send back in the response content
- title - display text (the value when no title is given)
- description - optional description, or nil
"
Class {
	#name : 'ACPElicitationEnumOption',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'instance creation' }
ACPElicitationEnumOption class >> value: aString [

	^ self fromDictionary: { ('const' -> aString) } asDictionary
]

{ #category : 'accessing' }
ACPElicitationEnumOption >> description [

	^ self rawValues at: 'description' ifAbsent: []
]

{ #category : 'accessing' }
ACPElicitationEnumOption >> title [

	^ self rawValues at: 'title' ifAbsent: [ self value ]
]

{ #category : 'accessing' }
ACPElicitationEnumOption >> value [

	^ self rawValues at: 'const' ifAbsent: []
]
