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
	"Session setup responses may contain either:
	 - models: [ ... ] (legacy flat list style), or
	 - models: { availableModels: [ ... ] } (state object style).
	Support both for compatibility across ACP versions/agents."

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
ACPSessionSetupResponse >> availableModes [
	"Session setup responses may contain either:
	 - modes: [ ... ] (legacy flat list style), or
	 - modes: { availableModes: [ ... ] } (state object style).
	Support both for compatibility across ACP versions/agents."

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
