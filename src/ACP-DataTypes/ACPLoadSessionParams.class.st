Class {
	#name : 'ACPLoadSessionParams',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPLoadSessionParams >> cwd [

	^ self rawValues at: 'cwd' ifAbsent: []
]

{ #category : 'accessing' }
ACPLoadSessionParams >> cwd: aString [

	self rawValues at: 'cwd' put: aString
]

{ #category : 'accessing' }
ACPLoadSessionParams >> mcpServers [
	^ self valuesAt: 'mcpServers' typed: self mcpServerClass in: self rawValues
]

{ #category : 'accessing' }
ACPLoadSessionParams >> mcpServers: anArray [

	self
		rawValues
		at: 'mcpServers'
		put: (self dataTypeValuesFromRawArrayLikeValue: anArray for: self mcpServerClass)
]

{ #category : 'accessing' }
ACPLoadSessionParams >> addMcpServer: anACPMcpServer [

	self mcpServers: (self mcpServers , { anACPMcpServer })
]

{ #category : 'accessing' }
ACPLoadSessionParams >> addMcpServerBy: aBuilderBlock [
	| defaultServer builtServer mcpServer |
	defaultServer := ACPMcpServerStdio new.
	builtServer := aBuilderBlock value: defaultServer.
	mcpServer := (builtServer isKindOf: self mcpServerClass)
		             ifTrue: [ builtServer ]
		             ifFalse: [ defaultServer ].
	self addMcpServer: mcpServer
]

{ #category : 'factory' }
ACPLoadSessionParams >> mcpServerClass [
	^ ACPMcpServer
]

{ #category : 'accessing' }
ACPLoadSessionParams >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACPLoadSessionParams >> sessionId: aString [

	self rawValues at: 'sessionId' put: aString
]

{ #category : 'private' }
ACPLoadSessionParams >> ensureRequired [

	super ensureRequired.
	self rawValues at: 'mcpServers' ifAbsentPut: [ #() ].
	^ self
]

{ #category : 'converting' }
ACPLoadSessionParams >> asDictionary [

	| dict |
	dict := super asDictionary.
	dict at: 'mcpServers' put: (self mcpServers collect: [ :server | server asDictionary ]).
	^ dict
]
