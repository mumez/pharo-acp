Class {
	#name : 'ACP2PermissionOption',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2PermissionOption >> optionId [

	^ self rawValues at: 'optionId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2PermissionOption >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACP2PermissionOption >> kind [

	^ self rawValues at: 'kind' ifAbsent: []
]
