Class {
	#name : 'ACPBaseSessionResponse',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPBaseSessionResponse >> configOptions [

	^ self typedValuesAt: 'configOptions' typed: ACPConfigOption
]

{ #category : 'accessing' }
ACPBaseSessionResponse >> models [

	| rawModels |
	rawModels := self rawValues at: 'models' ifAbsent: [ ^ #() ].
	rawModels ifNil: [ ^ #() ].
	rawModels isDictionary ifTrue: [
		rawModels := rawModels at: 'availableModels' ifAbsent: [ #() ] ].
	^ self typedCollectionFrom: rawModels typed: ACPSessionModel
]

{ #category : 'accessing' }
ACPBaseSessionResponse >> modes [

	| rawModes |
	rawModes := self rawValues at: 'modes' ifAbsent: [ ^ #() ].
	rawModes ifNil: [ ^ #() ].
	rawModes isDictionary ifTrue: [
		rawModes := rawModes at: 'availableModes' ifAbsent: [ #() ] ].
	^ self typedCollectionFrom: rawModes typed: ACPSessionMode
]

{ #category : 'accessing' }
ACPBaseSessionResponse >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'private' }
ACPBaseSessionResponse >> typedCollectionFrom: rawCollection typed: valueClass [

	((rawCollection isCollection and: [ rawCollection isString not ])
		 and: [ rawCollection isDictionary not ])
		ifFalse: [ ^ #() ].
	^ (rawCollection select: [ :each |
		   each isDictionary or: [ each isKindOf: valueClass ] ]) collect: [ :each |
		  each isDictionary
			  ifTrue: [ valueClass fromDictionary: each ]
			  ifFalse: [ each ] ]
]

{ #category : 'private' }
ACPBaseSessionResponse >> typedValuesAt: propName typed: valueClass [

	^ self
		  typedCollectionFrom: (self rawValues at: propName ifAbsent: [ #() ])
		  typed: valueClass
]
