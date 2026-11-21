"
I represent the response to a session/set_config_option request.

Responsibility:
- I expose the agent's complete, updated list of configuration options ('configOptions'), which replaces any list the client held before

Collaborators:
- ACP2ClientConnection: creates me from the raw result of #setConfigOption:
- ACP2ConfigOption: the typed element of configOptions
- ACP2Values: my superclass

Public API:
- configOptions - the updated options as ACP2ConfigOption instances
"
Class {
	#name : 'ACP2SetSessionConfigOptionResponse',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2SetSessionConfigOptionResponse >> configOptions [

	^ self valuesAt: 'configOptions' typed: ACP2ConfigOption in: self rawValues
]
