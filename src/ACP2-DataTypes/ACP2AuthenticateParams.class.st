Class {
	#name : 'ACP2AuthenticateParams',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2AuthenticateParams >> methodId [

	^ self rawValues at: 'methodId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2AuthenticateParams >> methodId: aString [

	self rawValues at: 'methodId' put: aString
]
