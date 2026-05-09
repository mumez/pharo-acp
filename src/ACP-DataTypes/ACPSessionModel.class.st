Class {
	#name : 'ACPSessionModel',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPSessionModel >> id [

	^ self rawValues
		  at: 'id'
		  ifAbsent: [ self rawValues at: 'modelId' ifAbsent: [] ]
]

{ #category : 'accessing' }
ACPSessionModel >> modelId [

	^ self id
]

{ #category : 'accessing' }
ACPSessionModel >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACPSessionModel >> description [

	^ self rawValues at: 'description' ifAbsent: []
]
