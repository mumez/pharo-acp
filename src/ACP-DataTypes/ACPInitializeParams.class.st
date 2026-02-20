Class {
	#name : 'ACPInitializeParams',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'instance creation' }
ACPInitializeParams class >> fromDictionary: aDictionary [

	| instance |
	instance := super fromDictionary: aDictionary.
	instance rawValues at: 'capabilities' ifPresent: [ :dict | instance capabilities: ACPClientCapabilities fromDictionary: dict ].
	instance rawValues at: 'clientInfo' ifPresent: [ :dict | instance clientInfo: ACPImplementation fromDictionary: dict ].
	^ instance
]

{ #category : 'accessing' }
ACPInitializeParams >> capabilities [

	^ self rawValues at: 'capabilities' ifAbsentPut: [ ACPClientCapabilities new ]
]

{ #category : 'accessing' }
ACPInitializeParams >> capabilities: anObject [

	self rawValues at: 'capabilities' put: anObject
]

{ #category : 'accessing' }
ACPInitializeParams >> clientInfo [

	^ self rawValues at: 'clientInfo' ifAbsentPut: [ ACPImplementation new ]
]

{ #category : 'accessing' }
ACPInitializeParams >> clientInfo: anObject [

	self rawValues at: 'clientInfo' put: anObject
]

{ #category : 'accessing' }
ACPInitializeParams >> protocolVersion [

	^ self rawValues at: 'protocolVersion' ifAbsent: [ ACPConstants protocolVersion ]
]

{ #category : 'accessing' }
ACPInitializeParams >> protocolVersion: anInteger [

	self rawValues at: 'protocolVersion' put: anInteger
]

{ #category : 'private' }
ACPInitializeParams >> ensureRequired [

	super ensureRequired.
	self rawValues at: 'protocolVersion' ifAbsentPut: [ ACPConstants protocolVersion ].
	^ self
]

{ #category : 'converting' }
ACPInitializeParams >> asDictionary [
	| dict |
	dict := super asDictionary.
	dict at: 'capabilities' put: self capabilities asDictionary.
	dict at: 'clientInfo' put: self clientInfo asDictionary.
	^ dict
]
