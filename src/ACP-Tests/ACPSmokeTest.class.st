Class {
	#name : 'ACPSmokeTest',
	#superclass : 'TestCase',
	#instVars : [
		'client',
		'handler'
	],
	#classVars : [
		'AgentPath'
	],
	#category : 'ACP-Tests',
	#package : 'ACP-Tests'
}

{ #category : 'accessing' }
ACPSmokeTest class >> agentPath [

	"^ '/<path to typescript sdk sample agent>/typescript-sdk/src/examples/agent.ts'"
	^ AgentPath
]

{ #category : 'accessing' }
ACPSmokeTest class >> agentPath: aString [

	AgentPath := aString
]

{ #category : 'class initialization' }
ACPSmokeTest class >> initialize [

	AgentPath := nil
]

{ #category : 'running' }
ACPSmokeTest >> setUp [

	super setUp.
	self class agentPath ifNil: [ ^ self ].
	handler := ACPSmokeHandler new.
	client := ACPClient new.
	client handler: handler.
	client agentCommand: '/usr/bin/env' arguments: {
			'npx'.
			'tsx'.
			self class agentPath }.
	client workingDirectory:
		self class agentPath asFileReference parent parent parent fullName
]

{ #category : 'running' }
ACPSmokeTest >> tearDown [

	client ifNil: [ ^ self ].
	client disconnect.
	super tearDown
]

{ #category : 'tests' }
ACPSmokeTest >> testFullProtocolFlow [
	"Test initialize → newSession → prompt against the TypeScript example agent."

	| initResult sessionResult promptResult sessionId |
	self class agentPath ifNil: [
		^ self skip: 'Agent path not set. Please set ACPSmokeTest class variable AgentPath to the path of the TypeScript example agent.'
	].
	client connect.

	"Step 1: Initialize"
	initResult := client initialize: ACPInitializeParams new.
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
		params prompt: { { ('type' -> 'text'). ('text' -> 'Hello, agent!') } asDictionary } ].

	self assert: promptResult stopReason equals: 'end_turn'.

	"Verify we received session updates"
	self assert: handler updates notEmpty.

	"Verify permission was requested and auto-approved"
	self assert: handler permissionRequest notNil
]
