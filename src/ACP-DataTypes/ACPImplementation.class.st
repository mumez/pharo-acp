Class {
	#name : 'ACPImplementation',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPImplementation >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACPImplementation >> name: aString [

	self rawValues at: 'name' put: aString
]

{ #category : 'accessing' }
ACPImplementation >> title [

	^ self rawValues at: 'title' ifAbsent: []
]

{ #category : 'accessing' }
ACPImplementation >> title: aString [

	self rawValues at: 'title' put: aString
]

{ #category : 'accessing' }
ACPImplementation >> version [

	^ self rawValues at: 'version' ifAbsent: []
]

{ #category : 'accessing' }
ACPImplementation >> version: aString [

	self rawValues at: 'version' put: aString
]
