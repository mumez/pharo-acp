"
I represent the parameters of a session/close request.

Responsibility:
- I identify the session to close (the 'sessionId' field is inherited)

Collaborators:
- ACPClientConnection: builds me via #closeSessionBy:
- ACPRequest: converts me to the request params dictionary
- ACPSessionIdParams: my superclass
"
Class {
	#name : 'ACPCloseSessionParams',
	#superclass : 'ACPSessionIdParams',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}
