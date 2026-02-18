Class {
	#name : 'ACPOptions',
	#superclass : 'Object',
	#instVars : [
		'extraProperties'
	],
	#category : 'ACP-DataTypes'
}

{ #category : 'instance creation' }
ACPOptions class >> buildBy: aBlock [

	| instance |
	instance := self new.
	aBlock value: instance.
	^ instance
]

{ #category : 'converting' }
ACPOptions >> asDictionary [

	^ self extraPropertiesOn: Dictionary new
]

{ #category : 'accessing' }
ACPOptions >> extraProperties [

	^ extraProperties ifNil: [ extraProperties := Dictionary new ]
]

{ #category : 'accessing' }
ACPOptions >> extraProperties: aDictionary [

	extraProperties := aDictionary
]

{ #category : 'converting' }
ACPOptions >> extraPropertiesOn: aDictionary [

	aDictionary at: '_meta' put: self extraProperties
]

