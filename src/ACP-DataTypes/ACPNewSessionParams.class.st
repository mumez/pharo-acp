Class {
	#name : 'ACPNewSessionParams',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPNewSessionParams >> cwd [

	^ self rawValues at: 'cwd' ifAbsent: []
]

{ #category : 'accessing' }
ACPNewSessionParams >> cwd: aString [

	self rawValues at: 'cwd' put: aString
]

{ #category : 'accessing' }
ACPNewSessionParams >> mcpServers [
	^ self valuesAt: 'mcpServers' typed: self mcpServerClass in: self rawValues
]

{ #category : 'accessing' }
ACPNewSessionParams >> mcpServers: anArray [

	self
		rawValues
		at: 'mcpServers'
		put: (self dataTypeValuesFromRawArrayLikeValue: anArray for: self mcpServerClass)
]

{ #category : 'accessing' }
ACPNewSessionParams >> addMcpServer: anACPMcpServer [

	self mcpServers: (self mcpServers , { anACPMcpServer })
]

{ #category : 'accessing' }
ACPNewSessionParams >> addMcpServerBy: aBuilderBlock [
	| defaultServer builtServer mcpServer |
	defaultServer := ACPMcpServerStdio new.
	builtServer := aBuilderBlock value: defaultServer.
	mcpServer := (builtServer isKindOf: self mcpServerClass)
		             ifTrue: [ builtServer ]
		             ifFalse: [ defaultServer ].
	self addMcpServer: mcpServer
]

{ #category : 'factory' }
ACPNewSessionParams >> mcpServerClass [
	^ ACPMcpServer
]

{ #category : 'converting' }
ACPNewSessionParams >> asDictionary [

	| dict |
	dict := super asDictionary.
	dict at: 'mcpServers' put: (self mcpServers collect: [ :server | server asDictionary ]).
	^ dict
]

{ #category : 'private' }
ACPNewSessionParams >> ensureRequired [

	super ensureRequired.
	self rawValues at: 'mcpServers' ifAbsentPut: [ #() ].
	^ self
]
