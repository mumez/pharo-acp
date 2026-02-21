Class {
	#name : 'ACPPermissionOption',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPPermissionOption >> optionId [

	^ self rawValues at: 'optionId' ifAbsent: []
]

{ #category : 'accessing' }
ACPPermissionOption >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACPPermissionOption >> kind [

	^ self rawValues at: 'kind' ifAbsent: []
]
