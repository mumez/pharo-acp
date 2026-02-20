Class {
	#name : 'ACPSetSessionModelParams',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPSetSessionModelParams >> modelId [

	^ self rawValues at: 'modelId' ifAbsent: []
]

{ #category : 'accessing' }
ACPSetSessionModelParams >> modelId: aString [

	self rawValues at: 'modelId' put: aString
]

{ #category : 'accessing' }
ACPSetSessionModelParams >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACPSetSessionModelParams >> sessionId: aString [

	self rawValues at: 'sessionId' put: aString
]
