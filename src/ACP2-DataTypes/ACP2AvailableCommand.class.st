Class {
	#name : 'ACP2AvailableCommand',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2AvailableCommand >> description [

	^ self rawValues at: 'description' ifAbsent: []
]

{ #category : 'accessing' }
ACP2AvailableCommand >> input [

	^ self rawValues at: 'input' ifAbsent: []
]

{ #category : 'accessing' }
ACP2AvailableCommand >> inputHint [

	^ self input ifNotNil: [ :dict | dict at: 'hint' ifAbsent: [] ]
]

{ #category : 'accessing' }
ACP2AvailableCommand >> name [

	^ self rawValues at: 'name' ifAbsent: []
]
