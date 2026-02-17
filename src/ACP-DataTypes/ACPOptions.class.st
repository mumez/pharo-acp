Class {
	#name : 'ACPOptions',
	#superclass : 'Object',
	#instVars : [
		'extraProperties'
	],
	#category : 'ACP-DataTypes'
}

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

	^ aDictionary addAll: self extraProperties; yourself
]

