Class {
	#name : 'ACPBaseSessionResponse',
	#superclass : 'ACPReturnValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPBaseSessionResponse >> configOptions [

	^ self rawValues at: 'configOptions' ifAbsent: []
]

{ #category : 'accessing' }
ACPBaseSessionResponse >> models [

	^ self rawValues at: 'models' ifAbsent: []
]

{ #category : 'accessing' }
ACPBaseSessionResponse >> modes [

	^ self rawValues at: 'modes' ifAbsent: []
]

{ #category : 'accessing' }
ACPBaseSessionResponse >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]
