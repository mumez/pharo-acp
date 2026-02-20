Class {
	#name : 'ACPSetSessionModeParams',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPSetSessionModeParams >> modeId [

	^ self rawValues at: 'modeId' ifAbsent: []
]

{ #category : 'accessing' }
ACPSetSessionModeParams >> modeId: aString [

	self rawValues at: 'modeId' put: aString
]

{ #category : 'accessing' }
ACPSetSessionModeParams >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACPSetSessionModeParams >> sessionId: aString [

	self rawValues at: 'sessionId' put: aString
]
