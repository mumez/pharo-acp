Class {
	#name : 'ACPNewSessionResponse',
	#superclass : 'ACPSessionSetupResponse',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPNewSessionResponse >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]
