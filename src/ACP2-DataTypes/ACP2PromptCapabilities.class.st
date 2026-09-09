"
I represent the prompt content-type capabilities advertised by an ACP agent in its initialize response.

Responsibility:
- I decode the 'promptCapabilities' sub-dictionary of an ACP2AgentCapabilities result,
  exposing boolean flags for content modalities the agent accepts in prompt requests.

Collaborators:
- ACP2AgentCapabilities: creates me via fromDictionary:
- ACP2Values: my superclass

Public API:
- audio           - true/false/nil; agent supports audio content blocks
- embeddedContext - true/false/nil; agent supports embedded context blocks
- image           - true/false/nil; agent supports image content blocks
"
Class {
	#name : 'ACP2PromptCapabilities',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2PromptCapabilities >> audio [

	^ self rawValues at: 'audio' ifAbsent: []
]

{ #category : 'accessing' }
ACP2PromptCapabilities >> embeddedContext [

	^ self rawValues at: 'embeddedContext' ifAbsent: []
]

{ #category : 'accessing' }
ACP2PromptCapabilities >> image [

	^ self rawValues at: 'image' ifAbsent: []
]
