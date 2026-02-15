Class {
	#name : 'ACPClient',
	#superclass : 'Object',
	#instVars : [
		'clientConnection',
		'processLauncher',
		'connection',
		'transport',
		'handler'
	],
	#category : 'ACP-Client'
}

{ #category : 'accessing' }
ACPClient >> agentCommand: command arguments: args [

	self processLauncher command: command.
	self processLauncher arguments: args
]

{ #category : 'accessing' }
ACPClient >> clientConnection [

	^ clientConnection
]

{ #category : 'accessing' }
ACPClient >> clientConnection: anObject [

	clientConnection := anObject
]

{ #category : 'accessing' }
ACPClient >> connection [

	^ connection
]

{ #category : 'accessing' }
ACPClient >> connection: anObject [

	connection := anObject
]

{ #category : 'accessing' }
ACPClient >> handler [

	^ handler ifNil: [ handler := self defaultHandler ]
]

{ #category : 'defaults' }
ACPClient >> defaultHandler [

	^ ACPTranscriptHandler new
]

{ #category : 'accessing' }
ACPClient >> handler: anObject [

	handler := anObject
]

{ #category : 'accessing' }
ACPClient >> processLauncher [

	^ processLauncher
]

{ #category : 'accessing' }
ACPClient >> processLauncher: anObject [

	processLauncher := anObject
]

{ #category : 'accessing' }
ACPClient >> transport [

	^ transport
]

{ #category : 'accessing' }
ACPClient >> transport: anObject [

	transport := anObject
]

{ #category : 'initialization' }
ACPClient >> initialize [

	super initialize.
	processLauncher := ACPProcessLauncher new
]

{ #category : 'lifecycle' }
ACPClient >> connect [

	self processLauncher launch.
	self transport: (ACPNdJsonTransport on: self processLauncher).
	self connection: (ACPConnection on: self transport).
	self clientConnection: (ACPClientConnection on: self connection handler: self handler).
	self connection startReadLoop
]

{ #category : 'lifecycle' }
ACPClient >> disconnect [

	self connection ifNotNil: [ :c | c close ].
	self processLauncher ifNotNil: [ :p | p terminate ]
]

{ #category : 'api' }
ACPClient >> initializeWithCapabilities: capabilities [

	^ self clientConnection initialize: capabilities
]

{ #category : 'api' }
ACPClient >> newSession: aDictionary [

	^ self clientConnection newSession: aDictionary
]

{ #category : 'api' }
ACPClient >> prompt: aDictionary [

	^ self clientConnection prompt: aDictionary
]

{ #category : 'api' }
ACPClient >> cancel: aDictionary [

	^ self clientConnection cancel: aDictionary
]

{ #category : 'accessing' }
ACPClient >> workingDirectory: aString [

	self processLauncher workingDirectory: aString
]

{ #category : 'accessing' }
ACPClient >> environmentAt: key put: value [

	self processLauncher envVariables at: key put: value
]
