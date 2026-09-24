"
I represent the parameters of a session/cancel notification.

Responsibility:
- I identify the session whose prompt turn should be cancelled (the 'sessionId' field is inherited)

Collaborators:
- ACPClientConnection: builds me via #cancelBy:
- ACPSessionIdParams: my superclass
"
Class {
	#name : 'ACPCancelParams',
	#superclass : 'ACPSessionIdParams',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}
