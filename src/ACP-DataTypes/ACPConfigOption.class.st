Class {
	#name : 'ACPConfigOption',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

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
ACPConfigOption >> category: aString [

	self rawValues at: 'category' put: aString
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

	^ (self rawValues at: 'options' ifAbsent: [ #() ]) collect: [ :each |
		each isDictionary
			ifTrue: [
				(each includesKey: 'group')
					ifTrue: [ ACPConfigSelectGroup fromDictionary: each ]
					ifFalse: [ ACPConfigSelectOption fromDictionary: each ] ]
			ifFalse: [ each ] ]
]

{ #category : 'testing' }
ACPConfigOption >> isSelect [

	^ self type = 'select'
]

{ #category : 'testing' }
ACPConfigOption >> isBoolean [

	^ self type = 'boolean'
]

{ #category : 'testing' }
ACPConfigOption >> isModelCategory [

	^ self category = 'model'
]

{ #category : 'testing' }
ACPConfigOption >> isModeCategory [

	^ self category = 'mode'
]

{ #category : 'testing' }
ACPConfigOption >> isThoughtLevelCategory [

	^ self category = 'thought_level'
]

{ #category : 'accessing' }
ACPConfigOption >> beModelCategory [

	self category: 'model'.
	^ self
]

{ #category : 'accessing' }
ACPConfigOption >> beModeCategory [

	self category: 'mode'.
	^ self
]

{ #category : 'accessing' }
ACPConfigOption >> beThoughtLevelCategory [

	self category: 'thought_level'.
	^ self
]
