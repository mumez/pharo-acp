Class {
	#name : 'ACP2InitializeParams',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'instance creation' }
ACP2InitializeParams class >> fromDictionary: aDictionary [

	| instance |
	instance := super fromDictionary: aDictionary.
	instance rawValues at: 'capabilities' ifPresent: [ :dict | instance capabilities: ACP2ClientCapabilities fromDictionary: dict ].
	instance rawValues at: 'info' ifPresent: [ :dict | instance info: ACP2Implementation fromDictionary: dict ].
	^ instance
]

{ #category : 'accessing' }
ACP2InitializeParams >> capabilities [

	^ self rawValues at: 'capabilities' ifAbsentPut: [ ACP2ClientCapabilities new ]
]

{ #category : 'accessing' }
ACP2InitializeParams >> capabilities: anObject [

	self rawValues at: 'capabilities' put: anObject
]

{ #category : 'accessing' }
ACP2InitializeParams >> info [

	^ self rawValues at: 'info' ifAbsentPut: [ ACP2Implementation new ]
]

{ #category : 'accessing' }
ACP2InitializeParams >> info: anObject [

	self rawValues at: 'info' put: anObject
]

{ #category : 'accessing' }
ACP2InitializeParams >> protocolVersion [

	^ self rawValues at: 'protocolVersion' ifAbsent: [ ACP2Constants protocolVersion ]
]

{ #category : 'accessing' }
ACP2InitializeParams >> protocolVersion: anInteger [

	self rawValues at: 'protocolVersion' put: anInteger
]

{ #category : 'private' }
ACP2InitializeParams >> ensureRequired [

	super ensureRequired.
	self rawValues at: 'protocolVersion' ifAbsentPut: [ ACP2Constants protocolVersion ].
	^ self
]

{ #category : 'converting' }
ACP2InitializeParams >> asDictionary [

	| dict |
	dict := super asDictionary.
	self trimNested: self capabilities named: 'capabilities' in: dict.
	self trimNested: self info named: 'info' in: dict.
	^ dict
]
