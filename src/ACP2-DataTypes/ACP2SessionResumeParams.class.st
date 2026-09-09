Class {
	#name : 'ACP2SessionResumeParams',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2SessionResumeParams >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionResumeParams >> sessionId: aString [

	self rawValues at: 'sessionId' put: aString
]

{ #category : 'accessing' }
ACP2SessionResumeParams >> cwd [

	^ self rawValues at: 'cwd' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionResumeParams >> cwd: aString [

	self rawValues at: 'cwd' put: aString
]

{ #category : 'accessing' }
ACP2SessionResumeParams >> replayFrom [

	^ self rawValues at: 'replayFrom' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionResumeParams >> replayFrom: aDictionary [

	self rawValues at: 'replayFrom' put: aDictionary
]
