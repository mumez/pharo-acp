Class {
	#name : 'ACPClientConnectionTest',
	#superclass : 'TestCase',
	#instVars : [
		'clientConnection',
		'agentTransport',
		'handler',
		'connection'
	],
	#category : 'ACP-Tests'
}

{ #category : 'running' }
ACPClientConnectionTest >> setUp [

	| pair |
	super setUp.
	pair := ACPTestTransport loopbackPair.
	connection := ACPConnection on: pair first.
	handler := ACPMockHandler new.
	clientConnection := ACPClientConnection on: connection handler: handler.
	agentTransport := pair second
]

{ #category : 'running' }
ACPClientConnectionTest >> tearDown [

	connection ifNotNil: [ :c | c close ].
	super tearDown
]

{ #category : 'tests' }
ACPClientConnectionTest >> testInitializeSendsCorrectRequest [

	| request |
	[
	clientConnection initialize: { ('foo' -> 'bar') } asDictionary ]
		forkAt: Processor userBackgroundPriority.
	request := agentTransport readMessage.
	self assert: (request at: 'method') equals: 'initialize'.
	self
		assert: ((request at: 'params') at: 'capabilities')
		equals: { ('foo' -> 'bar') } asDictionary.
	self assert: ((request at: 'params') at: 'protocolVersion') equals: 1
]

{ #category : 'tests' }
ACPClientConnectionTest >> testSessionUpdateIsDelegatedToHandler [

	| sem |
	sem := Semaphore new.
	connection startReadLoop.
	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('method' -> 'session/update').
			('params' -> { ('state' -> 'running') } asDictionary) } asDictionary.

	"Wait a bit for the read loop to process"
	[
	(Delay forMilliseconds: 200) wait.
	sem signal ] fork.
	sem wait.

	self assert: handler lastUpdate notNil.
	self
		assert: (handler lastUpdate at: 'state')
		equals: 'running'
]

{ #category : 'tests' }
ACPClientConnectionTest >> testRequestPermissionIsDelegatedToHandler [

	| response sem |
	sem := Semaphore new.
	connection startReadLoop.
	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('id' -> 1).
			('method' -> 'session/request_permission').
			('params' -> { ('tool' -> 'ls') } asDictionary) } asDictionary.

	[ response := agentTransport readMessage. sem signal ] fork.
	sem wait.

	self assert: handler permissionRequest notNil.
	self assert: (handler permissionRequest at: 'tool') equals: 'ls'.
	self assert: ((response at: 'result') at: 'allow') equals: true
]
