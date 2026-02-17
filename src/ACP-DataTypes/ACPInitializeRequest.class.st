Class {
	#name : 'ACPInitializeRequest',
	#superclass : 'ACPOptions',
	#instVars : [
		'clientCapabilities',
		'clientInfo'
	],
	#category : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPInitializeRequest >> asDictionary [

	| dict |
	dict := Dictionary new.
	self clientCapabilities asDictionary ifNotEmpty: [ :v | dict at: 'clientCapabilities' put: v ].
	self clientInfo asDictionary ifNotEmpty: [ :v | dict at: 'clientInfo' put: v ].
	self extraPropertiesOn: dict.
	^ dict
]

{ #category : 'accessing' }
ACPInitializeRequest >> clientCapabilities [

	^ clientCapabilities ifNil: [ clientCapabilities := ACPClientCapabilities new ]
]

{ #category : 'accessing' }
ACPInitializeRequest >> clientCapabilities: anObject [

	clientCapabilities := anObject
]

{ #category : 'accessing' }
ACPInitializeRequest >> clientInfo [

	^ clientInfo ifNil: [ clientInfo := ACPImplementation new ]
]

{ #category : 'accessing' }
ACPInitializeRequest >> clientInfo: anObject [

	clientInfo := anObject
]
