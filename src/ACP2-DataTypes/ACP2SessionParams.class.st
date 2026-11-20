Class {
	#name : 'ACP2SessionParams',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2SessionParams >> cwd [

	^ self rawValues at: 'cwd' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionParams >> cwd: aString [

	self rawValues at: 'cwd' put: aString
]

{ #category : 'accessing' }
ACP2SessionParams >> additionalDirectories [

	^ self rawValues at: 'additionalDirectories' ifAbsent: [ #() ]
]

{ #category : 'accessing' }
ACP2SessionParams >> additionalDirectories: anArray [

	self rawValues at: 'additionalDirectories' put: anArray
]

{ #category : 'accessing' }
ACP2SessionParams >> systemPrompt [
	"ACP2SystemPrompt, or nil. Send only when the agent advertises session.systemPrompt."

	^ self rawValues at: 'systemPrompt' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionParams >> systemPrompt: anACP2SystemPrompt [

	self rawValues at: 'systemPrompt' put: anACP2SystemPrompt
]

{ #category : 'instance creation' }
ACP2SessionParams class >> fromDictionary: aDictionary [

	| instance |
	instance := super fromDictionary: aDictionary.
	instance rawValues at: 'systemPrompt' ifPresent: [ :dict |
		dict ifNotNil: [
			instance systemPrompt: (ACP2SystemPrompt fromDictionary: dict) ] ].
	^ instance
]

{ #category : 'converting' }
ACP2SessionParams >> asDictionary [

	| dict |
	dict := super asDictionary.
	self trimNested: self systemPrompt named: 'systemPrompt' in: dict.
	^ dict
]
