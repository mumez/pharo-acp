Class {
	#name : 'ACPConfigSelectOption',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPConfigSelectOption >> value [

	^ self rawValues at: 'value' ifAbsent: []
]

{ #category : 'accessing' }
ACPConfigSelectOption >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACPConfigSelectOption >> description [

	^ self rawValues at: 'description' ifAbsent: []
]

{ #category : 'testing' }
ACPConfigSelectOption >> isGroup [
    ^ false
]
