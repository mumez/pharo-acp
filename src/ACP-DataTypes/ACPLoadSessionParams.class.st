Class {
	#name : 'ACPLoadSessionParams',
	#superclass : 'ACPParams',
	#instVars : [
		'sessionId',
		'cwd',
		'mcpServers'
	],
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPLoadSessionParams >> asDictionary [

	| dict |
	dict := Dictionary new.
	self sessionId ifNotNil: [ :v | dict at: 'sessionId' put: v ].
	self cwd ifNotNil: [ :v | dict at: 'cwd' put: v ].
	self mcpServers ifNotNil: [ :v | dict at: 'mcpServers' put: v ].
	self extraPropertiesOn: dict.
	^ dict
]

{ #category : 'accessing' }
ACPLoadSessionParams >> cwd [

	^ cwd
]

{ #category : 'accessing' }
ACPLoadSessionParams >> cwd: aString [

	cwd := aString
]

{ #category : 'accessing' }
ACPLoadSessionParams >> mcpServers [
	"required: set default value"
	^ mcpServers ifNil: [ mcpServers := #() ]
]

{ #category : 'accessing' }
ACPLoadSessionParams >> mcpServers: anArray [

	mcpServers := anArray
]

{ #category : 'accessing' }
ACPLoadSessionParams >> sessionId [

	^ sessionId
]

{ #category : 'accessing' }
ACPLoadSessionParams >> sessionId: aString [

	sessionId := aString
]
