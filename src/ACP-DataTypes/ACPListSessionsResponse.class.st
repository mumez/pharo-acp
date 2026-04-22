Class {
	#name : 'ACPListSessionsResponse',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPListSessionsResponse >> sessions [

	^ (self rawValues at: 'sessions' ifAbsent: [ #() ]) collect: [ :each |
		each isDictionary
			ifTrue: [ ACPSessionInfo fromDictionary: each ]
			ifFalse: [ each ] ]
]

{ #category : 'accessing' }
ACPListSessionsResponse >> nextCursor [

	^ self rawValues at: 'nextCursor' ifAbsent: []
]

{ #category : 'testing' }
ACPListSessionsResponse >> hasNextPage [

	^ self nextCursor isNil not
]
