Class {
	#name : 'ACP2ClientTest',
	#superclass : 'TestCase',
	#instVars : [
		'client'
	],
	#category : 'ACP2-Tests',
	#package : 'ACP2-Tests'
}

{ #category : 'running' }
ACP2ClientTest >> setUp [

	super setUp.
	client := ACP2Client new.
	client agentCommand: '/bin/cat' arguments: #(  )
]

{ #category : 'running' }
ACP2ClientTest >> tearDown [

	client disconnect.
	super tearDown
]

{ #category : 'tests' }
ACP2ClientTest >> testConnectStartsProcess [

	client connect.
	self assert: client processLauncher isRunning.
	self assert: client connection notNil.
	self assert: client clientConnection notNil
]

{ #category : 'tests' }
ACP2ClientTest >> testDisconnectStopsProcess [

	client connect.
	client disconnect.
	self deny: client processLauncher isRunning
]

{ #category : 'tests' }
ACP2ClientTest >> testInitializeWithCapabilitiesRemoved [

	self deny: (client respondsTo: #initializeWithCapabilities:)
]

{ #category : 'tests' }
ACP2ClientTest >> testRespondsToBuilderMethods [

	self assert: (client respondsTo: #initializeBy:).
	self assert: (client respondsTo: #listSessionsBy:).
	self assert: (client respondsTo: #newSessionBy:).
	self assert: (client respondsTo: #resumeSessionBy:).
	self assert: (client respondsTo: #closeSessionBy:).
	self assert: (client respondsTo: #promptBy:).
	self assert: (client respondsTo: #cancelBy:).
	self assert: (client respondsTo: #logout:)
]

{ #category : 'tests' }
ACP2ClientTest >> testRespondsToListSessionsApi [

	self assert: (client respondsTo: #listSessions:).
	self assert: (client respondsTo: #listSessionsBy:)
]

{ #category : 'tests' }
ACP2ClientTest >> testRespondsToCloseSessionApi [

	self assert: (client respondsTo: #closeSession:).
	self assert: (client respondsTo: #closeSessionBy:)
]

{ #category : 'tests' }
ACP2ClientTest >> testRespondsToResumeSessionApi [

	self assert: (client respondsTo: #resumeSession:).
	self assert: (client respondsTo: #resumeSessionBy:)
]

{ #category : 'tests' }
ACP2ClientTest >> testRespondsToInitializeBy [

	self assert: (client respondsTo: #initializeBy:)
]
