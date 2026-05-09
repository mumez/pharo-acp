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

	| rawModels valuesDict |
	rawModels := self rawValues at: 'models' ifAbsent: [ ^ #() ].
	rawModels ifNil: [ ^ #() ].
	rawModels isDictionary ifTrue: [
		rawModels := rawModels at: 'availableModels' ifAbsent: [ #() ] ].
	valuesDict := Dictionary newFrom: self rawValues.
	valuesDict at: 'models' put: rawModels.
	^ self valuesAt: 'models' typed: ACPSessionModel in: valuesDict
]

{ #category : 'accessing' }
ACPBaseSessionResponse >> modes [

	| rawModes valuesDict |
	rawModes := self rawValues at: 'modes' ifAbsent: [ ^ #() ].
	rawModes ifNil: [ ^ #() ].
	rawModes isDictionary ifTrue: [
		rawModes := rawModes at: 'availableModes' ifAbsent: [ #() ] ].
	valuesDict := Dictionary newFrom: self rawValues.
	valuesDict at: 'modes' put: rawModes.
	^ self valuesAt: 'modes' typed: ACPSessionMode in: valuesDict
]

{ #category : 'accessing' }
ACPBaseSessionResponse >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]
