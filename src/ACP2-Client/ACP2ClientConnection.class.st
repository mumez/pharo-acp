"
I implement the ACP (Agent Client Protocol) v2 method layer on top of a bidirectional JSON-RPC connection.

Responsibility:
- I provide typed methods for every ACP v2 client-to-agent request: initialize, newSession, listSessions, resumeSession, closeSession, deleteSession, prompt, cancel, logout
- I register server-side callback handlers for agent-initiated requests: session updates, permission requests, and elicitation
- I remember the client capabilities sent in #initialize:, and reject elicitation requests for modes they do not advertise
- I translate raw Dictionary results into typed ACP2DataTypes response objects

Collaborators:
- ACP2Connection: my underlying JSON-RPC engine; I call #sendRequest:params: and #sendNotification:params: on it
- ACP2ClientHandler: I delegate incoming agent callbacks (sessionUpdate:, requestPermission:) to it
- ACP2Request: I use it to construct method + params pairs for each ACP operation
- ACP2Constants (SharedPool): I reference ACP method name constants

Public API and Key Messages:
- #initialize: - handshake with agent; stores ACP2InitializeResponse in agentInfo and the sent client capabilities in clientCapabilities
- #newSession: / #newSessionBy: - start a new agent session
- #prompt: / #promptBy: - send a prompt; returns once the agent's request handler completes (the turn's outcome arrives asynchronously via a session/update state_update notification)
- #cancel: / #cancelBy: - cancel the current prompt (notification, no response)
- #resumeSession: / #listSessions: / #logout: - remaining v2 session/auth lifecycle operations
- #closeSession: / #closeSessionBy: - cancel in-flight work and free a session's resources
- #deleteSession: / #deleteSessionBy: - remove a session from the agent's history

Internal Representation:
- connection - the ACP2Connection used for transport
- handler - the ACP2ClientHandler that receives agent-initiated callbacks
- agentInfo - ACP2InitializeResponse cached from the initialize handshake
- clientCapabilities - ACP2ClientCapabilities sent in the initialize handshake (nothing advertised before it)

Implementation Points:
- Each ""By:"" variant accepts a builder block for constructing typed params objects
- Handler registration happens at creation time via #registerHandlers
- Incoming session/update notifications are unwrapped to their 'update' payload before being wrapped as ACP2SessionUpdate
"
Class {
	#name : 'ACP2ClientConnection',
	#superclass : 'Object',
	#instVars : [
		'connection',
		'handler',
		'agentInfo',
		'clientCapabilities'
	],
	#pools : [
		'ACP2Constants'
	],
	#category : 'ACP2-Client',
	#package : 'ACP2-Client'
}

