Class {
	#name : 'ACPNewSessionResponse',
	#superclass : 'ACPBaseSessionResponse',
	#category : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPNewSessionResponse >> sessionId [

	^ self rawDictionary at: 'sessionId' ifAbsent: []
]
