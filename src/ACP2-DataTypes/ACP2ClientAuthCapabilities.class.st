"
I represent the authentication method types an ACP v2 client can handle (capabilities.auth).

Responsibility:
- I record whether the client supports 'terminal' authentication methods; {} means supported
- The agent may include terminal entries in its authMethods only when I advertise terminal

Collaborators:
- ACP2ClientCapabilities: holds me under 'auth'
- ACP2Values: my superclass

Public API:
- enableTerminal - advertise terminal authentication (only if the client can reproduce the agent invocation in an interactive terminal)
- isTerminalSupported - whether terminal authentication is advertised
- terminal - raw capability dictionary, or nil
"
Class {
	#name : 'ACP2ClientAuthCapabilities',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'actions' }
ACP2ClientAuthCapabilities >> enableTerminal [

	self rawValues at: 'terminal' put: Dictionary new
]

{ #category : 'testing' }
ACP2ClientAuthCapabilities >> isTerminalSupported [

	^ self terminal notNil
]

{ #category : 'accessing' }
ACP2ClientAuthCapabilities >> terminal [

	^ self rawValues at: 'terminal' ifAbsent: []
]
