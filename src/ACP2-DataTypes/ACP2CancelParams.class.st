"
I represent the parameters of a session/cancel notification.

Responsibility:
- I identify the session whose prompt turn should be cancelled (the 'sessionId' field is inherited)

Collaborators:
- ACP2ClientConnection: builds me via #cancelBy:
- ACP2SessionIdParams: my superclass
"
Class {
	#name : 'ACP2CancelParams',
	#superclass : 'ACP2SessionIdParams',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}
