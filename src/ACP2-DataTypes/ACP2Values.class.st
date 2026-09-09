"
I am the unified base class for all ACP data transfer objects.

## Storage

rawValues holds all typed field values. extraProperties holds optional '_meta' extension data.
asDictionary base implementation does Dictionary newFrom: rawValues, so subclasses must override
to convert any nested ACP2Values objects stored in rawValues to plain dictionaries.

## Nested object pattern

Subclass getters for nested ACP2Values use ifAbsentPut: for lazy initialization, enabling fluent
access like `params capabilities fs: something` without explicit construction. On serialization,
trimNested:named:in: omits any nested object whose isEmpty returns true, keeping the wire format
clean when sub-objects were never populated.

## Subclass responsibilities

- fromDictionary: - override to decode nested dict entries into typed ACP2Values objects
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
	#name : 'ACP2Values',
	#superclass : 'Object',
	#instVars : [
		'rawValues',
		'extraProperties'
	],
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'instance creation' }
ACP2Values class >> buildBy: aBlock [

	| instance |
	instance := self new.
	aBlock value: instance.
	^ instance
]

{ #category : 'instance creation' }
ACP2Values class >> fromDictionary: aDictionary [

	^ self new
		  rawValues: aDictionary;
		  yourself
]

{ #category : 'converting' }
ACP2Values >> asDictionary [

	self ensureRequired.
	^ self extraPropertiesOn: (Dictionary newFrom: self rawValues).
]

{ #category : 'accessing' }
ACP2Values >> extraProperties [

	^ extraProperties ifNil: [ extraProperties := Dictionary new ]
]

{ #category : 'accessing' }
ACP2Values >> extraProperties: aDictionary [

	extraProperties := aDictionary
]

{ #category : 'accessing' }
ACP2Values >> rawValues [

	^ rawValues ifNil: [rawValues := Dictionary new]
]

{ #category : 'accessing' }
ACP2Values >> rawValues: aDictionary [

	rawValues := aDictionary
]

{ #category : 'converting' }
ACP2Values >> extraPropertiesOn: aDictionary [

	self extraProperties ifNotEmpty: [ :props |
		aDictionary at: '_meta' put: props ].
	^ aDictionary
]

{ #category : 'private' }
ACP2Values >> ensureRequired [

	"Subclasses can override to initialize required fields"

	^ self
]

{ #category : 'private' }
ACP2Values >> trimNested: nestedValues named: propName in: aDictionary [

	(nestedValues isNil or: [ nestedValues isEmpty ])
		ifTrue: [ aDictionary removeKey: propName ifAbsent: [] ]
		ifFalse: [ aDictionary at: propName put: nestedValues asDictionary ]
]

{ #category : 'private' }
ACP2Values >> valueAt: propName typed: valueClass in: aDictionary [

	^ aDictionary
		  at: propName
		  ifPresent: [ :dict | valueClass fromDictionary: dict ]
		  ifAbsentPut: [ valueClass new ]
]

{ #category : 'private' }
ACP2Values >> valuesAt: propName typed: valueClass in: aDictionary [

	^ aDictionary
		  at: propName
		  ifPresent: [ :rawPluralFieldValue |
			  self
				  dataTypeValuesFromRawArrayLikeValue: rawPluralFieldValue
				  for: valueClass ]
		  ifAbsentPut: [ #() ]
]

{ #category : 'private' }
ACP2Values >> dataTypeValuesFromRawArrayLikeValue: rawArrayLikeValue for: valueClass [

	| normalizedArrayLikeCollection |
	normalizedArrayLikeCollection := self
		                                 normalizedArrayLikeDataTypeSourceFrom: rawArrayLikeValue.
	^ (normalizedArrayLikeCollection select: [ :candidateEntry |
		   self isSupportedDataTypeEntry: candidateEntry for: valueClass ])
		  collect: [ :candidateEntry |
		  self dataTypeValueFrom: candidateEntry for: valueClass ]
]

{ #category : 'private' }
ACP2Values >> normalizedArrayLikeDataTypeSourceFrom: rawArrayLikeValue [
	"`valuesAt:` accessors represent array-like payload fields.
	Only sequenceable collections are accepted (e.g. Array/OrderedCollection).
	Dictionary, String, and other non-sequenceable values are treated as malformed
	input and normalized to an empty collection."

	((rawArrayLikeValue isKindOf: SequenceableCollection)
		 and: [ rawArrayLikeValue isString not ])
		ifFalse: [ ^ #() ].
	^ rawArrayLikeValue
]

{ #category : 'private' }
ACP2Values >> dataTypeValueFrom: dataTypeEntry for: valueClass [

	dataTypeEntry isDictionary ifTrue: [ ^ valueClass fromDictionary: dataTypeEntry ].
	^ dataTypeEntry
]

{ #category : 'private' }
ACP2Values >> isSupportedDataTypeEntry: dataTypeEntry for: valueClass [
	"Dictionary entries are valid payload elements and will be converted by
	`dataTypeValueFrom:for:`. This is distinct from rejecting Dictionary as the
	container itself in `normalizedArrayLikeDataTypeSourceFrom:`."

	^ dataTypeEntry isDictionary or: [ dataTypeEntry isKindOf: valueClass ]
]

{ #category : 'printing' }
ACP2Values >> printOn: aStream [

	aStream nextPutAll: self class name.
	aStream nextPut: $(.
	self rawValues printOn: aStream.
	aStream nextPut: $)
]

{ #category : 'testing' }
ACP2Values >> isEmpty [

	^ self rawValues isEmpty and: [ self extraProperties isEmpty ]
]
