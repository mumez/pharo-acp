Class {
	#name : 'ACPClientCapabilities',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPClientCapabilities >> asDictionary [

	| dict |
	dict := super asDictionary.
	dict at: 'fs' put: self fs asDictionary.
	self trimNested: self elicitation named: 'elicitation' in: dict.
	^ dict
]

{ #category : 'accessing' }
ACPClientCapabilities >> elicitation [

	^ self rawValues at: 'elicitation' ifAbsentPut: [ ACPElicitationCapabilities new ]
]

{ #category : 'accessing' }
ACPClientCapabilities >> elicitation: anObject [

	^ self rawValues at: 'elicitation' put: anObject
]

{ #category : 'accessing' }
ACPClientCapabilities >> fs [

	^ self rawValues at: 'fs' ifAbsentPut: [ ACPFileSystemCapability new ]
]

{ #category : 'accessing' }
ACPClientCapabilities >> fs: anObject [

	^ self rawValues at: 'fs' put: anObject
]

{ #category : 'accessing' }
ACPClientCapabilities >> terminal [

	^ self rawValues at: 'terminal' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACPClientCapabilities >> terminal: aBoolean [

	^ self rawValues at: 'terminal' put: aBoolean
]

{ #category : 'instance creation' }
ACPClientCapabilities class >> fromDictionary: aDictionary [

	| instance |
	instance := super fromDictionary: aDictionary.
	instance rawValues at: 'fs' ifPresent: [ :dict | instance fs: (ACPFileSystemCapability fromDictionary: dict) ].
	instance rawValues at: 'elicitation' ifPresent: [ :dict |
		dict
			ifNil: [ instance rawValues removeKey: 'elicitation' ]
			ifNotNil: [ instance elicitation: (ACPElicitationCapabilities fromDictionary: dict) ] ].
	^ instance
]