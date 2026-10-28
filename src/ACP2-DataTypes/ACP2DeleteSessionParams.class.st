"
I represent the parameters of a session/delete request.

Responsibility:
- I identify the session to delete (the 'sessionId' field is inherited)

Collaborators:
- ACP2ClientConnection: builds me via #deleteSessionBy:
- ACP2Request: converts me to the request params dictionary
- ACP2SessionIdParams: my superclass
"
Class {
	#name : 'ACP2DeleteSessionParams',
	#superclass : 'ACP2SessionIdParams',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}
