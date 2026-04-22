Class {
	#name : 'ACPConfigSelectGroup',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'instance creation' }
ACPConfigSelectGroup class >> fromDictionary: aDictionary [

	| instance opts rawCopy |
	rawCopy := aDictionary copy.
	opts := aDictionary at: 'options' ifAbsent: [ nil ].
	opts ifNotNil: [
		rawCopy
			at: 'options'
			put: (opts collect: [ :each |
				each isDictionary
					ifTrue: [ ACPConfigSelectOption fromDictionary: each ]
					ifFalse: [ each ] ]) ].
	instance := self new rawValues: rawCopy.
	^ instance
]

{ #category : 'accessing' }
ACPConfigSelectGroup >> group [

	^ self rawValues at: 'group' ifAbsent: []
]

{ #category : 'accessing' }
ACPConfigSelectGroup >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACPConfigSelectGroup >> options [

	^ self rawValues at: 'options' ifAbsent: [ #() ]
]
