"
I represent one choice of a single- or multi-select elicitation property.

Responsibility:
- I expose the choice's value (the schema's 'const') with a display title and optional description
- For untitled choices (declared with 'enum'), the title is the value itself

Collaborators:
- ACP2ElicitationProperty: creates me in #choices
- ACP2Values: my superclass

Public API:
- value: (class side) - an untitled choice
- value - the value to send back in the response content
- title - display text (the value when no title is given)
- description - optional description, or nil
"
Class {
	#name : 'ACP2ElicitationEnumOption',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'instance creation' }
ACP2ElicitationEnumOption class >> value: aString [

	^ self fromDictionary: { ('const' -> aString) } asDictionary
]

{ #category : 'accessing' }
ACP2ElicitationEnumOption >> description [

	^ self rawValues at: 'description' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ElicitationEnumOption >> title [

	^ self rawValues at: 'title' ifAbsent: [ self value ]
]

{ #category : 'accessing' }
ACP2ElicitationEnumOption >> value [

	^ self rawValues at: 'const' ifAbsent: []
]
