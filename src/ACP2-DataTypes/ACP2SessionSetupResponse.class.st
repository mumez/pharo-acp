Class {
	#name : 'ACP2SessionSetupResponse',
	#superclass : 'ACP2BaseSessionResponse',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2SessionSetupResponse >> models [

	^ self availableModels
]

{ #category : 'accessing' }
ACP2SessionSetupResponse >> modes [

	^ self availableModes
]

{ #category : 'accessing' }
ACP2SessionSetupResponse >> availableModels [

	^ self
		  resolveListAt: 'models'
		  nestedKey: 'availableModels'
		  typed: ACP2SessionModel
]

{ #category : 'accessing' }
ACP2SessionSetupResponse >> availableModes [

	^ self
		  resolveListAt: 'modes'
		  nestedKey: 'availableModes'
		  typed: ACP2SessionMode
]

{ #category : 'private' }
ACP2SessionSetupResponse >> resolveListAt: fieldKey nestedKey: nestedKey typed: valueClass [
	"Supports both flat list (fieldKey: [...]) and state-object (fieldKey: { nestedKey: [...] })
	formats for ACP version/agent compatibility."

	| rawField |
	rawField := self rawValues at: fieldKey ifAbsent: [ ^ #() ].
	rawField ifNil: [ ^ #() ].
	rawField isDictionary
		ifTrue: [ ^ self valuesAt: nestedKey typed: valueClass in: rawField ].
	^ self valuesAt: fieldKey typed: valueClass in: self rawValues
]
