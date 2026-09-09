"
I am the abstract base class defining the callback interface for agent-initiated requests under ACP v2.

Responsibility:
- I declare the required callback that subclasses must implement: #sessionUpdate:
- I provide a default auto-approving implementation for #requestPermission:, which subclasses may override

Collaborators:
- ACP2ClientConnection: registers my methods as handlers and calls them when the agent sends requests or notifications
- ACP2SessionUpdate: passed to #sessionUpdate: on each agent progress notification
- ACP2RequestPermission: passed to #requestPermission:; the method must return an ACP2RequestPermissionResponse

Public API and Key Messages:
- #sessionUpdate: - called on each session/update notification (streaming progress); subclasses must implement
- #requestPermission: - called when the agent requests user permission for a tool; defaults to auto-approving

Implementation Points:
- Subclass and implement at minimum #sessionUpdate:
- Override #requestPermission: only if interactive approval is required
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
