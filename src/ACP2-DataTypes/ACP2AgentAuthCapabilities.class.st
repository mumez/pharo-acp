"
I represent the authentication-related capabilities advertised by an ACP agent in its initialize response.

Responsibility:
- I decode the 'auth' sub-dictionary of ACP2AgentCapabilities, exposing the raw logout capability.

Collaborators:
- ACP2AgentCapabilities: creates me via fromDictionary:
- ACP2Values: my superclass

Public API:
- logout - raw logout-capability dictionary, or nil
"
Class {
	#name : 'ACP2AgentAuthCapabilities',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2AgentAuthCapabilities >> logout [

	^ self rawValues at: 'logout' ifAbsent: []
]
