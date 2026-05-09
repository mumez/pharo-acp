Class {
	#name : 'ACPSessionSetupResponse',
	#superclass : 'ACPBaseSessionResponse',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPSessionSetupResponse >> models [

	^ self availableModels
]

{ #category : 'accessing' }
ACPSessionSetupResponse >> modes [

	^ self availableModes
]

{ #category : 'accessing' }
ACPSessionSetupResponse >> availableModels [

	^ self
		  resolveListAt: 'models'
		  nestedKey: 'availableModels'
		  typed: ACPSessionModel
]

{ #category : 'accessing' }
ACPSessionSetupResponse >> availableModes [

	^ self
		  resolveListAt: 'modes'
		  nestedKey: 'availableModes'
		  typed: ACPSessionMode
]

{ #category : 'private' }
ACPSessionSetupResponse >> resolveListAt: fieldKey nestedKey: nestedKey typed: valueClass [
	"Supports both flat list (fieldKey: [...]) and state-object (fieldKey: { nestedKey: [...] })
	formats for ACP version/agent compatibility."

	| rawField |
	rawField := self rawValues at: fieldKey ifAbsent: [ ^ #() ].
	rawField ifNil: [ ^ #() ].
	rawField isDictionary
		ifTrue: [ ^ self valuesAt: nestedKey typed: valueClass in: rawField ].
	^ self valuesAt: fieldKey typed: valueClass in: self rawValues
]
