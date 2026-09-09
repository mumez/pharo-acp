Class {
	#name : 'ACP2SetSessionModelParams',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2SetSessionModelParams >> modelId [

	^ self rawValues at: 'modelId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SetSessionModelParams >> modelId: aString [

	self rawValues at: 'modelId' put: aString
]

{ #category : 'accessing' }
ACP2SetSessionModelParams >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SetSessionModelParams >> sessionId: aString [

	self rawValues at: 'sessionId' put: aString
]
