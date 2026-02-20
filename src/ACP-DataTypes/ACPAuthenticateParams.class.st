Class {
	#name : 'ACPAuthenticateParams',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPAuthenticateParams >> methodId [

	^ self rawValues at: 'methodId' ifAbsent: []
]

{ #category : 'accessing' }
ACPAuthenticateParams >> methodId: aString [

	self rawValues at: 'methodId' put: aString
]
