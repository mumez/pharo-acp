Class {
	#name : 'ACPBaseSessionResponse',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPBaseSessionResponse >> configOptions [

	^ self valuesAt: 'configOptions' typed: ACPConfigOption in: self rawValues
]

{ #category : 'accessing' }
ACPBaseSessionResponse >> models [

	^ self availableModels
]

{ #category : 'accessing' }
ACPBaseSessionResponse >> modes [

	^ self availableModes
]

{ #category : 'accessing' }
ACPBaseSessionResponse >> availableModels [

	| rawModels |
	rawModels := self rawValues at: 'models' ifAbsent: [ ^ #() ].
	rawModels ifNil: [ ^ #() ].
	rawModels isDictionary
		ifTrue: [
			^ self
				  valuesAt: 'availableModels'
				  typed: ACPSessionModel
				  in: rawModels ].
	^ self valuesAt: 'models' typed: ACPSessionModel in: self rawValues
]

{ #category : 'accessing' }
ACPBaseSessionResponse >> availableModes [

	| rawModes |
	rawModes := self rawValues at: 'modes' ifAbsent: [ ^ #() ].
	rawModes ifNil: [ ^ #() ].
	rawModes isDictionary
		ifTrue: [
			^ self
				  valuesAt: 'availableModes'
				  typed: ACPSessionMode
				  in: rawModes ].
	^ self valuesAt: 'modes' typed: ACPSessionMode in: self rawValues
]

{ #category : 'accessing' }
ACPBaseSessionResponse >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]
