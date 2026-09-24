"
I represent the parameters of a session/delete request.

Responsibility:
- I identify the session to delete (the 'sessionId' field is inherited)

Collaborators:
- ACPClientConnection: builds me via #deleteSessionBy:
- ACPRequest: converts me to the request params dictionary
- ACPSessionIdParams: my superclass
"
Class {
	#name : 'ACPDeleteSessionParams',
	#superclass : 'ACPSessionIdParams',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}
