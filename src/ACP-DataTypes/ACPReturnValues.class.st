Class {
	#name : 'ACPReturnValues',
	#superclass : 'Object',
	#instVars : [
		'rawValues'
	],
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'instance creation' }
ACPReturnValues class >> fromDictionary: aDictionary [

	^ self new
		  rawValues: aDictionary;
		  yourself
]

{ #category : 'accessing' }
ACPReturnValues >> rawValues [

	^ rawValues
]

{ #category : 'accessing' }
ACPReturnValues >> rawValues: aDictionary [

	rawValues := aDictionary
]
