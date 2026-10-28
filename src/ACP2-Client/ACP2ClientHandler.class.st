"
I am the abstract base class defining the callback interface for agent-initiated requests under ACP v2.

Responsibility:
- I declare the required callback that subclasses must implement: #sessionUpdate:
- I provide a default auto-approving implementation for #requestPermission:, which subclasses may override

Collaborators:
- ACP2ClientConnection: registers my methods as handlers and calls them when the agent sends requests or notifications
- ACP2SessionUpdate: passed to #sessionUpdate: on each agent progress notification
- ACP2RequestPermission: passed to #requestPermission:; the method must return an ACP2RequestPermissionResponse
- ACP2CreateElicitation / ACP2CompleteElicitation: passed to the elicitation callbacks

Public API and Key Messages:
- #sessionUpdate: - called on each session/update notification (streaming progress); subclasses must implement
- #requestPermission: - called when the agent requests user permission for a tool; defaults to auto-approving
- #createElicitation: - ask the user for input (form or URL mode); must return an ACP2CreateElicitationResponse; default signals invalidParams (-32602)
- #completeElicitation: - a URL-mode elicitation finished; default ignores it

Implementation Points:
- Subclass and implement at minimum #sessionUpdate:
- Override #requestPermission: only if interactive approval is required
- To support elicitation, override #createElicitation: (and #completeElicitation: for URL mode) and advertise
  the implemented modes, e.g. initializeBy: [ :p | p capabilities elicitation enableForm ]
- See ACP2TranscriptHandler for a minimal concrete example
"
Class {
	#name : 'ACP2ClientHandler',
	#superclass : 'Object',
	#pools : [
		'ACP2Constants'
	],
	#category : 'ACP2-Client',
	#package : 'ACP2-Client'
}

{ #category : 'agent-callbacks - elicitation' }
ACP2ClientHandler >> completeElicitation: anACPCompleteElicitation [
	"Notification from the agent that the URL-mode elicitation with anACPCompleteElicitation elicitationId finished.
	 Unknown or already-completed IDs must be ignored."

	^ self
]

{ #category : 'agent-callbacks - elicitation' }
ACP2ClientHandler >> createElicitation: anACPCreateElicitation [
	"Request from the agent to ask the user for input. Must return an ACP2CreateElicitationResponse
	 (see anACPCreateElicitation makeResponse): accept: with the submitted content, decline, or cancel.
	 Only called for modes advertised in the client capabilities (other form/url requests are rejected
	 with -32602 before reaching here).
	 - Form mode: render anACPCreateElicitation requestedSchema, pre-populate defaults, validate the input.
	 - URL mode: show the full URL and its host (#urlHost), and open it only after the user consents;
	   never prefetch it or open it automatically.
	 While waiting for the user, use ACP2CancellationToken current (e.g. #whenCancelledDo:) to stop
	 when the agent cancels the request."

	^ (ACP2RequestError invalidParams: 'Elicitation is not supported by this client') signal
]

{ #category : 'agent-callbacks' }
ACP2ClientHandler >> requestPermission: anACPRequestPermission [
	"Request from agent for user permission (e.g. tool execution).
	anACPRequestPermission is ACP2RequestPermission.
	Must return an ACP2RequestPermissionResponse. Defaults to auto-approving."

	^ ACP2RequestPermissionResponse selected: 'allow'
]

{ #category : 'agent-callbacks' }
ACP2ClientHandler >> sessionUpdate: aSessionUpdate [
	"aSessionUpdate is ACP2SessionUpdate"

	^ self subclassResponsibility
]
