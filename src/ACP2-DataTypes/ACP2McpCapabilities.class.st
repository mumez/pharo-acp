"
I represent the MCP server transports an ACP v2 agent accepts on session lifecycle requests (session.mcp).

Responsibility:
- I record which transports are advertised: stdio and http
- A transport counts as supported only when its entry is present and non-null; {} means supported

Collaborators:
- ACP2SessionCapabilities: holds me under 'mcp'
- ACP2Values: my superclass

Public API:
- isStdioSupported / isHttpSupported - whether a transport is advertised
- enableStdio / enableHttp - advertise a transport
- stdio / http - raw capability dictionaries, or nil
"
Class {
	#name : 'ACP2McpCapabilities',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'actions' }
ACP2McpCapabilities >> enableHttp [

	self rawValues at: 'http' put: Dictionary new
]

{ #category : 'actions' }
ACP2McpCapabilities >> enableStdio [

	self rawValues at: 'stdio' put: Dictionary new
]

{ #category : 'accessing' }
ACP2McpCapabilities >> http [

	^ self rawValues at: 'http' ifAbsent: []
]

{ #category : 'testing' }
ACP2McpCapabilities >> isHttpSupported [

	^ self http notNil
]

{ #category : 'testing' }
ACP2McpCapabilities >> isStdioSupported [

	^ self stdio notNil
]

{ #category : 'accessing' }
ACP2McpCapabilities >> stdio [

	^ self rawValues at: 'stdio' ifAbsent: []
]
