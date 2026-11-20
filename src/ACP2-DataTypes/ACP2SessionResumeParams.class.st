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

{ #category : 'accessing' }
ACP2SessionResumeParams >> systemPrompt [
	"ACP2SystemPrompt, or nil. Send only when the agent advertises session.systemPrompt."

	^ self rawValues at: 'systemPrompt' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionResumeParams >> systemPrompt: anACP2SystemPrompt [

	self rawValues at: 'systemPrompt' put: anACP2SystemPrompt
]

{ #category : 'instance creation' }
ACP2SessionResumeParams class >> fromDictionary: aDictionary [

	| instance |
	instance := super fromDictionary: aDictionary.
	instance rawValues at: 'systemPrompt' ifPresent: [ :dict |
		dict ifNotNil: [
			instance systemPrompt: (ACP2SystemPrompt fromDictionary: dict) ] ].
	^ instance
]

{ #category : 'converting' }
ACP2SessionResumeParams >> asDictionary [

	| dict |
	dict := super asDictionary.
	self trimNested: self systemPrompt named: 'systemPrompt' in: dict.
	^ dict
]
