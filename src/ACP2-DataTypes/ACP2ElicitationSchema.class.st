"
I represent the requestedSchema of a form-mode elicitation: a flat JSON Schema object whose properties are form fields.

Responsibility:
- I decode the schema's title, description, properties, and required property names

Collaborators:
- ACP2CreateElicitation: creates me from 'requestedSchema'
- ACP2ElicitationProperty: one per form field
- ACP2Values: my superclass

Public API:
- title / description - optional schema texts, or nil
- properties - Dictionary of property name -> ACP2ElicitationProperty
- propertyNamed: - one property, or nil
- required / isRequired: - required property names
"
Class {
	#name : 'ACP2ElicitationSchema',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2ElicitationSchema >> description [

	^ self rawValues at: 'description' ifAbsent: []
]

{ #category : 'testing' }
ACP2ElicitationSchema >> isRequired: aPropertyName [

	^ self required includes: aPropertyName
]

{ #category : 'accessing' }
ACP2ElicitationSchema >> properties [

	^ (self rawValues at: 'properties' ifAbsent: [ Dictionary new ]) collect: [ :each |
		  ACP2ElicitationProperty fromDictionary: each ]
]

{ #category : 'accessing' }
ACP2ElicitationSchema >> propertyNamed: aPropertyName [

	^ (self rawValues at: 'properties' ifAbsent: [ Dictionary new ])
		  at: aPropertyName
		  ifPresent: [ :dict | ACP2ElicitationProperty fromDictionary: dict ]
		  ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACP2ElicitationSchema >> required [

	^ (self rawValues at: 'required' ifAbsent: [ nil ]) ifNil: [ #() ]
]

{ #category : 'accessing' }
ACP2ElicitationSchema >> title [

	^ self rawValues at: 'title' ifAbsent: []
]
