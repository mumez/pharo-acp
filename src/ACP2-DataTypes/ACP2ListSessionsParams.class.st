Class {
	#name : 'ACP2ListSessionsParams',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2ListSessionsParams >> cwd [

	^ self rawValues at: 'cwd' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ListSessionsParams >> cwd: aString [

	self rawValues at: 'cwd' put: aString
]

{ #category : 'accessing' }
ACP2ListSessionsParams >> cursor [

	^ self rawValues at: 'cursor' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ListSessionsParams >> cursor: aString [

	self rawValues at: 'cursor' put: aString
]

{ #category : 'accessing' }
ACP2ListSessionsParams >> additionalDirectories [

	^ self rawValues at: 'additionalDirectories' ifAbsent: [ #() ]
]

{ #category : 'accessing' }
ACP2ListSessionsParams >> additionalDirectories: anArray [

	self rawValues at: 'additionalDirectories' put: anArray
]
