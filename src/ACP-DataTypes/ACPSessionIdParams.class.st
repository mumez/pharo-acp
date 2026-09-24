"
I am the common superclass of request parameters that consist only of a target session ID.

Responsibility:
- I hold the 'sessionId' field shared by session/cancel, session/close, and session/delete params

Collaborators:
- ACPCancelParams, ACPCloseSessionParams, ACPDeleteSessionParams: my subclasses, one per request
- ACPValues: my superclass

Public API:
- sessionId / sessionId: - the target session ID
"
Class {
	#name : 'ACPSessionIdParams',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPSessionIdParams >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACPSessionIdParams >> sessionId: aString [

	self rawValues at: 'sessionId' put: aString
]
