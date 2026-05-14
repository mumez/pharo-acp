Class {
	#name : 'ACPHttpHeader',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPHttpHeader >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACPHttpHeader >> name: aString [

	self rawValues at: 'name' put: aString
]

{ #category : 'accessing' }
ACPHttpHeader >> value [

	^ self rawValues at: 'value' ifAbsent: []
]

{ #category : 'accessing' }
ACPHttpHeader >> value: aString [

	self rawValues at: 'value' put: aString
]
