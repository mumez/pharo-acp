"
I implement the ACP (Agent Client Protocol) method layer on top of a bidirectional JSON-RPC connection.

Responsibility:
- I provide typed methods for every ACP client-to-agent request: initialize, newSession, loadSession, prompt, cancel, authenticate, logout, closeSession, deleteSession, setSessionMode/Model/ConfigOption
- I register server-side callback handlers for agent-initiated requests: session updates, permission requests, terminal/file operations, and elicitation
- I remember the client capabilities sent in #initialize:, and reject elicitation requests for modes they do not advertise
- I translate raw Dictionary results into typed ACPDataTypes response objects

Collaborators:
- ACPConnection: my underlying JSON-RPC engine; I call #sendRequest:params: and #sendNotification:params: on it
- ACPClientHandler: I delegate incoming agent callbacks (sessionUpdate:, requestPermission:, terminal, file ops) to it
- ACPRequest: I use it to construct method + params pairs for each ACP operation
- ACPConstants (SharedPool): I reference ACP method name constants

Public API and Key Messages:
- #initialize: - handshake with agent; stores ACPInitializeResponse in agentInfo and the sent client capabilities in clientCapabilities
- #newSession: / #newSessionBy: - start a new agent session
- #prompt: / #promptBy: - send a prompt; blocks until the agent responds
- #cancel: / #cancelBy: - cancel the current prompt (notification, no response)
- #loadSession: - resume a prior session by ID
- #closeSession: / #closeSessionBy: - cancel in-flight work and free a session's resources
- #deleteSession: / #deleteSessionBy: - remove a session from the agent's history
- #logout - end the authenticated state

Internal Representation:
- connection - the ACPConnection used for transport
- handler - the ACPClientHandler that receives agent-initiated callbacks
- agentInfo - ACPInitializeResponse cached from the initialize handshake
- clientCapabilities - ACPClientCapabilities sent in the initialize handshake (nothing advertised before it)

Implementation Points:
- Each ""By:"" variant accepts a builder block for constructing typed params objects
- Handler registration happens at creation time via #registerHandlers
- Terminal and file operation defaults signal ACPRequestError methodNotFound; subclass ACPClientHandler to override
"
Class {
	#name : 'ACPClientConnection',
	#superclass : 'Object',
	#instVars : [
		'connection',
		'handler',
		'agentInfo',
		'clientCapabilities'
	],
	#pools : [
		'ACPConstants'
	],
	#category : 'ACP-Client',
	#package : 'ACP-Client'
}

