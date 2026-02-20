Class {
	#name : 'ACPNewSessionResponse',
	#superclass : 'ACPBaseSessionResponse',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPNewSessionResponse >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]
