Class {
	#name : 'ACPInitializeParams',
	#superclass : 'ACPParams',
	#instVars : [
		'protocolVersion',
		'capabilities',
		'clientInfo'
	],
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPInitializeParams >> asDictionary [

	| dict |
	dict := Dictionary new.
	dict at: 'protocolVersion' put: self protocolVersion.
	self capabilities asDictionary ifNotEmpty: [ :v | dict at: 'capabilities' put: v ].
	self clientInfo asDictionary ifNotEmpty: [ :v | dict at: 'clientInfo' put: v ].
	self extraPropertiesOn: dict.
	^ dict
]

{ #category : 'accessing' }
ACPInitializeParams >> capabilities [

	^ capabilities ifNil: [ capabilities := ACPClientCapabilities new ]
]

{ #category : 'accessing' }
ACPInitializeParams >> capabilities: anObject [

	capabilities := anObject
]

{ #category : 'accessing' }
ACPInitializeParams >> clientInfo [

	^ clientInfo ifNil: [ clientInfo := ACPImplementation new ]
]

{ #category : 'accessing' }
ACPInitializeParams >> clientInfo: anObject [

	clientInfo := anObject
]

{ #category : 'accessing' }
ACPInitializeParams >> protocolVersion [

	^ protocolVersion ifNil: [ protocolVersion := ACPConstants protocolVersion ]
]

{ #category : 'accessing' }
ACPInitializeParams >> protocolVersion: anInteger [

	protocolVersion := anInteger
]
