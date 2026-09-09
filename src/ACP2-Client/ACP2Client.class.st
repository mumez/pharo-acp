"
I am the user-facing facade for connecting to and communicating with an ACP-compatible coding agent.

Responsibility:
- I assemble and wire together all layers (ACP2ProcessLauncher, ACP2NdJsonTransport, ACP2Connection, ACP2ClientConnection) on #connect
- I delegate all ACP protocol calls (prompt, cancel, newSession, initialize) to my ACP2ClientConnection
- I manage the agent subprocess lifecycle: launch on connect, graceful shutdown on disconnect

Collaborators:
- ACP2ProcessLauncher: I configure and launch the agent subprocess
- ACP2NdJsonTransport: transport layer wrapping the subprocess pipes
- ACP2Connection: bidirectional JSON-RPC engine
- ACP2ClientConnection: ACP protocol methods layer
- ACP2ClientHandler: receives agent-initiated callbacks; defaults to ACP2TranscriptHandler

Public API and Key Messages:
- #connect - launch subprocess and start the read loop
- #disconnect - close connection and terminate subprocess
- #prompt: / #promptBy: - send a prompt to the agent (blocks caller; fork if used from UI)
- #newSession: / #newSessionBy: - start a new session
- #cancel: / #cancelBy: - cancel the current prompt
- #agentCommand:arguments: - configure the agent executable and its arguments
- #workingDirectory: - set the agent working directory
- #environmentAt:put: - add environment variables for the subprocess

Implementation Points:
- #connect is synchronous; call it from a forked process when used from a Pharo UI tool
- #handler defaults to ACP2TranscriptHandler if not set before connecting
- #initialize: and #initializeBy: perform the ACP handshake after connecting
"
Class {
	#name : 'ACP2Client',
	#superclass : 'Object',
	#instVars : [
		'clientConnection',
		'processLauncher',
		'connection',
		'transport',
		'handler'
	],
	#category : 'ACP2-Client',
	#package : 'ACP2-Client'
}

{ #category : 'accessing' }
ACP2Client >> agentCommand: command arguments: args [

	self processLauncher command: command.
	self processLauncher arguments: args
]

{ #category : 'api' }
ACP2Client >> cancel: aParamsOrDictionary [

	^ self clientConnection cancel: aParamsOrDictionary
]

{ #category : 'api - builder' }
ACP2Client >> cancelBy: aBlock [

	^ self clientConnection cancelBy: aBlock
]

{ #category : 'accessing' }
ACP2Client >> clientConnection [

	^ clientConnection
]

{ #category : 'accessing' }
ACP2Client >> clientConnection: anObject [

	clientConnection := anObject
]

{ #category : 'lifecycle' }
ACP2Client >> connect [

	self processLauncher launch.
	self transport: (ACP2NdJsonTransport on: self processLauncher).
	self connection: (ACP2Connection on: self transport).
	self clientConnection: (ACP2ClientConnection on: self connection handler: self handler).
	self connection startReadLoop
]

{ #category : 'accessing' }
ACP2Client >> connection [

	^ connection
]

{ #category : 'accessing' }
ACP2Client >> connection: anObject [

	connection := anObject
]

{ #category : 'defaults' }
ACP2Client >> defaultHandler [

	^ ACP2TranscriptHandler new
]

{ #category : 'lifecycle' }
ACP2Client >> disconnect [

	self connection ifNotNil: [ :c | c close ].
	self processLauncher ifNotNil: [ :p | p terminate ]
]

{ #category : 'accessing' }
ACP2Client >> environmentAt: key put: value [

	self processLauncher envVariables at: key put: value
]

{ #category : 'accessing' }
ACP2Client >> handler [

	^ handler ifNil: [ handler := self defaultHandler ]
]

{ #category : 'accessing' }
ACP2Client >> handler: anObject [

	handler := anObject
]

{ #category : 'initialization' }
ACP2Client >> initialize [

	super initialize.
	processLauncher := ACP2ProcessLauncher new
]

{ #category : 'api' }
ACP2Client >> initialize: aParamsOrDictionary [

	^ self clientConnection initialize: aParamsOrDictionary
]

{ #category : 'api - builder' }
ACP2Client >> initializeBy: aBlock [

	^ self clientConnection initializeBy: aBlock
]

{ #category : 'api' }
ACP2Client >> listSessions: aParamsOrDictionary [

	^ self clientConnection listSessions: aParamsOrDictionary
]

{ #category : 'api - builder' }
ACP2Client >> listSessionsBy: aBlock [

	^ self clientConnection listSessionsBy: aBlock
]

{ #category : 'api' }
ACP2Client >> newSession: aParamsOrDictionary [

	^ self clientConnection newSession: aParamsOrDictionary
]

{ #category : 'api - builder' }
ACP2Client >> newSessionBy: aBlock [

	^ self clientConnection newSessionBy: aBlock
]

{ #category : 'api' }
ACP2Client >> closeSession: aParamsOrDictionary [

	^ self clientConnection closeSession: aParamsOrDictionary
]

{ #category : 'api - builder' }
ACP2Client >> closeSessionBy: aBlock [

	^ self clientConnection closeSessionBy: aBlock
]

{ #category : 'api' }
ACP2Client >> logout: aParamsOrDictionary [

	^ self clientConnection logout: aParamsOrDictionary
]

{ #category : 'api' }
ACP2Client >> resumeSession: aParamsOrDictionary [

	^ self clientConnection resumeSession: aParamsOrDictionary
]

{ #category : 'api - builder' }
ACP2Client >> resumeSessionBy: aBlock [

	^ self clientConnection resumeSessionBy: aBlock
]

{ #category : 'accessing' }
ACP2Client >> processLauncher [

	^ processLauncher
]

{ #category : 'accessing' }
ACP2Client >> processLauncher: anObject [

	processLauncher := anObject
]

{ #category : 'api' }
ACP2Client >> prompt: aParamsOrDictionary [

	^ self clientConnection prompt: aParamsOrDictionary
]

{ #category : 'api - builder' }
ACP2Client >> promptBy: aBlock [

	^ self clientConnection promptBy: aBlock
]

{ #category : 'accessing' }
ACP2Client >> transport [

	^ transport
]

{ #category : 'accessing' }
ACP2Client >> transport: anObject [

	transport := anObject
]

{ #category : 'accessing' }
ACP2Client >> workingDirectory: aString [

	self processLauncher workingDirectory: aString
]
