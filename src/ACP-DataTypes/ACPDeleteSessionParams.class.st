"
I represent the parameters of a session/delete request.

Responsibility:
- I hold the ID of the session to delete.

Collaborators:
- ACPClientConnection: builds me via #deleteSessionBy:
- ACPRequest: converts me to the request params dictionary
- ACPValues: my superclass

Public API:
- sessionId / sessionId: - the target session ID
"
Class {
	#name : 'ACPDeleteSessionParams',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPDeleteSessionParams >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACPDeleteSessionParams >> sessionId: aString [

	self rawValues at: 'sessionId' put: aString
]
