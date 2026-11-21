"
I am the common superclass of request parameters that target a session by its ID.

Responsibility:
- I hold the 'sessionId' field shared by session/cancel, session/close, session/delete, tool_call/cancel, and terminal/cancel params

Collaborators:
- ACP2CancelParams, ACP2CloseSessionParams, ACP2DeleteSessionParams: my subclasses that consist only of the session ID
- ACP2CancelToolCallParams, ACP2CancelTerminalParams: my subclasses that add the ID of an item within the session
- ACP2Values: my superclass

Public API:
- sessionId / sessionId: - the target session ID
"
Class {
	#name : 'ACP2SessionIdParams',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2SessionIdParams >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionIdParams >> sessionId: aString [

	self rawValues at: 'sessionId' put: aString
]
