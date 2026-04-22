"
I implement the ACP (Agent Client Protocol) method layer on top of a bidirectional JSON-RPC connection.

Responsibility:
- I provide typed methods for every ACP client-to-agent request: initialize, newSession, loadSession, prompt, cancel, authenticate, setSessionMode/Model/ConfigOption
- I register server-side callback handlers for agent-initiated requests: session updates, permission requests, and terminal/file operations
- I translate raw Dictionary results into typed ACPDataTypes response objects

Collaborators:
- ACPConnection: my underlying JSON-RPC engine; I call #sendRequest:params: and #sendNotification:params: on it
- ACPClientHandler: I delegate incoming agent callbacks (sessionUpdate:, requestPermission:, terminal, file ops) to it
- ACPRequest: I use it to construct method + params pairs for each ACP operation
- ACPConstants (SharedPool): I reference ACP method name constants

Public API and Key Messages:
- #initialize: - handshake with agent; stores ACPInitializeResponse in agentInfo
- #newSession: / #newSessionBy: - start a new agent session
- #prompt: / #promptBy: - send a prompt; blocks until the agent responds
- #cancel: / #cancelBy: - cancel the current prompt (notification, no response)
- #loadSession: - resume a prior session by ID

Internal Representation:
- connection - the ACPConnection used for transport
- handler - the ACPClientHandler that receives agent-initiated callbacks
- agentInfo - ACPInitializeResponse cached from the initialize handshake

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
		'agentInfo'
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

{ #category : 'accessing' }
ACPClientConnection >> connection [

	^ connection
]

{ #category : 'accessing' }
ACPClientConnection >> connection: anObject [

	connection := anObject
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
ACPClientConnection >> loadSession: aParamsOrDictionary [

	| request result |
	request := ACPRequest loadSession: aParamsOrDictionary.
	result := self connection sendRequest: request method params: request params.
	^ ACPLoadSessionResponse fromDictionary: result
]

{ #category : 'api - builder' }
ACPClientConnection >> loadSessionBy: aBlock [

	^ self loadSession: (ACPLoadSessionParams buildBy: aBlock)
]

{ #category : 'api' }
ACPClientConnection >> newSession: aParamsOrDictionary [

	| request result |
	request := ACPRequest newSession: aParamsOrDictionary.
	result := self connection sendRequest: request method params: request params.
	^ ACPNewSessionResponse fromDictionary: result
]

{ #category : 'api - builder' }
ACPClientConnection >> newSessionBy: aBlock [

	^ self newSession: (ACPNewSessionParams buildBy: aBlock)
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

{ #category : 'initialization' }
ACPClientConnection >> registerHandlers [

	self registerSessionHandlers.
	self registerFileHandlers.
	self registerTerminalHandlers
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

	| request |
	request := ACPRequest setSessionConfigOption: aParamsOrDictionary.
	^ self connection sendRequest: request method params: request params
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
