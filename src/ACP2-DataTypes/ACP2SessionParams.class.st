Class {
	#name : 'ACP2SessionParams',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2SessionParams >> cwd [

	^ self rawValues at: 'cwd' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionParams >> cwd: aString [

	self rawValues at: 'cwd' put: aString
]
