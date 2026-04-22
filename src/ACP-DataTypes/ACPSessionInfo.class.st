Class {
	#name : 'ACPSessionInfo',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPSessionInfo >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACPSessionInfo >> cwd [

	^ self rawValues at: 'cwd' ifAbsent: []
]

{ #category : 'accessing' }
ACPSessionInfo >> title [

	^ self rawValues at: 'title' ifAbsent: []
]

{ #category : 'accessing' }
ACPSessionInfo >> updatedAt [

	^ self rawValues at: 'updatedAt' ifAbsent: []
]

{ #category : 'accessing' }
ACPSessionInfo >> additionalDirectories [

	^ self rawValues at: 'additionalDirectories' ifAbsent: [ #() ]
]
