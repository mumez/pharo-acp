Class {
	#name : 'ACPConfigSelectGroup',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

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

	^ (self rawValues at: 'options' ifAbsent: [ #() ]) collect: [ :each |
		each isDictionary
			ifTrue: [ ACPConfigSelectOption fromDictionary: each ]
			ifFalse: [ each ] ]
]

{ #category : 'testing' }
ACPConfigSelectGroup >> isGroup [
    ^ true
]
