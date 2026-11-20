"
I represent the ACP v2 response to session/prompt.

Responsibility:
- I acknowledge that the user prompt was inserted into the conversation, and carry its messageId
- I do NOT report the end of the turn: processing and completion arrive as state_update session updates

Collaborators:
- ACP2ClientConnection: creates me from the session/prompt result
- ACP2SessionUpdate: the matching user message update carries the same messageId
- ACP2Values: my superclass

Public API:
- messageId - identifier of the inserted user message
"
Class {
	#name : 'ACP2PromptResponse',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2PromptResponse >> messageId [

	^ self rawValues at: 'messageId' ifAbsent: []
]
