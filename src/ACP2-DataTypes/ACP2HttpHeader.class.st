Class {
	#name : 'ACP2HttpHeader',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2HttpHeader >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACP2HttpHeader >> name: aString [

	self rawValues at: 'name' put: aString
]

{ #category : 'accessing' }
ACP2HttpHeader >> value [

	^ self rawValues at: 'value' ifAbsent: []
]

{ #category : 'accessing' }
ACP2HttpHeader >> value: aString [

	self rawValues at: 'value' put: aString
]
