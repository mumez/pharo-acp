"
I represent the session-level capabilities advertised by an ACP agent in its initialize response.

Responsibility:
- I decode the 'sessionCapabilities' sub-dictionary of ACP2AgentCapabilities,
  exposing raw nested dictionaries for fork, list, and resume capabilities.
- Values are returned as raw dictionaries (not further decoded) as each
  sub-capability may carry additional fields not yet modelled.

Collaborators:
- ACP2AgentCapabilities: creates me via fromDictionary:
- ACP2Values: my superclass

Public API:
- fork   - raw fork-capability dictionary, or nil
- list   - raw list-capability dictionary, or nil
- resume - raw resume-capability dictionary, or nil
"
Class {
	#name : 'ACP2SessionCapabilities',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2SessionCapabilities >> fork [

	^ self rawValues at: 'fork' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionCapabilities >> close [

	^ self rawValues at: 'close' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionCapabilities >> list [

	^ self rawValues at: 'list' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionCapabilities >> resume [

	^ self rawValues at: 'resume' ifAbsent: []
]
