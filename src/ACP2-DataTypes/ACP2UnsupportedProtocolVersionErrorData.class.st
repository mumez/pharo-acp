"
I represent the data of a -32022 (Unsupported protocol version) error, answered to initialize when the agent supports no version at or below the requested one.

Responsibility:
- I decode the requested protocol version and the versions the agent supports

Collaborators:
- ACP2RequestError: creates me from its data (#unsupportedProtocolVersionData) and builds me for #unsupportedProtocolVersion:supported:
- ACP2Values: my superclass

Public API:
- requested / requested: - the protocol version the client requested
- supported / supported: - the protocol versions the agent supports (empty when absent)
"
Class {
	#name : 'ACP2UnsupportedProtocolVersionErrorData',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2UnsupportedProtocolVersionErrorData >> requested [

	^ self rawValues at: 'requested' ifAbsent: []
]

{ #category : 'accessing' }
ACP2UnsupportedProtocolVersionErrorData >> requested: anInteger [

	self rawValues at: 'requested' put: anInteger
]

{ #category : 'accessing' }
ACP2UnsupportedProtocolVersionErrorData >> supported [

	^ (self rawValues at: 'supported' ifAbsent: [ nil ]) ifNil: [ #(  ) ]
]

{ #category : 'accessing' }
ACP2UnsupportedProtocolVersionErrorData >> supported: anArray [

	self rawValues at: 'supported' put: anArray
]
