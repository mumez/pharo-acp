Class {
	#name : 'ACP2CancelParams',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2CancelParams >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2CancelParams >> sessionId: aString [

	self rawValues at: 'sessionId' put: aString
]