{ #category : 'instance creation' }
ACPClientConnection class >> on: aConnection handler: aHandler [

	^ self new
		  connection: aConnection;
		  handler: aHandler;
		  registerHandlers;
		  yourself
]

{ #category : 'accessing' }
ACPClientConnection >> agentInfo [

	^ agentInfo
]

{ #category : 'accessing' }
ACPClientConnection >> agentInfo: anObject [

	agentInfo := anObject
]

{ #category : 'api' }
ACPClientConnection >> authenticate: aParamsOrDictionary [

	| request |
	request := ACPRequest authenticate: aParamsOrDictionary.
	^ self connection sendRequest: request method params: request params
]

{ #category : 'api - builder' }
ACPClientConnection >> authenticateBy: aBlock [

	^ self authenticate: (ACPAuthenticateParams buildBy: aBlock)
]

{ #category : 'api' }
ACPClientConnection >> cancel: aParamsOrDictionary [

	| request |
	request := ACPRequest cancel: aParamsOrDictionary.
	^ self connection sendNotification: request method params: request params
]

{ #category : 'api - builder' }
ACPClientConnection >> cancelBy: aBlock [

	^ self cancel: (ACPCancelParams buildBy: aBlock)
]

{ #category : 'api' }
ACPClientConnection >> closeSession: aParamsOrDictionary [

	| request |
	request := ACPRequest closeSession: aParamsOrDictionary.
	^ self connection sendRequest: request method params: request params
]

{ #category : 'api - builder' }
ACPClientConnection >> closeSessionBy: aBlock [

	^ self closeSession: (ACPCloseSessionParams buildBy: aBlock)
]

{ #category : 'accessing' }
ACPClientConnection >> clientCapabilities [

	^ clientCapabilities ifNil: [ clientCapabilities := ACPClientCapabilities new ]
]

{ #category : 'accessing' }
ACPClientConnection >> clientCapabilities: anACPClientCapabilities [

	clientCapabilities := anACPClientCapabilities
]

{ #category : 'accessing' }
ACPClientConnection >> connection [

	^ connection
]

{ #category : 'accessing' }
ACPClientConnection >> connection: anObject [

	connection := anObject
]

{ #category : 'api' }
ACPClientConnection >> deleteSession: aParamsOrDictionary [

	| request |
	request := ACPRequest deleteSession: aParamsOrDictionary.
	^ self connection sendRequest: request method params: request params
]

{ #category : 'api - builder' }
ACPClientConnection >> deleteSessionBy: aBlock [

	^ self deleteSession: (ACPDeleteSessionParams buildBy: aBlock)
]

{ #category : 'accessing' }
ACPClientConnection >> handler [

	^ handler
]

{ #category : 'accessing' }
ACPClientConnection >> handler: anObject [

	handler := anObject
]

{ #category : 'api' }
ACPClientConnection >> initialize: aParamsOrDictionary [

	| request result |
	request := ACPRequest initialize: aParamsOrDictionary.
	self clientCapabilities: (ACPClientCapabilities fromDictionary:
			 ((request params at: 'clientCapabilities' ifAbsent: [ nil ]) ifNil: [ Dictionary new ]) copy).
	result := self connection sendRequest: request method params: request params.
	self agentInfo: (ACPInitializeResponse fromDictionary: result).
	^ self agentInfo
]

{ #category : 'api - builder' }
ACPClientConnection >> initializeBy: aBlock [

	^ self initialize: (ACPInitializeParams buildBy: aBlock)
]

{ #category : 'api' }
ACPClientConnection >> listSessions: aParamsOrDictionary [

	| request result |
	request := ACPRequest listSessions: aParamsOrDictionary.
	result := self connection sendRequest: request method params: request params.
	^ ACPListSessionsResponse fromDictionary: result
]

{ #category : 'api - builder' }
ACPClientConnection >> listSessionsBy: aBlock [

	^ self listSessions: (ACPListSessionsParams buildBy: aBlock)
]

{ #category : 'api' }
ACPClientConnection >> logout [

	| request |
	request := ACPRequest logout.
	^ self connection sendRequest: request method params: request params
]

{ #category : 'api' }
ACPClientConnection >> loadSession: aParamsOrDictionary [

	| request result |
	request := ACPRequest loadSession: aParamsOrDictionary.
	result := self connection sendRequest: request method params: request params.
	^ ACPSessionSetupResponse fromDictionary: result
]

{ #category : 'api - builder' }
ACPClientConnection >> loadSessionBy: aBlock [

	^ self loadSession: (ACPSessionParams buildBy: aBlock)
]

{ #category : 'api' }
ACPClientConnection >> newSession: aParamsOrDictionary [

	| request result |
	request := ACPRequest newSession: aParamsOrDictionary.
	result := self connection sendRequest: request method params: request params.
	^ ACPSessionSetupResponse fromDictionary: result
]

{ #category : 'api - builder' }
ACPClientConnection >> newSessionBy: aBlock [

	^ self newSession: (ACPSessionParams buildBy: aBlock)
]

{ #category : 'api' }
ACPClientConnection >> prompt: aParamsOrDictionary [

	| request result |
	request := ACPRequest prompt: aParamsOrDictionary.
	result := self connection sendRequest: request method params: request params.
	^ ACPPromptResponse fromDictionary: result
]

{ #category : 'api - builder' }
ACPClientConnection >> promptBy: aBlock [

	^ self prompt: (ACPPromptParams buildBy: aBlock)
]

{ #category : 'api' }
ACPClientConnection >> resumeSession: aParamsOrDictionary [

	| request result |
	request := ACPRequest resumeSession: aParamsOrDictionary.
	result := self connection sendRequest: request method params: request params.
	^ ACPSessionSetupResponse fromDictionary: result
]

{ #category : 'api - builder' }
ACPClientConnection >> resumeSessionBy: aBlock [

	^ self resumeSession: (ACPSessionParams buildBy: aBlock)
]

{ #category : 'initialization' }
ACPClientConnection >> registerFileHandlers [

	| processor |
	processor := self connection messageProcessor.

	processor addHandler: (JRPCBlockHandler
			 methodName: ACPMethodReadTextFile
			 block: [ :params | self handler readTextFile: params ]).

	processor addHandler: (JRPCBlockHandler
			 methodName: ACPMethodWriteTextFile
			 block: [ :params | self handler writeTextFile: params ])
]

{ #category : 'private' }
ACPClientConnection >> handleCreateElicitation: aDictionary [
	"Reject form/url requests for modes the client did not advertise (-32602); pass other modes to the handler."

	| request |
	request := ACPCreateElicitation fromDictionary: aDictionary.
	(self isElicitationModeAllowed: request) ifFalse: [
		^ (ACPRequestError invalidParams:
			   'Elicitation mode not advertised by the client: ' , request mode printString) signal ].
	^ (self handler createElicitation: request) asDictionary
]

{ #category : 'private' }
ACPClientConnection >> isElicitationModeAllowed: anACPCreateElicitation [
	"Form and URL modes must have been advertised; other (custom) modes are left to the handler."

	anACPCreateElicitation isForm ifTrue: [
		^ self clientCapabilities elicitation isFormSupported ].
	anACPCreateElicitation isUrl ifTrue: [
		^ self clientCapabilities elicitation isUrlSupported ].
	^ true
]

{ #category : 'initialization' }
ACPClientConnection >> registerElicitationHandlers [

	| processor |
	processor := self connection messageProcessor.

	processor addHandler: (JRPCBlockHandler
			 methodName: ACPMethodElicitationCreate
			 block: [ :params | self handleCreateElicitation: params ]).

	processor addHandler: (JRPCBlockHandler
			 methodName: ACPMethodElicitationComplete
			 block: [ :params | self handler completeElicitation: (ACPCompleteElicitation fromDictionary: params) ])
]

{ #category : 'initialization' }
ACPClientConnection >> registerHandlers [

	self registerSessionHandlers.
	self registerFileHandlers.
	self registerTerminalHandlers.
	self registerElicitationHandlers
]

{ #category : 'initialization' }
ACPClientConnection >> registerSessionHandlers [

	| processor |
	processor := self connection messageProcessor.

	processor addHandler: (JRPCBlockHandler
			 methodName: ACPMethodSessionUpdate
			 block: [ :params | self handler sessionUpdate: (ACPSessionUpdate fromDictionary: params) ]).

	processor addHandler: (JRPCBlockHandler
			 methodName: ACPMethodRequestPermission
			 block: [ :params | (self handler requestPermission: (ACPRequestPermission fromDictionary: params)) asDictionary ])
]

{ #category : 'initialization' }
ACPClientConnection >> registerTerminalHandlers [

	| processor |
	processor := self connection messageProcessor.

	processor addHandler: (JRPCBlockHandler
			 methodName: ACPMethodTerminalCreate
			 block: [ :params | self handler createTerminal: params ]).

	processor addHandler: (JRPCBlockHandler
			 methodName: ACPMethodTerminalOutput
			 block: [ :params | self handler terminalOutput: params ]).

	processor addHandler: (JRPCBlockHandler
			 methodName: ACPMethodTerminalWaitForExit
			 block: [ :params | self handler waitForTerminalExit: params ]).

	processor addHandler: (JRPCBlockHandler
			 methodName: ACPMethodTerminalKill
			 block: [ :params | self handler killTerminal: params ]).

	processor addHandler: (JRPCBlockHandler
			 methodName: ACPMethodTerminalRelease
			 block: [ :params | self handler releaseTerminal: params ])
]

{ #category : 'api' }
ACPClientConnection >> setSessionConfigOption: aParamsOrDictionary [

	| request result |
	request := ACPRequest setSessionConfigOption: aParamsOrDictionary.
	result := self connection sendRequest: request method params: request params.
	^ ACPBaseSessionResponse fromDictionary: result
]

{ #category : 'api - builder' }
ACPClientConnection >> setSessionConfigOptionBy: aBlock [

	^ self setSessionConfigOption: (ACPSetSessionConfigOptionParams buildBy: aBlock)
]

{ #category : 'api' }
ACPClientConnection >> setSessionMode: aParamsOrDictionary [

	| request |
	request := ACPRequest setSessionMode: aParamsOrDictionary.
	^ self connection sendRequest: request method params: request params
]

{ #category : 'api - builder' }
ACPClientConnection >> setSessionModeBy: aBlock [

	^ self setSessionMode: (ACPSetSessionModeParams buildBy: aBlock)
]

{ #category : 'api' }
ACPClientConnection >> setSessionModel: aParamsOrDictionary [

	| request |
	request := ACPRequest setSessionModel: aParamsOrDictionary.
	^ self connection sendRequest: request method params: request params
]

{ #category : 'api - builder' }
ACPClientConnection >> setSessionModelBy: aBlock [

	^ self setSessionModel: (ACPSetSessionModelParams buildBy: aBlock)
]
