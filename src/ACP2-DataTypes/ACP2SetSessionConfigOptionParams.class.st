Class {
	#name : 'ACP2SetSessionConfigOptionParams',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2SetSessionConfigOptionParams >> configId [

	^ self rawValues at: 'configId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SetSessionConfigOptionParams >> configId: aString [

	self rawValues at: 'configId' put: aString
]

{ #category : 'accessing' }
ACP2SetSessionConfigOptionParams >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SetSessionConfigOptionParams >> sessionId: aString [

	self rawValues at: 'sessionId' put: aString
]

{ #category : 'accessing' }
ACP2SetSessionConfigOptionParams >> value [

	^ self rawValues at: 'value' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SetSessionConfigOptionParams >> value: aString [

	self rawValues at: 'value' put: aString
]
