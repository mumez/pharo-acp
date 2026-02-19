Class {
	#name : 'ACPClientTest',
	#superclass : 'TestCase',
	#instVars : [
		'client'
	],
	#category : 'ACP-Tests',
	#package : 'ACP-Tests'
}

{ #category : 'running' }
ACPClientTest >> setUp [

	super setUp.
	client := ACPClient new.
	client agentCommand: '/bin/cat' arguments: #(  )
]

{ #category : 'running' }
ACPClientTest >> tearDown [

	client disconnect.
	super tearDown
]

{ #category : 'tests' }
ACPClientTest >> testConnectStartsProcess [

	client connect.
	self assert: client processLauncher isRunning.
	self assert: client connection notNil.
	self assert: client clientConnection notNil
]

{ #category : 'tests' }
ACPClientTest >> testDisconnectStopsProcess [

	client connect.
	client disconnect.
	self deny: client processLauncher isRunning
]

{ #category : 'tests' }
ACPClientTest >> testInitializeWithCapabilitiesRemoved [

	self deny: (client respondsTo: #initializeWithCapabilities:)
]

{ #category : 'tests' }
ACPClientTest >> testRespondsToBuilderMethods [

	self assert: (client respondsTo: #initializeBy:).
	self assert: (client respondsTo: #newSessionBy:).
	self assert: (client respondsTo: #promptBy:).
	self assert: (client respondsTo: #cancelBy:)
]

{ #category : 'tests' }
ACPClientTest >> testRespondsToInitializeBy [

	self assert: (client respondsTo: #initializeBy:)
]
