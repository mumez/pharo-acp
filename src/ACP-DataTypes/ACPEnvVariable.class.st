Class {
	#name : 'ACPEnvVariable',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPEnvVariable >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACPEnvVariable >> name: aString [

	self rawValues at: 'name' put: aString
]

{ #category : 'accessing' }
ACPEnvVariable >> value [

	^ self rawValues at: 'value' ifAbsent: []
]

{ #category : 'accessing' }
ACPEnvVariable >> value: aString [

	self rawValues at: 'value' put: aString
]
