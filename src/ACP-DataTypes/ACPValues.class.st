"
I am the unified base class for all ACP data transfer objects.

rawValues is used for holding regular values, while extraProperties is used for holding extended metadata.
Subclasses may add instance variables for holding values, but in such cases, asDictionary and fromDictionary: must be overridden appropriately.

Public API:
- fromDictionary: - class-side constructor for result-style use
- buildBy: - class-side constructor with configuration block
- asDictionary - base serialization; subclasses override
- extraPropertiesOn: - merges extraProperties under '_meta' key
- rawValues / rawValues: - basic values holder
- extraProperties / extraProperties: - lazy-initialized _meta extension dict
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
