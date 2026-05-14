"
I represent an MCP server configuration in session params.

I dispatch dictionaries to typed transport-specific subclasses:
- ACPMcpServerHttp
- ACPMcpServerSse
- ACPMcpServerStdio (default when type is absent)
" 
Class {
	#name : 'ACPMcpServer',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'instance creation' }
ACPMcpServer class >> fromDictionary: aDictionary [
	| transportType |
	self == ACPMcpServer ifFalse: [ ^ super fromDictionary: aDictionary ].
	transportType := aDictionary at: 'type' ifAbsent: [ nil ].
	transportType ifNil: [ ^ ACPMcpServerStdio fromDictionary: aDictionary ].
	transportType = 'stdio' ifTrue: [ ^ ACPMcpServerStdio fromDictionary: aDictionary ].
	transportType = 'http' ifTrue: [ ^ ACPMcpServerHttp fromDictionary: aDictionary ].
	transportType = 'sse' ifTrue: [ ^ ACPMcpServerSse fromDictionary: aDictionary ].
	^ super fromDictionary: aDictionary
]

{ #category : 'accessing' }
ACPMcpServer >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACPMcpServer >> name: aString [

	self rawValues at: 'name' put: aString
]
