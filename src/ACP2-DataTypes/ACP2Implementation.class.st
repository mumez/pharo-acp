Class {
	#name : 'ACP2Implementation',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2Implementation >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACP2Implementation >> name: aString [

	self rawValues at: 'name' put: aString
]

{ #category : 'accessing' }
ACP2Implementation >> title [

	^ self rawValues at: 'title' ifAbsent: []
]

{ #category : 'accessing' }
ACP2Implementation >> title: aString [

	self rawValues at: 'title' put: aString
]

{ #category : 'accessing' }
ACP2Implementation >> version [

	^ self rawValues at: 'version' ifAbsent: []
]

{ #category : 'accessing' }
ACP2Implementation >> version: aString [

	self rawValues at: 'version' put: aString
]
