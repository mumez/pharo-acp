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
	^ self rawValues at: 'mcpServers' ifAbsent: []
]

{ #category : 'accessing' }
ACPLoadSessionParams >> mcpServers: anArray [

	self rawValues at: 'mcpServers' put: anArray
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
