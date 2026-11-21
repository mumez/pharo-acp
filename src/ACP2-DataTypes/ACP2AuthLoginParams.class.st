"
I represent the parameters of an auth/login request.

Responsibility:
- I name the authentication method the agent should use ('methodId'), one of the authMethods it advertised in its initialize response

Collaborators:
- ACP2ClientConnection: builds me via #loginBy:
- ACP2Request: converts me to the request params dictionary
- ACP2Values: my superclass

Public API:
- methodId / methodId: - the ID of the advertised authentication method
"
Class {
	#name : 'ACP2AuthLoginParams',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2AuthLoginParams >> methodId [

	^ self rawValues at: 'methodId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2AuthLoginParams >> methodId: aString [

	self rawValues at: 'methodId' put: aString
]
