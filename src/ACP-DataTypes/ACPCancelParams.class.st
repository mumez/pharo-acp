Class {
	#name : 'ACPCancelParams',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPCancelParams >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACPCancelParams >> sessionId: aString [

	self rawValues at: 'sessionId' put: aString
]
