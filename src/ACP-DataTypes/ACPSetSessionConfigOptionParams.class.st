Class {
	#name : 'ACPSetSessionConfigOptionParams',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPSetSessionConfigOptionParams >> configId [

	^ self rawValues at: 'configId' ifAbsent: []
]

{ #category : 'accessing' }
ACPSetSessionConfigOptionParams >> configId: aString [

	self rawValues at: 'configId' put: aString
]

{ #category : 'accessing' }
ACPSetSessionConfigOptionParams >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACPSetSessionConfigOptionParams >> sessionId: aString [

	self rawValues at: 'sessionId' put: aString
]

{ #category : 'accessing' }
ACPSetSessionConfigOptionParams >> value [

	^ self rawValues at: 'value' ifAbsent: []
]

{ #category : 'accessing' }
ACPSetSessionConfigOptionParams >> value: aString [

	self rawValues at: 'value' put: aString
]
