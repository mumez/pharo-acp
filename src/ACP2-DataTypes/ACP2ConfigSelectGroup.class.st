Class {
	#name : 'ACP2ConfigSelectGroup',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2ConfigSelectGroup >> group [

	^ self rawValues at: 'group' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ConfigSelectGroup >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ConfigSelectGroup >> options [

	^ (self rawValues at: 'options' ifAbsent: [ #() ]) collect: [ :each |
		each isDictionary
			ifTrue: [ ACP2ConfigSelectOption fromDictionary: each ]
			ifFalse: [ each ] ]
]

{ #category : 'testing' }
ACP2ConfigSelectGroup >> isGroup [
    ^ true
]
