Class {
	#name : 'ACP2SmokeTest',
	#superclass : 'TestCase',
	#instVars : [
		'client',
		'handler'
	],
	#classVars : [
		'AgentPath'
	],
	#category : 'ACP2-Tests',
	#package : 'ACP2-Tests'
}

{ #category : 'accessing' }
ACP2SmokeTest class >> agentPath [

	"^ '/<path to typescript sdk sample agent>/typescript-sdk/src/examples/agent.ts'"
	^ AgentPath
]

{ #category : 'accessing' }
ACP2SmokeTest class >> agentPath: aString [

	AgentPath := aString
]

{ #category : 'class initialization' }
ACP2SmokeTest class >> initialize [

	AgentPath := nil
]

{ #category : 'running' }
ACP2SmokeTest >> setUp [

	super setUp.
	self class agentPath ifNil: [ ^ self ].
	handler := ACP2SmokeHandler new.
	client := ACP2Client new.
	client handler: handler.
	client agentCommand: '/usr/bin/env' arguments: {
			'npx'.
			'tsx'.
			self class agentPath }.
	client workingDirectory:
		self class agentPath asFileReference parent parent parent fullName
]

{ #category : 'running' }
ACP2SmokeTest >> tearDown [

	client ifNil: [ ^ self ].
	client disconnect.
	super tearDown
]

{ #category : 'tests' }
ACP2SmokeTest >> testFullProtocolFlow [
	"Test initialize → newSession → prompt against the TypeScript example agent."

	| initResult sessionResult promptResult sessionId |
	self class agentPath ifNil: [
		^ self skip: 'Agent path not set. Please set ACP2SmokeTest class variable AgentPath to the path of the TypeScript example agent.'
	].
	client connect.

	"Step 1: Initialize"
	initResult := client initialize: ACP2InitializeParams new.
	self assert: initResult protocolVersion equals: 1.

	"Step 2: New session"
	sessionResult := client newSessionBy: [ :params |
		params cwd: FileSystem workingDirectory fullName ].
	sessionId := sessionResult sessionId.
	self assert: sessionId notNil.
	self deny: sessionId isEmpty.

	"Step 3: Prompt (blocks until agent completes the turn)"
	promptResult := client promptBy: [ :params |
		params sessionId: sessionId.
		params textPrompt: 'Hello, agent!' ].

	self assert: promptResult stopReason equals: 'end_turn'.

	"Verify we received session updates"
	self assert: handler updates notEmpty.

	"Verify permission was requested and auto-approved"
	self assert: handler permissionRequest notNil
]
