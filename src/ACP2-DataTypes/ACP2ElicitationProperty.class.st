"
I represent one form field in an elicitation schema. One class covers every property type; the type predicates tell them apart.

Responsibility:
- I decode the field's type, texts, default value, and type-specific constraints
- I normalize the three ways of declaring choices (enum, oneOf, items.enum / items.anyOf) into #choices

Collaborators:
- ACP2ElicitationSchema: creates me for each entry of 'properties'
- ACP2ElicitationEnumOption: one per choice
- ACP2Values: my superclass

Public API:
- type - 'string', 'number', 'integer', 'boolean', 'array', or a custom/future value
- isString / isNumber / isInteger / isBoolean / isMultiSelect / isSingleSelect - type predicates
  (a single select is a string with enum or oneOf; a multi select is an array)
- title / description / default - common fields (default may be nil)
- minLength / maxLength / pattern / format - string constraints (format: email, uri, date, date-time)
- minimum / maximum - number and integer bounds (inclusive)
- minItems / maxItems - multi-select bounds
- choices - Array of ACP2ElicitationEnumOption for single and multi selects, otherwise empty
  (when both a titled list and 'enum' are given, the titled list takes precedence)

Implementation Points:
- Clients SHOULD pre-populate fields with #default
"
Class {
	#name : 'ACP2ElicitationProperty',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2ElicitationProperty >> choices [

	| source |
	source := self isMultiSelect
		          ifTrue: [ (self rawValues at: 'items' ifAbsent: [ nil ]) ifNil: [ Dictionary new ] ]
		          ifFalse: [ self rawValues ].
	^ self choicesFrom: source
]

{ #category : 'private' }
ACP2ElicitationProperty >> choicesFrom: aDictionary [
	"Titled options are in 'oneOf' (single select) or 'anyOf' (multi-select items); untitled ones in 'enum'.
	 The schema defines these as alternatives; if a property declares both, the titled list takes precedence."

	#( 'oneOf' 'anyOf' ) do: [ :key |
		(aDictionary at: key ifAbsent: [ nil ]) ifNotNil: [ :options |
			^ options collect: [ :each | ACP2ElicitationEnumOption fromDictionary: each ] ] ].
	^ ((aDictionary at: 'enum' ifAbsent: [ nil ]) ifNil: [ #() ]) collect: [ :each |
		  ACP2ElicitationEnumOption value: each ]
]

{ #category : 'accessing' }
ACP2ElicitationProperty >> default [

	^ self rawValues at: 'default' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ElicitationProperty >> description [

	^ self rawValues at: 'description' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ElicitationProperty >> format [

	^ self rawValues at: 'format' ifAbsent: []
]

{ #category : 'testing' }
ACP2ElicitationProperty >> isBoolean [

	^ self type = 'boolean'
]

{ #category : 'testing' }
ACP2ElicitationProperty >> isInteger [

	^ self type = 'integer'
]

{ #category : 'testing' }
ACP2ElicitationProperty >> isMultiSelect [

	^ self type = 'array'
]

{ #category : 'testing' }
ACP2ElicitationProperty >> isNumber [

	^ self type = 'number'
]

{ #category : 'testing' }
ACP2ElicitationProperty >> isSingleSelect [

	^ self isString and: [
		  (self rawValues at: 'enum' ifAbsent: [ nil ]) notNil or: [
			  (self rawValues at: 'oneOf' ifAbsent: [ nil ]) notNil ] ]
]

{ #category : 'testing' }
ACP2ElicitationProperty >> isString [

	^ self type = 'string'
]

{ #category : 'accessing' }
ACP2ElicitationProperty >> maxItems [

	^ self rawValues at: 'maxItems' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ElicitationProperty >> maxLength [

	^ self rawValues at: 'maxLength' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ElicitationProperty >> maximum [

	^ self rawValues at: 'maximum' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ElicitationProperty >> minItems [

	^ self rawValues at: 'minItems' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ElicitationProperty >> minLength [

	^ self rawValues at: 'minLength' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ElicitationProperty >> minimum [

	^ self rawValues at: 'minimum' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ElicitationProperty >> pattern [

	^ self rawValues at: 'pattern' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ElicitationProperty >> title [

	^ self rawValues at: 'title' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ElicitationProperty >> type [

	^ self rawValues at: 'type' ifAbsent: []
]
