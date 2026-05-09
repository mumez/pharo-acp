Class {
	#name : 'ACPSessionMode',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPSessionMode >> id [

	^ self rawValues
		  at: 'id'
		  ifAbsent: [ self rawValues at: 'modeId' ifAbsent: [] ]
]

{ #category : 'accessing' }
ACPSessionMode >> modeId [

	^ self id
]

{ #category : 'accessing' }
ACPSessionMode >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACPSessionMode >> description [

	^ self rawValues at: 'description' ifAbsent: []
]
