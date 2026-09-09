Class {
	#name : 'ACP2SetSessionModeParams',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2SetSessionModeParams >> modeId [

	^ self rawValues at: 'modeId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SetSessionModeParams >> modeId: aString [

	self rawValues at: 'modeId' put: aString
]

{ #category : 'accessing' }
ACP2SetSessionModeParams >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SetSessionModeParams >> sessionId: aString [

	self rawValues at: 'sessionId' put: aString
]
