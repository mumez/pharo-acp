"
I represent the parameters of a session/close request.

Responsibility:
- I hold the ID of the session to close.

Collaborators:
- ACPClientConnection: builds me via #closeSessionBy:
- ACPRequest: converts me to the request params dictionary
- ACPValues: my superclass

Public API:
- sessionId / sessionId: - the target session ID
"
Class {
	#name : 'ACPCloseSessionParams',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPCloseSessionParams >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACPCloseSessionParams >> sessionId: aString [

	self rawValues at: 'sessionId' put: aString
]
