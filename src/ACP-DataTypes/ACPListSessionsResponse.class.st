Class {
	#name : 'ACPListSessionsResponse',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'instance creation' }
ACPListSessionsResponse class >> fromDictionary: aDictionary [

	| instance rawCopy sessions |
	rawCopy := aDictionary copy.
	sessions := aDictionary at: 'sessions' ifAbsent: [ #() ].
	rawCopy
		at: 'sessions'
		put: (sessions collect: [ :each |
			each isDictionary
				ifTrue: [ ACPSessionInfo fromDictionary: each ]
				ifFalse: [ each ] ]).
	^ self new rawValues: rawCopy
]

{ #category : 'accessing' }
ACPListSessionsResponse >> sessions [

	^ self rawValues at: 'sessions' ifAbsent: [ #() ]
]

{ #category : 'accessing' }
ACPListSessionsResponse >> nextCursor [

	^ self rawValues at: 'nextCursor' ifAbsent: []
]

{ #category : 'testing' }
ACPListSessionsResponse >> hasNextPage [

	^ self nextCursor isNil not
]
