"
I represent the requestedSchema of a form-mode elicitation: a flat JSON Schema object whose properties are form fields.

Responsibility:
- I decode the schema's type, title, description, properties, and required property names
- I tell whether I have the shape ACP v2 requires (type 'object' and a properties object)

Collaborators:
- ACP2CreateElicitation: creates me from 'requestedSchema'
- ACP2ElicitationProperty: one per form field
- ACP2Values: my superclass

Public API:
- type - the schema type; ACP v2 allows only 'object'
- isValid - true when type is 'object' and properties is present (both are required)
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
ACP2ElicitationSchema >> isValid [
	"ACP v2 requires type 'object' and a properties object; any other schema is rejected."

	^ self type = 'object' and: [
		  (self rawValues at: 'properties' ifAbsent: [ nil ]) isDictionary ]
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

{ #category : 'accessing' }
ACP2ElicitationSchema >> type [

	^ self rawValues at: 'type' ifAbsent: []
]
