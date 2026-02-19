Class {
	#name : 'ACPBaseSessionResponse',
	#superclass : 'ACPResult',
	#category : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPBaseSessionResponse >> configOptions [

	^ self rawDictionary at: 'configOptions' ifAbsent: []
]

{ #category : 'accessing' }
ACPBaseSessionResponse >> models [

	^ self rawDictionary at: 'models' ifAbsent: []
]

{ #category : 'accessing' }
ACPBaseSessionResponse >> modes [

	^ self rawDictionary at: 'modes' ifAbsent: []
]

{ #category : 'accessing' }
ACPBaseSessionResponse >> sessionId [

	^ self rawDictionary at: 'sessionId' ifAbsent: []
]