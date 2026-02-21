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
