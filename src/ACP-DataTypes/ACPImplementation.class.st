Class {
	#name : 'ACPImplementation',
	#superclass : 'ACPParams',
	#instVars : [
		'name',
		'version',
		'title'
	],
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'instance creation' }
ACPImplementation class >> fromDictionary: aDictionary [

	^ self new
		  name: (aDictionary at: 'name' ifAbsent: []);
		  version: (aDictionary at: 'version' ifAbsent: []);
		  title: (aDictionary at: 'title' ifAbsent: []);
		  yourself
]

{ #category : 'converting' }
ACPImplementation >> asDictionary [

	| dict |
	dict := Dictionary new.
	self name ifNotNil: [ :v | dict at: 'name' put: v ].
	self version ifNotNil: [ :v | dict at: 'version' put: v ].
	self title ifNotNil: [ :v | dict at: 'title' put: v ].
	self extraPropertiesOn: dict.
	^ dict
]

{ #category : 'accessing' }
ACPImplementation >> name [

	^ name
]

{ #category : 'accessing' }
ACPImplementation >> name: aString [

	name := aString
]

{ #category : 'accessing' }
ACPImplementation >> title [

	^ title
]

{ #category : 'accessing' }
ACPImplementation >> title: aString [

	title := aString
]

{ #category : 'accessing' }
ACPImplementation >> version [

	^ version
]

{ #category : 'accessing' }
ACPImplementation >> version: aString [

	version := aString
]
