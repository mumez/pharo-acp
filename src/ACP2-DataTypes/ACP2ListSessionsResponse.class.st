Class {
	#name : 'ACP2ListSessionsResponse',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2ListSessionsResponse >> sessions [

	^ (self rawValues at: 'sessions' ifAbsent: [ #() ]) collect: [ :each |
		each isDictionary
			ifTrue: [ ACP2SessionInfo fromDictionary: each ]
			ifFalse: [ each ] ]
]

{ #category : 'accessing' }
ACP2ListSessionsResponse >> nextCursor [

	^ self rawValues at: 'nextCursor' ifAbsent: []
]

{ #category : 'testing' }
ACP2ListSessionsResponse >> hasNextPage [

	^ self nextCursor isNil not
]
