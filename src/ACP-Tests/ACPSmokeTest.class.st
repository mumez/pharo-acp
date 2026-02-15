Class {
	#name : 'ACPSmokeTest',
	#superclass : 'TestCase',
	#instVars : [
		'client',
		'handler'
	],
	#category : 'ACP-Tests'
}

{ #category : 'accessing' }
ACPSmokeTest class >> agentPath [

	^ '/home/ume/git/typescript-sdk/src/examples/agent.ts'
]

{ #category : 'testing' }
ACPSmokeTest class >> isAbstract [
	"Skip in automated test runs — requires external agent process"

	^ true
]

{ #category : 'running' }
ACPSmokeTest >> setUp [

	super setUp.
	handler := ACPSmokeHandler new.
	client := ACPClient new.
	client handler: handler.
	client agentCommand: '/usr/bin/env' arguments: {
			'npx'.
			'tsx'.
			self class agentPath }.
	client processLauncher workingDirectory:
		self class agentPath asFileReference parent parent parent fullName
]

{ #category : 'running' }
ACPSmokeTest >> tearDown [

	client disconnect.
	super tearDown
]

{ #category : 'tests' }
ACPSmokeTest >> testFullProtocolFlow [
	"Test initialize → newSession → prompt against the TypeScript example agent."

	| initResult sessionResult promptResult sessionId |
	client connect.

	"Step 1: Initialize"
	initResult := client initializeWithCapabilities: Dictionary new.
	self assert: (initResult at: 'protocolVersion') equals: 1.

	"Step 2: New session"
	sessionResult := client clientConnection newSession: {
				            ('cwd' -> FileSystem workingDirectory fullName).
				            ('mcpServers' -> #()) } asDictionary.
	sessionId := sessionResult at: 'sessionId'.
	self assert: sessionId notNil.
	self deny: sessionId isEmpty.

	"Step 3: Prompt (blocks until agent completes the turn)"
	promptResult := client prompt: {
				            ('sessionId' -> sessionId).
				            ('prompt'
				             -> { { ('type' -> 'text'). ('text' -> 'Hello, agent!') }
						             asDictionary }) } asDictionary.

	self assert: (promptResult at: 'stopReason') equals: 'end_turn'.

	"Verify we received session updates"
	self assert: handler updates notEmpty.

	"Verify permission was requested and auto-approved"
	self assert: handler permissionRequest notNil
]
