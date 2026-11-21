"
I represent the parameters of a tool_call/cancel request.

Responsibility:
- I identify one tool call ('toolCallId') in a session (the 'sessionId' field is inherited) to cancel

Collaborators:
- ACP2ClientConnection: builds me via #cancelToolCallBy:
- ACP2Request: converts me to the request params dictionary
- ACP2SessionIdParams: my superclass

Public API:
- toolCallId / toolCallId: - the tool call to cancel; it should currently advertise capabilities.cancel (see ACP2ToolCallUpdate>>isCancellable)
"
Class {
	#name : 'ACP2CancelToolCallParams',
	#superclass : 'ACP2SessionIdParams',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2CancelToolCallParams >> toolCallId [

	^ self rawValues at: 'toolCallId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2CancelToolCallParams >> toolCallId: aString [

	self rawValues at: 'toolCallId' put: aString
]
