Class {
	#name : 'ACPAvailableCommand',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPAvailableCommand >> description [

	^ self rawValues at: 'description' ifAbsent: []
]

{ #category : 'accessing' }
ACPAvailableCommand >> input [

	^ self rawValues at: 'input' ifAbsent: []
]

{ #category : 'accessing' }
ACPAvailableCommand >> inputHint [

	^ self input ifNotNil: [ :dict | dict at: 'hint' ifAbsent: [] ]
]

{ #category : 'accessing' }
ACPAvailableCommand >> name [

	^ self rawValues at: 'name' ifAbsent: []
]
