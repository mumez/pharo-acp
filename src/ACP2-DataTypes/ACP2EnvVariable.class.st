Class {
	#name : 'ACP2EnvVariable',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2EnvVariable >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACP2EnvVariable >> name: aString [

	self rawValues at: 'name' put: aString
]

{ #category : 'accessing' }
ACP2EnvVariable >> value [

	^ self rawValues at: 'value' ifAbsent: []
]

{ #category : 'accessing' }
ACP2EnvVariable >> value: aString [

	self rawValues at: 'value' put: aString
]
