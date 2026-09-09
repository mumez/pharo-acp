Class {
	#name : 'ACP2SessionInfo',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2SessionInfo >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionInfo >> cwd [

	^ self rawValues at: 'cwd' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionInfo >> title [

	^ self rawValues at: 'title' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionInfo >> updatedAt [

	^ self rawValues at: 'updatedAt' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionInfo >> additionalDirectories [

	^ self rawValues at: 'additionalDirectories' ifAbsent: [ #() ]
]
