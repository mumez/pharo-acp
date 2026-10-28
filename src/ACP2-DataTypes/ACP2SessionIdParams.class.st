"
I am the common superclass of request parameters that consist only of a target session ID.

Responsibility:
- I hold the 'sessionId' field shared by session/cancel, session/close, and session/delete params

Collaborators:
- ACP2CancelParams, ACP2CloseSessionParams, ACP2DeleteSessionParams: my subclasses, one per request
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
