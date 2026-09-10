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

	"^ '/<path to typescript sdk>/typescript-sdk/src/examples/dual-version-agent.ts'"
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
	"Test initialize → newSession → prompt against the TypeScript SDK's dual-version-agent.ts
	v2 example. Unlike v1, the turn's outcome is not carried synchronously in the prompt
	response - it arrives later via a session/update notification with sessionUpdate:
	'state_update', so we poll the handler for it after prompt: returns."

	| initResult sessionResult sessionId stateUpdate |
	self class agentPath ifNil: [
		^ self skip: 'Agent path not set. Please set ACP2SmokeTest class variable AgentPath to the path of dual-version-agent.ts.'
	].
	client connect.

	"Step 1: Initialize"
	initResult := client initializeBy: [ :params |
		params info
			name: 'pharo-acp-smoke-test';
			version: '1.0.0' ].
	self assert: initResult protocolVersion equals: 2.

	"Step 2: New session"
	sessionResult := client newSessionBy: [ :params |
		params cwd: FileSystem workingDirectory fullName ].
	sessionId := sessionResult sessionId.
	self assert: sessionId notNil.
	self deny: sessionId isEmpty.

	"Step 3: Prompt. Returns once the agent's request handler resolves, ahead of the
	turn's own session/update notifications."
	client promptBy: [ :params |
		params sessionId: sessionId.
		params textPrompt: 'Hello, agent!' ].

	"Step 4: Wait for the state_update notification that ends the turn."
	stateUpdate := self waitForFinalStateUpdate.
	self assert: stateUpdate notNil.
	self assert: stateUpdate stopReason equals: 'end_turn'.

	"Verify we received the streamed updates for this turn"
	self assert: (handler updates anySatisfy: [ :each | each isUserMessage ]).
	self assert: (handler updates anySatisfy: [ :each | each isAgentMessage ])
]

{ #category : 'private' }
ACP2SmokeTest >> waitForFinalStateUpdate [
	"Poll the handler's received updates until a state_update with a stopReason arrives,
	or a timeout elapses."

	| deadline |
	deadline := DateAndTime now + 5 seconds.
	[ DateAndTime now < deadline ] whileTrue: [
		| found |
		found := handler updates
			detect: [ :each | each isStateUpdate and: [ each stopReason notNil ] ]
			ifNone: [ nil ].
		found ifNotNil: [ ^ found ].
		(Delay forMilliseconds: 50) wait ].
	^ nil
]
