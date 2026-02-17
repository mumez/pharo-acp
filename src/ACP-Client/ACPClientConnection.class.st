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
	#category : 'ACP-Client'
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
			 block: [ :params | self handler sessionUpdate: params ]).

	processor addHandler: (JRPCBlockHandler
			 methodName: ACPMethodRequestPermission
			 block: [ :params | self handler requestPermission: params ])
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
ACPClientConnection >> authenticate: anAuthenticateRequestOrDictionary [

	^ self connection
		  sendRequest: ACPMethodAuthenticate
		  params: anAuthenticateRequestOrDictionary asDictionary
]

{ #category : 'api' }
ACPClientConnection >> cancel: aCancelNotificationOrDictionary [

	^ self connection
		  sendRequest: ACPMethodSessionCancel
		  params: aCancelNotificationOrDictionary asDictionary
]

{ #category : 'api' }
ACPClientConnection >> initialize: anInitializeRequestOrDictionary [

	| params result |
	params := anInitializeRequestOrDictionary asDictionary.
	result := self connection
		          sendRequest: ACPMethodInitialize
		          params: {
				          ('capabilities' -> params).
				          ('protocolVersion' -> ACPProtocolVersion) } asDictionary.
	self agentInfo: (ACPInitializeResponse fromDictionary: result).
	^ self agentInfo
]

{ #category : 'api' }
ACPClientConnection >> loadSession: aLoadSessionRequestOrDictionary [

	| result |
	result := self connection
		          sendRequest: ACPMethodSessionLoad
		          params: aLoadSessionRequestOrDictionary asDictionary.
	^ ACPLoadSessionResponse fromDictionary: result
]

{ #category : 'api' }
ACPClientConnection >> newSession: aNewSessionRequestOrDictionary [

	| result |
	result := self connection
		          sendRequest: ACPMethodSessionNew
		          params: aNewSessionRequestOrDictionary asDictionary.
	^ ACPNewSessionResponse fromDictionary: result
]

{ #category : 'api' }
ACPClientConnection >> prompt: aPromptRequestOrDictionary [

	| result |
	result := self connection
		          sendRequest: ACPMethodSessionPrompt
		          params: aPromptRequestOrDictionary asDictionary.
	^ ACPPromptResponse fromDictionary: result
]

{ #category : 'api' }
ACPClientConnection >> setSessionConfigOption: aSetSessionConfigOptionRequestOrDictionary [

	^ self connection
		  sendRequest: ACPMethodSessionSetConfigOption
		  params: aSetSessionConfigOptionRequestOrDictionary asDictionary
]

{ #category : 'api' }
ACPClientConnection >> setSessionMode: aSetSessionModeRequestOrDictionary [

	^ self connection
		  sendRequest: ACPMethodSessionSetMode
		  params: aSetSessionModeRequestOrDictionary asDictionary
]

{ #category : 'api' }
ACPClientConnection >> setSessionModel: aSetSessionModelRequestOrDictionary [

	^ self connection
		  sendRequest: ACPMethodSessionSetModel
		  params: aSetSessionModelRequestOrDictionary asDictionary
]
