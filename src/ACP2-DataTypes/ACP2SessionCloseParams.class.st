Class {
	#name : 'ACP2SessionCloseParams',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2SessionCloseParams >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionCloseParams >> sessionId: aString [

	self rawValues at: 'sessionId' put: aString
]
