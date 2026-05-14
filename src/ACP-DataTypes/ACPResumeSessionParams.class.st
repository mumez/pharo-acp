"
I represent parameters for 'session/resume' request.

See protocol docs: https://agentclientprotocol.com/protocol/session-resume

Responsibility:
- Hold cwd, sessionId and optional mcpServers for resuming a session
- Provide builder-style accessors on rawValues (inherited from ACPValues)

Collaborators:
- ACPResumeSessionResponse (future)
- ACPClientConnection >> resumeSession:
" 
Class {
	#name : 'ACPResumeSessionParams',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPResumeSessionParams >> cwd [

	^ self rawValues at: 'cwd' ifAbsent: []
]

{ #category : 'accessing' }
ACPResumeSessionParams >> cwd: aString [

	self rawValues at: 'cwd' put: aString
]

{ #category : 'accessing' }
ACPResumeSessionParams >> mcpServers [
	^ self valuesAt: 'mcpServers' typed: self mcpServerClass in: self rawValues
]

{ #category : 'accessing' }
ACPResumeSessionParams >> mcpServers: anArray [

	self
		rawValues
		at: 'mcpServers'
		put: (self dataTypeValuesFromRawArrayLikeValue: anArray for: self mcpServerClass)
]

{ #category : 'accessing' }
ACPResumeSessionParams >> addMcpServer: anACPMcpServer [

	self mcpServers: (self mcpServers , { anACPMcpServer })
]

{ #category : 'accessing' }
ACPResumeSessionParams >> addMcpServerBy: aBuilderBlock [
	| defaultServer builtServer mcpServer |
	defaultServer := ACPMcpServerStdio new.
	builtServer := aBuilderBlock value: defaultServer.
	mcpServer := (builtServer isKindOf: self mcpServerClass)
		             ifTrue: [ builtServer ]
		             ifFalse: [ defaultServer ].
	self addMcpServer: mcpServer
]

{ #category : 'factory' }
ACPResumeSessionParams >> mcpServerClass [
	^ ACPMcpServer
]

{ #category : 'accessing' }
ACPResumeSessionParams >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACPResumeSessionParams >> sessionId: aString [

	self rawValues at: 'sessionId' put: aString
]

{ #category : 'private' }
ACPResumeSessionParams >> ensureRequired [

	super ensureRequired.
	self rawValues at: 'mcpServers' ifAbsentPut: [ #() ].
	^ self
]

{ #category : 'converting' }
ACPResumeSessionParams >> asDictionary [

	| dict |
	dict := super asDictionary.
	dict at: 'mcpServers' put: (self mcpServers collect: [ :server | server asDictionary ]).
	^ dict
]
