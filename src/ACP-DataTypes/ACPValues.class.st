"
I am the unified base class for all ACP data transfer objects.

## Storage

rawValues holds all typed field values. extraProperties holds optional '_meta' extension data.
asDictionary base implementation does Dictionary newFrom: rawValues, so subclasses must override
to convert any nested ACPValues objects stored in rawValues to plain dictionaries.

## Nested object pattern

Subclass getters for nested ACPValues use ifAbsentPut: for lazy initialization, enabling fluent
access like `params capabilities fs: something` without explicit construction. On serialization,
trimNested:named:in: omits any nested object whose isEmpty returns true, keeping the wire format
clean when sub-objects were never populated.

## Subclass responsibilities

- fromDictionary: - override to decode nested dict entries into typed ACPValues objects
- asDictionary - override to call trimNested:named:in: for each nested field
- ensureRequired - override to populate mandatory fields before serialization

## Public API

- fromDictionary: - class-side constructor from a parsed JSON dictionary
- buildBy: - class-side constructor with a configuration block
- asDictionary - serialize to a plain Dictionary suitable for JSON encoding
- isEmpty - true when rawValues and extraProperties are both empty
- rawValues / rawValues: - direct access to the value store
- extraProperties / extraProperties: - lazy-initialized '_meta' extension dict
"
Class {
	#name : 'ACPValues',
	#superclass : 'Object',
	#instVars : [
		'rawValues',
		'extraProperties'
	],
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'instance creation' }
ACPValues class >> buildBy: aBlock [

	| instance |
	instance := self new.
	aBlock value: instance.
	^ instance
]

{ #category : 'instance creation' }
ACPValues class >> fromDictionary: aDictionary [

	^ self new
		  rawValues: aDictionary;
		  yourself
]

{ #category : 'converting' }
ACPValues >> asDictionary [

	self ensureRequired.
	^ self extraPropertiesOn: (Dictionary newFrom: self rawValues).
]

{ #category : 'accessing' }
ACPValues >> extraProperties [

	^ extraProperties ifNil: [ extraProperties := Dictionary new ]
]

{ #category : 'accessing' }
ACPValues >> extraProperties: aDictionary [

	extraProperties := aDictionary
]

{ #category : 'accessing' }
ACPValues >> rawValues [

	^ rawValues ifNil: [rawValues := Dictionary new]
]

{ #category : 'accessing' }
ACPValues >> rawValues: aDictionary [

	rawValues := aDictionary
]

{ #category : 'converting' }
ACPValues >> extraPropertiesOn: aDictionary [

	self extraProperties ifNotEmpty: [ :props |
		aDictionary at: '_meta' put: props ].
	^ aDictionary
]

{ #category : 'private' }
ACPValues >> ensureRequired [

	"Subclasses can override to initialize required fields"

	^ self
]

{ #category : 'private' }
ACPValues >> trimNested: nestedValues named: propName in: aDictionary [

	(nestedValues isNil or: [ nestedValues isEmpty ])
		ifTrue: [ aDictionary removeKey: propName ifAbsent: [] ]
		ifFalse: [ aDictionary at: propName put: nestedValues asDictionary ]
]

{ #category : 'private' }
ACPValues >> valueAt: propName typed: valueClass in: aDictionary [

	^ aDictionary
		  at: propName
		  ifPresent: [ :dict | valueClass fromDictionary: dict ]
		  ifAbsentPut: [ valueClass new ]
]

{ #category : 'private' }
ACPValues >> valuesAt: propName typed: valueClass in: aDictionary [

	^ aDictionary
		  at: propName
		  ifPresent: [ :coll | coll collect: [ :each | valueClass fromDictionary: each ] ]
		  ifAbsentPut: [ #() ]
]

{ #category : 'testing' }
ACPValues >> isEmpty [

	^ self rawValues isEmpty and: [ self extraProperties isEmpty ]
]
