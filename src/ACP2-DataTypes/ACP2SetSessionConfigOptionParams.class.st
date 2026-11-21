"
I represent the parameters of a session/set_config_option request.

Responsibility:
- I identify the session ('sessionId') and the configuration option ('configId') to change
- I carry the new value together with its value type ('type'): 'id' for a select option's value ID, 'boolean' for a boolean option

Collaborators:
- ACP2ClientConnection: builds me via #setConfigOptionBy:
- ACP2Request: converts me to the request params dictionary
- ACP2Values: my superclass

Public API:
- sessionId / sessionId:, configId / configId: - the target session and option
- idValue: / booleanValue: - set the value together with the matching type
- type / type:, value / value: - raw access, e.g. for custom ('_'-prefixed) value types
"
Class {
	#name : 'ACP2SetSessionConfigOptionParams',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2SetSessionConfigOptionParams >> booleanValue: aBoolean [

	self type: 'boolean'.
	self value: aBoolean
]

{ #category : 'accessing' }
ACP2SetSessionConfigOptionParams >> configId [

	^ self rawValues at: 'configId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SetSessionConfigOptionParams >> configId: aString [

	self rawValues at: 'configId' put: aString
]

{ #category : 'accessing' }
ACP2SetSessionConfigOptionParams >> idValue: aString [

	self type: 'id'.
	self value: aString
]

{ #category : 'accessing' }
ACP2SetSessionConfigOptionParams >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SetSessionConfigOptionParams >> sessionId: aString [

	self rawValues at: 'sessionId' put: aString
]

{ #category : 'accessing' }
ACP2SetSessionConfigOptionParams >> type [

	^ self rawValues at: 'type' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SetSessionConfigOptionParams >> type: aString [

	self rawValues at: 'type' put: aString
]

{ #category : 'accessing' }
ACP2SetSessionConfigOptionParams >> value [

	^ self rawValues at: 'value' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SetSessionConfigOptionParams >> value: anObject [

	self rawValues at: 'value' put: anObject
]
