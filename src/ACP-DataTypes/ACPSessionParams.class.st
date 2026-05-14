Class {
	#name : 'ACPSessionParams',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPSessionParams >> cwd [

	^ self rawValues at: 'cwd' ifAbsent: []
]

{ #category : 'accessing' }
ACPSessionParams >> cwd: aString [

	self rawValues at: 'cwd' put: aString
]

{ #category : 'accessing' }
ACPSessionParams >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACPSessionParams >> sessionId: aString [

	self rawValues at: 'sessionId' put: aString
]

{ #category : 'accessing' }
ACPSessionParams >> mcpServers [

	^ self valuesAt: 'mcpServers' typed: ACPMcpServer in: self rawValues
]

{ #category : 'accessing' }
ACPSessionParams >> mcpServers: anArray [

	self
		rawValues
		at: 'mcpServers'
		put: (self dataTypeValuesFromRawArrayLikeValue: anArray for: ACPMcpServer)
]

{ #category : 'accessing' }
ACPSessionParams >> addMcpServer: anACPMcpServer [

	self mcpServers: (self mcpServers , { anACPMcpServer })
]

{ #category : 'accessing' }
ACPSessionParams >> addMcpServerBy: aBuilderBlock [

	| server |
	server := ACPMcpServer new.
	aBuilderBlock value: server.
	self addMcpServer: server
]

{ #category : 'converting' }
ACPSessionParams >> asDictionary [

	| dict |
	dict := super asDictionary.
	dict at: 'mcpServers' put: (self mcpServers collect: [ :server | server asDictionary ]).
	^ dict
]

{ #category : 'private' }
ACPSessionParams >> ensureRequired [

	super ensureRequired.
	self rawValues at: 'mcpServers' ifAbsentPut: [ #() ].
	^ self
]
