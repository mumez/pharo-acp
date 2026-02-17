Class {
	#name : 'ACPResult',
	#superclass : 'Object',
	#instVars : [
		'rawDictionary'
	],
	#category : 'ACP-DataTypes'
}

{ #category : 'instance creation' }
ACPResult class >> fromDictionary: aDictionary [

	^ self new
		  rawDictionary: aDictionary;
		  yourself
]

{ #category : 'accessing' }
ACPResult >> rawDictionary [

	^ rawDictionary
]

{ #category : 'accessing' }
ACPResult >> rawDictionary: aDictionary [

	rawDictionary := aDictionary
]
