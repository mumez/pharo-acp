Class {
	#name : 'ACPConfigOption',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'instance creation' }
ACPConfigOption class >> fromDictionary: aDictionary [

	| instance opts rawCopy |
	rawCopy := aDictionary copy.
	opts := aDictionary at: 'options' ifAbsent: [ nil ].
	opts ifNotNil: [
		rawCopy
			at: 'options'
			put: (opts collect: [ :each |
				(each isKindOf: Dictionary)
					ifTrue: [
						(each includesKey: 'group')
							ifTrue: [ ACPConfigSelectGroup fromDictionary: each ]
							ifFalse: [ ACPConfigSelectOption fromDictionary: each ] ]
					ifFalse: [ each ] ]) ].
	instance := self new rawValues: rawCopy.
	^ instance
]

{ #category : 'accessing' }
ACPConfigOption >> id [

	^ self rawValues at: 'id' ifAbsent: []
]

{ #category : 'accessing' }
ACPConfigOption >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACPConfigOption >> description [

	^ self rawValues at: 'description' ifAbsent: []
]

{ #category : 'accessing' }
ACPConfigOption >> category [

	^ self rawValues at: 'category' ifAbsent: []
]

{ #category : 'accessing' }
ACPConfigOption >> type [

	^ self rawValues at: 'type' ifAbsent: []
]

{ #category : 'accessing' }
ACPConfigOption >> currentValue [

	^ self rawValues at: 'currentValue' ifAbsent: []
]

{ #category : 'accessing' }
ACPConfigOption >> options [

	^ self rawValues at: 'options' ifAbsent: [ #() ]
]

{ #category : 'testing' }
ACPConfigOption >> isSelect [

	^ self type = 'select'
]

{ #category : 'testing' }
ACPConfigOption >> isBoolean [

	^ self type = 'boolean'
]

