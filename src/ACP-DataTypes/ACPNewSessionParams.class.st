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
	^ self rawValues at: 'mcpServers' ifAbsent: []
]

{ #category : 'accessing' }
ACPNewSessionParams >> mcpServers: anArray [

	self rawValues at: 'mcpServers' put: anArray
]

{ #category : 'private' }
ACPNewSessionParams >> ensureRequired [

	super ensureRequired.
	self rawValues at: 'mcpServers' ifAbsentPut: [ #() ].
	^ self
]
