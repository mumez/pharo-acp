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

	| processor |
	processor := self connection messageProcessor.

	processor addHandler: (JRPCBlockHandler
			 methodName: ACPMethodSessionUpdate
			 block: [ :params | self handler sessionUpdate: params ]).

	processor addHandler: (JRPCBlockHandler
			 methodName: ACPMethodRequestPermission
			 block: [ :params | self handler requestPermission: params ]).

	"Optional handlers"
	processor addHandler: (JRPCBlockHandler
			 methodName: ACPMethodReadTextFile
			 block: [ :params | self handler readTextFile: params ]).

	processor addHandler: (JRPCBlockHandler
			 methodName: ACPMethodWriteTextFile
			 block: [ :params | self handler writeTextFile: params ]).

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
ACPClientConnection >> authenticate: aDictionary [

	^ self connection sendRequest: ACPMethodAuthenticate params: aDictionary
]

{ #category : 'api' }
ACPClientConnection >> cancel: aDictionary [

	^ self connection sendRequest: ACPMethodSessionCancel params: aDictionary
]

{ #category : 'api' }
ACPClientConnection >> initialize: capabilities [

	| result |
	result := self connection
		          sendRequest: ACPMethodInitialize
		          params: {
				          ('capabilities' -> capabilities).
				          ('protocolVersion' -> ACPProtocolVersion) } asDictionary.
	self agentInfo: (result at: 'agent' ifAbsent: [ Dictionary new ]).
	^ result
]

{ #category : 'api' }
ACPClientConnection >> loadSession: aDictionary [

	^ self connection sendRequest: ACPMethodSessionLoad params: aDictionary
]

{ #category : 'api' }
ACPClientConnection >> newSession: aDictionary [

	^ self connection sendRequest: ACPMethodSessionNew params: aDictionary
]

{ #category : 'api' }
ACPClientConnection >> prompt: aDictionary [

	^ self connection sendRequest: ACPMethodSessionPrompt params: aDictionary
]

{ #category : 'api' }
ACPClientConnection >> setSessionConfigOption: aDictionary [

	^ self connection
		  sendRequest: ACPMethodSessionSetConfigOption
		  params: aDictionary
]

{ #category : 'api' }
ACPClientConnection >> setSessionMode: aDictionary [

	^ self connection
		  sendRequest: ACPMethodSessionSetMode
		  params: aDictionary
]

{ #category : 'api' }
ACPClientConnection >> setSessionModel: aDictionary [

	^ self connection
		  sendRequest: ACPMethodSessionSetModel
		  params: aDictionary
]
