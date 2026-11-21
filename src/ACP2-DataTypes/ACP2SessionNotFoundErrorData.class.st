"
I represent the data of a -32002 (Resource not found) error answered for a session that does not exist or is not active.

Responsibility:
- I decode the session ID the failed request named

Collaborators:
- ACP2RequestError: creates me from its data (#sessionNotFoundData) and builds me for #sessionNotFound:
- ACP2Values: my superclass

Public API:
- sessionId / sessionId: - the session ID from the request
"
Class {
	#name : 'ACP2SessionNotFoundErrorData',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2SessionNotFoundErrorData >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionNotFoundErrorData >> sessionId: aString [

	self rawValues at: 'sessionId' put: aString
]
