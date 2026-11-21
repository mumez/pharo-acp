"
I represent the parameters of a terminal/cancel request.

Responsibility:
- I identify one terminal ('terminalId') in a session (the 'sessionId' field is inherited) whose process should be stopped

Collaborators:
- ACP2ClientConnection: builds me via #cancelTerminalBy:
- ACP2Request: converts me to the request params dictionary
- ACP2SessionIdParams: my superclass

Public API:
- terminalId / terminalId: - the terminal to stop; it should currently advertise capabilities.cancel in its terminal_update (not checked by the client)
"
Class {
	#name : 'ACP2CancelTerminalParams',
	#superclass : 'ACP2SessionIdParams',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2CancelTerminalParams >> terminalId [

	^ self rawValues at: 'terminalId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2CancelTerminalParams >> terminalId: aString [

	self rawValues at: 'terminalId' put: aString
]
