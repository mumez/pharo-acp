"
I represent the MCP transport capabilities advertised by an ACP agent in its initialize response.

Responsibility:
- I decode the 'mcpCapabilities' sub-dictionary of an ACPAgentCapabilities result,
  exposing boolean flags for MCP transport protocols the agent supports.

Collaborators:
- ACPAgentCapabilities: creates me via fromDictionary:
- ACPValues: my superclass

Public API:
- http - returns true/false/nil indicating HTTP transport support
- sse  - returns true/false/nil indicating SSE transport support
"
Class {
	#name : 'ACPMcpCapabilities',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPMcpCapabilities >> http [

	^ self rawValues at: 'http' ifAbsent: []
]

{ #category : 'accessing' }
ACPMcpCapabilities >> sse [

	^ self rawValues at: 'sse' ifAbsent: []
]
