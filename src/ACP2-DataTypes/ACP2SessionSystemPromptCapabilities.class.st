"
I represent the agent's support for client-provided system prompts (ACP v2 `session.systemPrompt`).

Responsibility:
- My presence means the agent accepts 'append' mode; {} is a valid, fully meaningful value
- I record extra delivery modes the agent supports under 'mode' (currently only 'override')

Collaborators:
- ACP2AgentCapabilities: creates me from its 'session' dictionary via #systemPromptCapabilities
- ACP2ClientConnection: asks me whether a system prompt mode may be sent
- ACP2Values: my superclass

Public API:
- isModeSupported: - whether a mode string may be sent ('append' always; others only when advertised)
- isOverrideSupported - whether 'override' mode is advertised
- enableOverride - advertise 'override' mode
- mode - raw mode-capabilities dictionary, or nil
"
Class {
	#name : 'ACP2SessionSystemPromptCapabilities',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'actions' }
ACP2SessionSystemPromptCapabilities >> enableOverride [

	(self rawValues at: 'mode' ifAbsentPut: [ Dictionary new ])
		at: 'override'
		put: Dictionary new
]

{ #category : 'testing' }
ACP2SessionSystemPromptCapabilities >> isModeSupported: aModeString [
	"Every agent advertising systemPrompt supports 'append'; other modes must be listed under 'mode'."

	aModeString = 'append' ifTrue: [ ^ true ].
	^ self mode notNil and: [ (self mode at: aModeString ifAbsent: [ nil ]) notNil ]
]

{ #category : 'testing' }
ACP2SessionSystemPromptCapabilities >> isOverrideSupported [

	^ self isModeSupported: 'override'
]

{ #category : 'accessing' }
ACP2SessionSystemPromptCapabilities >> mode [

	^ self rawValues at: 'mode' ifAbsent: []
]
