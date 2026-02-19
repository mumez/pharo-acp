Class {
	#name : 'ACPNewSessionParams',
	#superclass : 'ACPOptions',
	#instVars : [
		'cwd',
		'mcpServers'
	],
	#category : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPNewSessionParams >> asDictionary [

	| dict |
	dict := Dictionary new.
	self cwd ifNotNil: [ :v | dict at: 'cwd' put: v ].
	self mcpServers ifNotNil: [ :v | dict at: 'mcpServers' put: v ].
	self extraPropertiesOn: dict.
	^ dict
]

{ #category : 'accessing' }
ACPNewSessionParams >> cwd [

	^ cwd
]

{ #category : 'accessing' }
ACPNewSessionParams >> cwd: aString [

	cwd := aString
]

{ #category : 'accessing' }
ACPNewSessionParams >> mcpServers [
	"required: set default value"
	^ mcpServers ifNil: [ mcpServers := #() ]
]

{ #category : 'accessing' }
ACPNewSessionParams >> mcpServers: anArray [

	mcpServers := anArray
]
