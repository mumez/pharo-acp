Class {
	#name : 'ACPLoadSessionRequest',
	#superclass : 'ACPOptions',
	#instVars : [
		'sessionId',
		'cwd',
		'mcpServers'
	],
	#category : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPLoadSessionRequest >> asDictionary [

	| dict |
	dict := Dictionary new.
	self sessionId ifNotNil: [ :v | dict at: 'sessionId' put: v ].
	self cwd ifNotNil: [ :v | dict at: 'cwd' put: v ].
	self mcpServers ifNotNil: [ :v | dict at: 'mcpServers' put: v ].
	self extraPropertiesOn: dict.
	^ dict
]

{ #category : 'accessing' }
ACPLoadSessionRequest >> cwd [

	^ cwd
]

{ #category : 'accessing' }
ACPLoadSessionRequest >> cwd: aString [

	cwd := aString
]

{ #category : 'accessing' }
ACPLoadSessionRequest >> mcpServers [

	^ mcpServers
]

{ #category : 'accessing' }
ACPLoadSessionRequest >> mcpServers: anArray [

	mcpServers := anArray
]

{ #category : 'accessing' }
ACPLoadSessionRequest >> sessionId [

	^ sessionId
]

{ #category : 'accessing' }
ACPLoadSessionRequest >> sessionId: aString [

	sessionId := aString
]
