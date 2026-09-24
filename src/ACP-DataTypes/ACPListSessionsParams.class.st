Class {
	#name : 'ACPListSessionsParams',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPListSessionsParams >> cwd [

	^ self rawValues at: 'cwd' ifAbsent: []
]

{ #category : 'accessing' }
ACPListSessionsParams >> cwd: aString [

	self rawValues at: 'cwd' put: aString
]

{ #category : 'accessing' }
ACPListSessionsParams >> cursor [

	^ self rawValues at: 'cursor' ifAbsent: []
]

{ #category : 'accessing' }
ACPListSessionsParams >> cursor: aString [

	self rawValues at: 'cursor' put: aString
]
