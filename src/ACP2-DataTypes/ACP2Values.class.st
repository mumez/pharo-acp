"
I am the unified base class for all ACP data transfer objects.

## Storage

rawValues holds all typed field values. extraProperties holds optional '_meta' extension data.
asDictionary base implementation does Dictionary newFrom: rawValues, so subclasses must override
to convert any nested ACP2Values objects stored in rawValues to plain dictionaries.

## Nested object pattern

Nested ACP2Values fields follow one of two patterns:

- Lazily created (objects the client builds and sends, e.g. client capabilities): the getter uses
  ifAbsentPut:, enabling fluent access like `params capabilities elicitation enableForm` without
  explicit construction. On serialization, trimNested:named:in: omits any nested object whose
  isEmpty returns true, keeping the wire format clean when sub-objects were never populated.
- Presence-based (v2 agent capabilities): an empty object ({}) means 'supported' and nil/absent
  means 'not supported'. These fields are not lazily created; fromDictionary: decodes them with
  decode:as:, and they are serialized with includeNested:named:in:, which keeps empty objects
  and omits only nil.

## Subclass responsibilities

- fromDictionary: - override to decode nested dict entries into typed ACP2Values objects
- asDictionary - override to call trimNested:named:in: for each nested field
- ensureRequired - override to populate mandatory fields before serialization

## Public API

- fromDictionary: - class-side constructor from a parsed JSON dictionary
- buildBy: - class-side constructor with a configuration block
- asDictionary - serialize to a plain Dictionary suitable for JSON encoding
- isEmpty - true when rawValues and extraProperties are both empty
- advertisesCapability: - whether the capabilities field advertises a named capability (used by isCancellable)
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

{ #category : 'testing' }
ACP2Values >> advertisesCapability: capabilityName [
	"Answer whether the capabilities field (a v2 presence-based object) advertises capabilityName.
	Absent, null, or malformed capabilities advertise nothing."

	| capabilities |
	capabilities := self rawValues at: 'capabilities' ifAbsent: [ nil ].
	capabilities isDictionary ifFalse: [ ^ false ].
	^ (capabilities at: capabilityName ifAbsent: [ nil ]) notNil
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
ACP2Values >> decode: propName as: valueClass [
	"Replace the raw dictionary at propName with an instance of valueClass; drop an explicit null.
	Leave the field absent when it is absent (presence-based fields are not lazily created)."

	self rawValues at: propName ifPresent: [ :raw |
		raw
			ifNil: [ self rawValues removeKey: propName ]
			ifNotNil: [ self rawValues at: propName put: (valueClass fromDictionary: raw) ] ]
]

{ #category : 'private' }
ACP2Values >> includeNested: nestedValues named: propName in: aDictionary [
	"For v2 presence-based capabilities, where an empty object ({}) still means 'supported':
	omit the field only when it is nil, otherwise serialize it even if empty."

	nestedValues
		ifNil: [ aDictionary removeKey: propName ifAbsent: [  ] ]
		ifNotNil: [ aDictionary at: propName put: nestedValues asDictionary ]
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
