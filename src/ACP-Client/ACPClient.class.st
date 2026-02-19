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
	#category : 'ACP-Client',
	#package : 'ACP-Client'
}

{ #category : 'accessing' }
ACPClient >> agentCommand: command arguments: args [

	self processLauncher command: command.
	self processLauncher arguments: args
]

{ #category : 'api' }
ACPClient >> cancel: aParamsOrDictionary [

	^ self clientConnection cancel: aParamsOrDictionary
]

{ #category : 'api - builder' }
ACPClient >> cancelBy: aBlock [

	^ self clientConnection cancelBy: aBlock
]

{ #category : 'accessing' }
ACPClient >> clientConnection [

	^ clientConnection
]

{ #category : 'accessing' }
ACPClient >> clientConnection: anObject [

	clientConnection := anObject
]

{ #category : 'lifecycle' }
ACPClient >> connect [

	self processLauncher launch.
	self transport: (ACPNdJsonTransport on: self processLauncher).
	self connection: (ACPConnection on: self transport).
	self clientConnection: (ACPClientConnection on: self connection handler: self handler).
	self connection startReadLoop
]

{ #category : 'accessing' }
ACPClient >> connection [

	^ connection
]

{ #category : 'accessing' }
ACPClient >> connection: anObject [

	connection := anObject
]

{ #category : 'defaults' }
ACPClient >> defaultHandler [

	^ ACPTranscriptHandler new
]

{ #category : 'lifecycle' }
ACPClient >> disconnect [

	self connection ifNotNil: [ :c | c close ].
	self processLauncher ifNotNil: [ :p | p terminate ]
]

{ #category : 'accessing' }
ACPClient >> environmentAt: key put: value [

	self processLauncher envVariables at: key put: value
]

{ #category : 'accessing' }
ACPClient >> handler [

	^ handler ifNil: [ handler := self defaultHandler ]
]

{ #category : 'accessing' }
ACPClient >> handler: anObject [

	handler := anObject
]

{ #category : 'initialization' }
ACPClient >> initialize [

	super initialize.
	processLauncher := ACPProcessLauncher new
]

{ #category : 'api' }
ACPClient >> initialize: aParamsOrDictionary [

	^ self clientConnection initialize: aParamsOrDictionary
]

{ #category : 'api - builder' }
ACPClient >> initializeBy: aBlock [

	^ self clientConnection initializeBy: aBlock
]

{ #category : 'api' }
ACPClient >> newSession: aParamsOrDictionary [

	^ self clientConnection newSession: aParamsOrDictionary
]

{ #category : 'api - builder' }
ACPClient >> newSessionBy: aBlock [

	^ self clientConnection newSessionBy: aBlock
]

{ #category : 'accessing' }
ACPClient >> processLauncher [

	^ processLauncher
]

{ #category : 'accessing' }
ACPClient >> processLauncher: anObject [

	processLauncher := anObject
]

{ #category : 'api' }
ACPClient >> prompt: aParamsOrDictionary [

	^ self clientConnection prompt: aParamsOrDictionary
]

{ #category : 'api - builder' }
ACPClient >> promptBy: aBlock [

	^ self clientConnection promptBy: aBlock
]

{ #category : 'accessing' }
ACPClient >> transport [

	^ transport
]

{ #category : 'accessing' }
ACPClient >> transport: anObject [

	transport := anObject
]

{ #category : 'accessing' }
ACPClient >> workingDirectory: aString [

	self processLauncher workingDirectory: aString
]
