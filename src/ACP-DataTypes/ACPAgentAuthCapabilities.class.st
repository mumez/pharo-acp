"
I represent the authentication-related capabilities advertised by an ACP agent in its initialize response.

Responsibility:
- I decode the 'auth' sub-dictionary of ACPAgentCapabilities, exposing the raw logout capability.

Collaborators:
- ACPAgentCapabilities: creates me via fromDictionary:
- ACPValues: my superclass

Public API:
- logout - raw logout-capability dictionary, or nil
"
Class {
	#name : 'ACPAgentAuthCapabilities',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPAgentAuthCapabilities >> logout [

	^ self rawValues at: 'logout' ifAbsent: []
]
