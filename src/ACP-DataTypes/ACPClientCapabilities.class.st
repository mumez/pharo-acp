Class {
	#name : 'ACPClientCapabilities',
	#superclass : 'ACPOptions',
	#instVars : [
		'fs',
		'terminal'
	],
	#category : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPClientCapabilities >> asDictionary [

	| dict |
	dict := Dictionary new.
	self fs asDictionary ifNotEmpty: [ :v | dict at: 'fs' put: v ].
	self terminal ifNotNil: [ :v | dict at: 'terminal' put: v ].
	self extraPropertiesOn: dict.
	^ dict
]

{ #category : 'accessing' }
ACPClientCapabilities >> fs [

	^ fs ifNil: [ fs := ACPFileSystemCapability new ]
]

{ #category : 'accessing' }
ACPClientCapabilities >> fs: anObject [

	fs := anObject
]

{ #category : 'accessing' }
ACPClientCapabilities >> terminal [

	^ terminal
]

{ #category : 'accessing' }
ACPClientCapabilities >> terminal: aBoolean [

	terminal := aBoolean
]
