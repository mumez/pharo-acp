Class {
	#name : 'ACP2SessionModel',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2SessionModel >> modelId [

	^ self rawValues at: 'modelId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionModel >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionModel >> description [

	^ self rawValues at: 'description' ifAbsent: []
]
