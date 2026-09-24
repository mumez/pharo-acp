"
I represent the requestedSchema of a form-mode elicitation: a flat JSON Schema object whose properties are form fields.

Responsibility:
- I decode the schema's title, description, properties, and required property names

Collaborators:
- ACPCreateElicitation: creates me from 'requestedSchema'
- ACPElicitationProperty: one per form field
- ACPValues: my superclass

Public API:
- title / description - optional schema texts, or nil
- properties - Dictionary of property name -> ACPElicitationProperty
- propertyNamed: - one property, or nil
- required / isRequired: - required property names
"
Class {
	#name : 'ACPElicitationSchema',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPElicitationSchema >> description [

	^ self rawValues at: 'description' ifAbsent: []
]

{ #category : 'testing' }
ACPElicitationSchema >> isRequired: aPropertyName [

	^ self required includes: aPropertyName
]

{ #category : 'accessing' }
ACPElicitationSchema >> properties [

	^ (self rawValues at: 'properties' ifAbsent: [ Dictionary new ]) collect: [ :each |
		  ACPElicitationProperty fromDictionary: each ]
]

{ #category : 'accessing' }
ACPElicitationSchema >> propertyNamed: aPropertyName [

	^ (self rawValues at: 'properties' ifAbsent: [ Dictionary new ])
		  at: aPropertyName
		  ifPresent: [ :dict | ACPElicitationProperty fromDictionary: dict ]
		  ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACPElicitationSchema >> required [

	^ (self rawValues at: 'required' ifAbsent: [ nil ]) ifNil: [ #() ]
]

{ #category : 'accessing' }
ACPElicitationSchema >> title [

	^ self rawValues at: 'title' ifAbsent: []
]
