Class {
	#name : 'ACPParams',
	#superclass : 'Object',
	#instVars : [
		'extraProperties'
	],
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'instance creation' }
ACPParams class >> buildBy: aBlock [

	| instance |
	instance := self new.
	aBlock value: instance.
	^ instance
]

{ #category : 'converting' }
ACPParams >> asDictionary [

	^ self extraPropertiesOn: Dictionary new
]

{ #category : 'accessing' }
ACPParams >> extraProperties [

	^ extraProperties ifNil: [ extraProperties := Dictionary new ]
]

{ #category : 'accessing' }
ACPParams >> extraProperties: aDictionary [

	extraProperties := aDictionary
]

{ #category : 'converting' }
ACPParams >> extraPropertiesOn: aDictionary [

	self extraProperties ifNotEmpty: [:props |
		aDictionary at: '_meta' put: props.
	]
]
