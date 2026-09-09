"
I represent the MCP transport capabilities advertised by an ACP agent in its initialize response.

Responsibility:
- I decode the 'mcpCapabilities' sub-dictionary of an ACP2AgentCapabilities result,
  exposing boolean flags for MCP transport protocols the agent supports.

Collaborators:
- ACP2AgentCapabilities: creates me via fromDictionary:
- ACP2Values: my superclass

Public API:
- http - returns true/false/nil indicating HTTP transport support
- sse  - returns true/false/nil indicating SSE transport support
"
Class {
	#name : 'ACP2McpCapabilities',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2McpCapabilities >> http [

	^ self rawValues at: 'http' ifAbsent: []
]

{ #category : 'accessing' }
ACP2McpCapabilities >> sse [

	^ self rawValues at: 'sse' ifAbsent: []
]
