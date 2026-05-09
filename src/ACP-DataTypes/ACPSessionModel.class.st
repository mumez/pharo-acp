Class {
	#name : 'ACPSessionModel',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPSessionModel >> modelId [

	^ self rawValues at: 'modelId' ifAbsent: []
]

{ #category : 'accessing' }
ACPSessionModel >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACPSessionModel >> description [

	^ self rawValues at: 'description' ifAbsent: []
]
