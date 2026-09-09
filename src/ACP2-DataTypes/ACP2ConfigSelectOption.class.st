Class {
	#name : 'ACP2ConfigSelectOption',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2ConfigSelectOption >> value [

	^ self rawValues at: 'value' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ConfigSelectOption >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ConfigSelectOption >> description [

	^ self rawValues at: 'description' ifAbsent: []
]

{ #category : 'testing' }
ACP2ConfigSelectOption >> isGroup [
    ^ false
]
