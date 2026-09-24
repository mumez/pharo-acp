"
I represent an elicitation/create request: the agent asks the user for input, either through a form or by visiting a URL.

Responsibility:
- I decode the request params: mode, message, scope (session/tool call or request), and the mode-specific fields
- I create the matching response object via #makeResponse

Collaborators:
- ACPElicitationSchema: the form definition in 'requestedSchema' (form mode)
- ACPCreateElicitationResponse: created by #makeResponse
- ACPValues: my superclass

Public API:
- mode / isForm / isUrl - the elicitation mode ('form', 'url', or a custom/future value)
- message - human-readable description of the requested input
- sessionId / toolCallId / isSessionScoped - session scope (toolCallId is optional)
- requestId / isRequestScoped - request scope (outside of a session, e.g. during authentication)
- requestedSchema - ACPElicitationSchema (form mode), or nil
- elicitationId / url / urlHost - URL mode fields (urlHost is nil for a malformed URL)
- makeResponse - a new ACPCreateElicitationResponse

Implementation Points:
- For URL mode, the client MUST show the full URL and the target host (#urlHost) and get the user's
  consent before opening it; it MUST NOT prefetch or open it automatically
- Form mode must not be used for secrets; an agent that needs them uses URL mode
"
Class {
	#name : 'ACPCreateElicitation',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPCreateElicitation >> elicitationId [

	^ self rawValues at: 'elicitationId' ifAbsent: []
]

{ #category : 'testing' }
ACPCreateElicitation >> isForm [

	^ self mode = 'form'
]

{ #category : 'testing' }
ACPCreateElicitation >> isRequestScoped [

	^ self requestId notNil
]

{ #category : 'testing' }
ACPCreateElicitation >> isSessionScoped [

	^ self sessionId notNil
]

{ #category : 'testing' }
ACPCreateElicitation >> isUrl [

	^ self mode = 'url'
]

{ #category : 'factory' }
ACPCreateElicitation >> makeResponse [

	^ ACPCreateElicitationResponse new
]

{ #category : 'accessing' }
ACPCreateElicitation >> message [

	^ self rawValues at: 'message' ifAbsent: []
]

{ #category : 'accessing' }
ACPCreateElicitation >> mode [

	^ self rawValues at: 'mode' ifAbsent: []
]

{ #category : 'accessing' }
ACPCreateElicitation >> requestId [

	^ self rawValues at: 'requestId' ifAbsent: []
]

{ #category : 'accessing' }
ACPCreateElicitation >> requestedSchema [

	^ (self rawValues at: 'requestedSchema' ifAbsent: [ nil ]) ifNotNil: [ :dict |
		  ACPElicitationSchema fromDictionary: dict ]
]

{ #category : 'accessing' }
ACPCreateElicitation >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACPCreateElicitation >> toolCallId [

	^ self rawValues at: 'toolCallId' ifAbsent: []
]

{ #category : 'accessing' }
ACPCreateElicitation >> url [

	^ self rawValues at: 'url' ifAbsent: []
]

{ #category : 'accessing' }
ACPCreateElicitation >> urlHost [
	"The host of #url, or nil when there is no URL or it cannot be parsed (url is agent input)."

	^ self url ifNotNil: [ :aString |
		  [ aString asZnUrl host ]
			  on: Error
			  do: [ :e | e return: nil ] ]
]
