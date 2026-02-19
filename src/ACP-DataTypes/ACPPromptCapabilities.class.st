"
I represent the prompt content-type capabilities advertised by an ACP agent in its initialize response.

Responsibility:
- I decode the 'promptCapabilities' sub-dictionary of an ACPAgentCapabilities result,
  exposing boolean flags for content modalities the agent accepts in prompt requests.

Collaborators:
- ACPAgentCapabilities: creates me via fromDictionary:
- ACPValues: my superclass

Public API:
- audio           - true/false/nil; agent supports audio content blocks
- embeddedContext - true/false/nil; agent supports embedded context blocks
- image           - true/false/nil; agent supports image content blocks
"
Class {
	#name : 'ACPPromptCapabilities',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPPromptCapabilities >> audio [

	^ self rawValues at: 'audio' ifAbsent: []
]

{ #category : 'accessing' }
ACPPromptCapabilities >> embeddedContext [

	^ self rawValues at: 'embeddedContext' ifAbsent: []
]

{ #category : 'accessing' }
ACPPromptCapabilities >> image [

	^ self rawValues at: 'image' ifAbsent: []
]
