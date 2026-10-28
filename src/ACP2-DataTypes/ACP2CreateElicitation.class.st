"
I represent an elicitation/create request: the agent asks the user for input, either through a form or by visiting a URL.

Responsibility:
- I decode the request params: mode, message, scope (session/tool call or request), and the mode-specific fields
- I create the matching response object via #makeResponse

Collaborators:
- ACP2ElicitationSchema: the form definition in 'requestedSchema' (form mode)
- ACP2CreateElicitationResponse: created by #makeResponse
- ACP2Values: my superclass

Public API:
- mode / isForm / isUrl - the elicitation mode ('form', 'url', or a custom/future value)
- message - human-readable description of the requested input
- sessionId / toolCallId / isSessionScoped - session scope (toolCallId is optional)
- requestId / isRequestScoped - request scope (outside of a session, e.g. during authentication)
- requestedSchema - ACP2ElicitationSchema (form mode), or nil
- elicitationId / url / urlHost - URL mode fields (urlHost is nil for a malformed URL)
- makeResponse - a new ACP2CreateElicitationResponse

Implementation Points:
- For URL mode, the client MUST show the full URL and the target host (#urlHost) and get the user's
  consent before opening it; it MUST NOT prefetch or open it automatically
- Form mode must not be used for secrets; an agent that needs them uses URL mode
"
Class {
	#name : 'ACP2CreateElicitation',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2CreateElicitation >> elicitationId [

	^ self rawValues at: 'elicitationId' ifAbsent: []
]

{ #category : 'testing' }
ACP2CreateElicitation >> isForm [

	^ self mode = 'form'
]

{ #category : 'testing' }
ACP2CreateElicitation >> isRequestScoped [

	^ self requestId notNil
]

{ #category : 'testing' }
ACP2CreateElicitation >> isSessionScoped [

	^ self sessionId notNil
]

{ #category : 'testing' }
ACP2CreateElicitation >> isUrl [

	^ self mode = 'url'
]

{ #category : 'factory' }
ACP2CreateElicitation >> makeResponse [

	^ ACP2CreateElicitationResponse new
]

{ #category : 'accessing' }
ACP2CreateElicitation >> message [

	^ self rawValues at: 'message' ifAbsent: []
]

{ #category : 'accessing' }
ACP2CreateElicitation >> mode [

	^ self rawValues at: 'mode' ifAbsent: []
]

{ #category : 'accessing' }
ACP2CreateElicitation >> requestId [

	^ self rawValues at: 'requestId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2CreateElicitation >> requestedSchema [

	^ (self rawValues at: 'requestedSchema' ifAbsent: [ nil ]) ifNotNil: [ :dict |
		  ACP2ElicitationSchema fromDictionary: dict ]
]

{ #category : 'accessing' }
ACP2CreateElicitation >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2CreateElicitation >> toolCallId [

	^ self rawValues at: 'toolCallId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2CreateElicitation >> url [

	^ self rawValues at: 'url' ifAbsent: []
]

{ #category : 'accessing' }
ACP2CreateElicitation >> urlHost [
	"The host of #url, or nil when there is no URL or it cannot be parsed (url is agent input)."

	^ self url ifNotNil: [ :aString |
		  [ aString asZnUrl host ]
			  on: Error
			  do: [ :e | e return: nil ] ]
]
