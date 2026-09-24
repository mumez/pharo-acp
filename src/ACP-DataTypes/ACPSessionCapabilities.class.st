"
I represent the session-level capabilities advertised by an ACP agent in its initialize response.

Responsibility:
- I decode the 'sessionCapabilities' sub-dictionary of ACPAgentCapabilities,
  exposing raw nested dictionaries for fork, list, delete, resume, and
  additionalDirectories capabilities.
- Values are returned as raw dictionaries (not further decoded) as each
  sub-capability may carry additional fields not yet modelled.

Collaborators:
- ACPAgentCapabilities: creates me via fromDictionary:
- ACPValues: my superclass

Public API:
- fork   - raw fork-capability dictionary, or nil
- list   - raw list-capability dictionary, or nil
- delete - raw delete-capability dictionary, or nil
- resume - raw resume-capability dictionary, or nil
- additionalDirectories - raw additionalDirectories-capability dictionary, or nil
"
Class {
	#name : 'ACPSessionCapabilities',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPSessionCapabilities >> fork [

	^ self rawValues at: 'fork' ifAbsent: []
]

{ #category : 'accessing' }
ACPSessionCapabilities >> close [

	^ self rawValues at: 'close' ifAbsent: []
]

{ #category : 'accessing' }
ACPSessionCapabilities >> delete [

	^ self rawValues at: 'delete' ifAbsent: []
]

{ #category : 'accessing' }
ACPSessionCapabilities >> list [

	^ self rawValues at: 'list' ifAbsent: []
]

{ #category : 'accessing' }
ACPSessionCapabilities >> resume [

	^ self rawValues at: 'resume' ifAbsent: []
]

{ #category : 'accessing' }
ACPSessionCapabilities >> additionalDirectories [

	^ self rawValues at: 'additionalDirectories' ifAbsent: []
]
