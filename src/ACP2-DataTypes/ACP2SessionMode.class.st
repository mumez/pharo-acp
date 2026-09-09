Class {
	#name : 'ACP2SessionMode',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2SessionMode >> id [

	^ self rawValues at: 'id' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionMode >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionMode >> description [

	^ self rawValues at: 'description' ifAbsent: []
]
