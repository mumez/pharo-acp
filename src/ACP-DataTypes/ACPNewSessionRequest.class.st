Class {
	#name : 'ACPNewSessionRequest',
	#superclass : 'ACPOptions',
	#instVars : [
		'cwd',
		'mcpServers'
	],
	#category : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPNewSessionRequest >> asDictionary [

	| dict |
	dict := Dictionary new.
	self cwd ifNotNil: [ :v | dict at: 'cwd' put: v ].
	self mcpServers ifNotNil: [ :v | dict at: 'mcpServers' put: v ].
	self extraPropertiesOn: dict.
	^ dict
]

{ #category : 'accessing' }
ACPNewSessionRequest >> cwd [

	^ cwd
]

{ #category : 'accessing' }
ACPNewSessionRequest >> cwd: aString [

	cwd := aString
]

{ #category : 'accessing' }
ACPNewSessionRequest >> mcpServers [

	^ mcpServers
]

{ #category : 'accessing' }
ACPNewSessionRequest >> mcpServers: anArray [

	mcpServers := anArray
]
