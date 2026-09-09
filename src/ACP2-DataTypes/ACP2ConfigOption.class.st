Class {
	#name : 'ACP2ConfigOption',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2ConfigOption >> id [

	^ self rawValues at: 'id' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ConfigOption >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ConfigOption >> description [

	^ self rawValues at: 'description' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ConfigOption >> category [

	^ self rawValues at: 'category' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ConfigOption >> category: aString [

	self rawValues at: 'category' put: aString
]

{ #category : 'accessing' }
ACP2ConfigOption >> type [

	^ self rawValues at: 'type' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ConfigOption >> currentValue [

	^ self rawValues at: 'currentValue' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ConfigOption >> options [

	^ (self rawValues at: 'options' ifAbsent: [ #() ]) collect: [ :each |
		each isDictionary
			ifTrue: [
				(each includesKey: 'group')
					ifTrue: [ ACP2ConfigSelectGroup fromDictionary: each ]
					ifFalse: [ ACP2ConfigSelectOption fromDictionary: each ] ]
			ifFalse: [ each ] ]
]

{ #category : 'testing' }
ACP2ConfigOption >> isSelect [

	^ self type = 'select'
]

{ #category : 'testing' }
ACP2ConfigOption >> isBoolean [

	^ self type = 'boolean'
]

{ #category : 'testing' }
ACP2ConfigOption >> isModelCategory [

	^ self category = 'model'
]

{ #category : 'testing' }
ACP2ConfigOption >> isModeCategory [

	^ self category = 'mode'
]

{ #category : 'testing' }
ACP2ConfigOption >> isThoughtLevelCategory [

	^ self category = 'thought_level'
]

{ #category : 'accessing' }
ACP2ConfigOption >> beModelCategory [

	self category: 'model'.
	^ self
]

{ #category : 'accessing' }
ACP2ConfigOption >> beModeCategory [

	self category: 'mode'.
	^ self
]

{ #category : 'accessing' }
ACP2ConfigOption >> beThoughtLevelCategory [

	self category: 'thought_level'.
	^ self
]
