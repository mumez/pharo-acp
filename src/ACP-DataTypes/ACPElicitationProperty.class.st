"
I represent one form field in an elicitation schema. One class covers every property type; the type predicates tell them apart.

Responsibility:
- I decode the field's type, texts, default value, and type-specific constraints
- I normalize the three ways of declaring choices (enum, oneOf, items.enum / items.anyOf) into #choices

Collaborators:
- ACPElicitationSchema: creates me for each entry of 'properties'
- ACPElicitationEnumOption: one per choice
- ACPValues: my superclass

Public API:
- type - 'string', 'number', 'integer', 'boolean', 'array', or a custom/future value
- isString / isNumber / isInteger / isBoolean / isMultiSelect / isSingleSelect - type predicates
  (a single select is a string with enum or oneOf; a multi select is an array)
- title / description / default - common fields (default may be nil)
- minLength / maxLength / pattern / format - string constraints (format: email, uri, date, date-time)
- minimum / maximum - number and integer bounds (inclusive)
- minItems / maxItems - multi-select bounds
- choices - Array of ACPElicitationEnumOption for single and multi selects, otherwise empty
  (when both a titled list and 'enum' are given, the titled list takes precedence)

Implementation Points:
- Clients SHOULD pre-populate fields with #default
"
Class {
	#name : 'ACPElicitationProperty',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPElicitationProperty >> choices [

	| source |
	source := self isMultiSelect
		          ifTrue: [ (self rawValues at: 'items' ifAbsent: [ nil ]) ifNil: [ Dictionary new ] ]
		          ifFalse: [ self rawValues ].
	^ self choicesFrom: source
]

{ #category : 'private' }
ACPElicitationProperty >> choicesFrom: aDictionary [
	"Titled options are in 'oneOf' (single select) or 'anyOf' (multi-select items); untitled ones in 'enum'.
	 The schema defines these as alternatives; if a property declares both, the titled list takes precedence."

	#( 'oneOf' 'anyOf' ) do: [ :key |
		(aDictionary at: key ifAbsent: [ nil ]) ifNotNil: [ :options |
			^ options collect: [ :each | ACPElicitationEnumOption fromDictionary: each ] ] ].
	^ ((aDictionary at: 'enum' ifAbsent: [ nil ]) ifNil: [ #() ]) collect: [ :each |
		  ACPElicitationEnumOption value: each ]
]

{ #category : 'accessing' }
ACPElicitationProperty >> default [

	^ self rawValues at: 'default' ifAbsent: []
]

{ #category : 'accessing' }
ACPElicitationProperty >> description [

	^ self rawValues at: 'description' ifAbsent: []
]

{ #category : 'accessing' }
ACPElicitationProperty >> format [

	^ self rawValues at: 'format' ifAbsent: []
]

{ #category : 'testing' }
ACPElicitationProperty >> isBoolean [

	^ self type = 'boolean'
]

{ #category : 'testing' }
ACPElicitationProperty >> isInteger [

	^ self type = 'integer'
]

{ #category : 'testing' }
ACPElicitationProperty >> isMultiSelect [

	^ self type = 'array'
]

{ #category : 'testing' }
ACPElicitationProperty >> isNumber [

	^ self type = 'number'
]

{ #category : 'testing' }
ACPElicitationProperty >> isSingleSelect [

	^ self isString and: [
		  (self rawValues at: 'enum' ifAbsent: [ nil ]) notNil or: [
			  (self rawValues at: 'oneOf' ifAbsent: [ nil ]) notNil ] ]
]

{ #category : 'testing' }
ACPElicitationProperty >> isString [

	^ self type = 'string'
]

{ #category : 'accessing' }
ACPElicitationProperty >> maxItems [

	^ self rawValues at: 'maxItems' ifAbsent: []
]

{ #category : 'accessing' }
ACPElicitationProperty >> maxLength [

	^ self rawValues at: 'maxLength' ifAbsent: []
]

{ #category : 'accessing' }
ACPElicitationProperty >> maximum [

	^ self rawValues at: 'maximum' ifAbsent: []
]

{ #category : 'accessing' }
ACPElicitationProperty >> minItems [

	^ self rawValues at: 'minItems' ifAbsent: []
]

{ #category : 'accessing' }
ACPElicitationProperty >> minLength [

	^ self rawValues at: 'minLength' ifAbsent: []
]

{ #category : 'accessing' }
ACPElicitationProperty >> minimum [

	^ self rawValues at: 'minimum' ifAbsent: []
]

{ #category : 'accessing' }
ACPElicitationProperty >> pattern [

	^ self rawValues at: 'pattern' ifAbsent: []
]

{ #category : 'accessing' }
ACPElicitationProperty >> title [

	^ self rawValues at: 'title' ifAbsent: []
]

{ #category : 'accessing' }
ACPElicitationProperty >> type [

	^ self rawValues at: 'type' ifAbsent: []
]