{ #category : 'instance creation' }
ACP2ClientConnection class >> on: aConnection handler: aHandler [

	^ self new
		  connection: aConnection;
		  handler: aHandler;
		  registerHandlers;
		  yourself
]

{ #category : 'accessing' }
ACP2ClientConnection >> agentInfo [

	^ agentInfo
]

{ #category : 'accessing' }
ACP2ClientConnection >> agentInfo: anObject [

	agentInfo := anObject
]

{ #category : 'api' }
ACP2ClientConnection >> cancel: aParamsOrDictionary [

	| request |
	request := ACP2Request cancel: aParamsOrDictionary.
	^ self connection sendNotification: request method params: request params
]

{ #category : 'api - builder' }
ACP2ClientConnection >> cancelBy: aBlock [

	^ self cancel: (ACP2CancelParams buildBy: aBlock)
]

{ #category : 'api' }
ACP2ClientConnection >> closeSession: aParamsOrDictionary [

	| request |
	request := ACP2Request closeSession: aParamsOrDictionary.
	^ self connection sendRequest: request method params: request params
]

{ #category : 'api - builder' }
ACP2ClientConnection >> closeSessionBy: aBlock [

	^ self closeSession: (ACP2CloseSessionParams buildBy: aBlock)
]

{ #category : 'accessing' }
ACP2ClientConnection >> clientCapabilities [

	^ clientCapabilities ifNil: [ clientCapabilities := ACP2ClientCapabilities new ]
]

{ #category : 'accessing' }
ACP2ClientConnection >> clientCapabilities: anACPClientCapabilities [

	clientCapabilities := anACPClientCapabilities
]

{ #category : 'accessing' }
ACP2ClientConnection >> connection [

	^ connection
]

{ #category : 'accessing' }
ACP2ClientConnection >> connection: anObject [

	connection := anObject
]

{ #category : 'api' }
ACP2ClientConnection >> deleteSession: aParamsOrDictionary [

	| request |
	request := ACP2Request deleteSession: aParamsOrDictionary.
	^ self connection sendRequest: request method params: request params
]

{ #category : 'api - builder' }
ACP2ClientConnection >> deleteSessionBy: aBlock [

	^ self deleteSession: (ACP2DeleteSessionParams buildBy: aBlock)
]

{ #category : 'accessing' }
ACP2ClientConnection >> handler [

	^ handler
]

{ #category : 'accessing' }
ACP2ClientConnection >> handler: anObject [

	handler := anObject
]

{ #category : 'api' }
ACP2ClientConnection >> initialize: aParamsOrDictionary [

	| request result |
	request := ACP2Request initialize: aParamsOrDictionary.
	self clientCapabilities: (ACP2ClientCapabilities fromDictionary:
			 ((request params at: 'capabilities' ifAbsent: [ nil ]) ifNil: [ Dictionary new ]) copy).
	result := self connection sendRequest: request method params: request params.
	self agentInfo: (ACP2InitializeResponse fromDictionary: result).
	^ self agentInfo
]

{ #category : 'api - builder' }
ACP2ClientConnection >> initializeBy: aBlock [

	^ self initialize: (ACP2InitializeParams buildBy: aBlock)
]

{ #category : 'api' }
ACP2ClientConnection >> listSessions: aParamsOrDictionary [

	| request result |
	request := ACP2Request listSessions: aParamsOrDictionary.
	result := self connection sendRequest: request method params: request params.
	^ ACP2ListSessionsResponse fromDictionary: result
]

{ #category : 'api - builder' }
ACP2ClientConnection >> listSessionsBy: aBlock [

	^ self listSessions: (ACP2ListSessionsParams buildBy: aBlock)
]

{ #category : 'api' }
ACP2ClientConnection >> logout: aParamsOrDictionary [

	| request |
	request := ACP2Request logout: aParamsOrDictionary.
	^ self connection sendRequest: request method params: request params
]

{ #category : 'api' }
ACP2ClientConnection >> newSession: aParamsOrDictionary [

	| request result |
	request := ACP2Request newSession: aParamsOrDictionary.
	result := self connection sendRequest: request method params: request params.
	^ ACP2SessionSetupResponse fromDictionary: result
]

{ #category : 'api - builder' }
ACP2ClientConnection >> newSessionBy: aBlock [

	^ self newSession: (ACP2SessionParams buildBy: aBlock)
]

{ #category : 'api' }
ACP2ClientConnection >> prompt: aParamsOrDictionary [

	| request result |
	request := ACP2Request prompt: aParamsOrDictionary.
	result := self connection sendRequest: request method params: request params.
	^ ACP2PromptResponse fromDictionary: result
]

{ #category : 'api - builder' }
ACP2ClientConnection >> promptBy: aBlock [

	^ self prompt: (ACP2PromptParams buildBy: aBlock)
]

{ #category : 'api' }
ACP2ClientConnection >> resumeSession: aParamsOrDictionary [

	| request result |
	request := ACP2Request resumeSession: aParamsOrDictionary.
	result := self connection sendRequest: request method params: request params.
	^ ACP2SessionSetupResponse fromDictionary: result
]

{ #category : 'api - builder' }
ACP2ClientConnection >> resumeSessionBy: aBlock [

	^ self resumeSession: (ACP2SessionResumeParams buildBy: aBlock)
]

{ #category : 'private' }
ACP2ClientConnection >> handleCreateElicitation: aDictionary [
	"Reject form/url requests for modes the client did not advertise (-32602); pass other modes to the handler."

	| request |
	request := ACP2CreateElicitation fromDictionary: aDictionary.
	(self isElicitationModeAllowed: request) ifFalse: [
		^ (ACP2RequestError invalidParams:
			   'Elicitation mode not advertised by the client: ' , request mode printString) signal ].
	^ (self handler createElicitation: request) asDictionary
]

{ #category : 'private' }
ACP2ClientConnection >> isElicitationModeAllowed: anACPCreateElicitation [
	"Form and URL modes must have been advertised; other (custom) modes are left to the handler."

	anACPCreateElicitation isForm ifTrue: [
		^ self clientCapabilities elicitation isFormSupported ].
	anACPCreateElicitation isUrl ifTrue: [
		^ self clientCapabilities elicitation isUrlSupported ].
	^ true
]

{ #category : 'initialization' }
ACP2ClientConnection >> registerElicitationHandlers [

	| processor |
	processor := self connection messageProcessor.

	processor addHandler: (JRPCBlockHandler
			 methodName: ACP2MethodElicitationCreate
			 block: [ :params | self handleCreateElicitation: params ]).

	processor addHandler: (JRPCBlockHandler
			 methodName: ACP2MethodElicitationComplete
			 block: [ :params | self handler completeElicitation: (ACP2CompleteElicitation fromDictionary: params) ])
]

{ #category : 'initialization' }
ACP2ClientConnection >> registerHandlers [

	self registerSessionHandlers.
	self registerElicitationHandlers
]

{ #category : 'initialization' }
ACP2ClientConnection >> registerSessionHandlers [

	| processor |
	processor := self connection messageProcessor.

	processor addHandler: (JRPCBlockHandler
			 methodName: ACP2MethodSessionUpdate
			 block: [ :params | self handler sessionUpdate: (ACP2SessionUpdate fromDictionary: (params at: 'update')) ]).

	processor addHandler: (JRPCBlockHandler
			 methodName: ACP2MethodRequestPermission
			 block: [ :params | (self handler requestPermission: (ACP2RequestPermission fromDictionary: params)) asDictionary ])
]
