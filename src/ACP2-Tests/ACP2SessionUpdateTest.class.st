Class {
	#name : 'ACP2SessionUpdateTest',
	#superclass : 'TestCase',
	#category : 'ACP2-Tests',
	#package : 'ACP2-Tests'
}

{ #category : 'tests' }
ACP2SessionUpdateTest >> testSessionUpdateType [

	| update |
	update := ACP2SessionUpdate fromDictionary:
		          { ('sessionUpdate' -> 'agent_message_chunk') } asDictionary.
	self assert: update sessionUpdate equals: 'agent_message_chunk'
]

{ #category : 'tests' }
ACP2SessionUpdateTest >> testUserMessage [

	| update content |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'user_message').
		          ('content' -> {
			           ('type' -> 'text').
			           ('text' -> 'Hello') } asDictionary) } asDictionary.
	self assert: update isUserMessage.
	content := update content.
	self assert: content class equals: ACP2ContentBlock.
	self assert: content text equals: 'Hello'
]

{ #category : 'tests' }
ACP2SessionUpdateTest >> testAgentMessage [

	| update content |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'agent_message').
		          ('messageId' -> 'msg-1').
		          ('content' -> {
			           ('type' -> 'text').
			           ('text' -> 'Hello') } asDictionary) } asDictionary.
	self assert: update sessionUpdate equals: 'agent_message'.
	self assert: update isAgentMessage.
	content := update content.
	self assert: content class equals: ACP2ContentBlock.
	self assert: content text equals: 'Hello'
]

{ #category : 'tests' }
ACP2SessionUpdateTest >> testAgentMessageChunk [

	| update content |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'agent_message_chunk').
		          ('content' -> {
			           ('type' -> 'text').
			           ('text' -> 'Hello from agent') } asDictionary) } asDictionary.
	content := update content.
	self assert: content class equals: ACP2ContentBlock.
	self assert: content text equals: 'Hello from agent'
]

{ #category : 'tests' }
ACP2SessionUpdateTest >> testAvailableCommandsUpdate [

	| update cmds |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'available_commands_update').
		          ('availableCommands' -> {
			           { ('name' -> '/help'). ('description' -> 'Show help') } asDictionary.
			           { ('name' -> '/quit'). ('description' -> 'Quit') } asDictionary }) }
		          asDictionary.
	cmds := update availableCommands.
	self assert: cmds size equals: 2.
	self assert: cmds first name equals: '/help'
]

{ #category : 'tests' }
ACP2SessionUpdateTest >> testIsMessageChunk [

	| chunk available |
	chunk := ACP2SessionUpdate fromDictionary:
		         { ('sessionUpdate' -> 'agent_message_chunk') } asDictionary.
	available := ACP2SessionUpdate fromDictionary:
		             { ('sessionUpdate' -> 'available_commands_update') } asDictionary.
	self assert: chunk isAgentMessageChunk.
	self deny: chunk isAvailableCommandsUpdate.
	self deny: available isAgentMessageChunk.
	self assert: available isAvailableCommandsUpdate
]

{ #category : 'tests' }
ACP2SessionUpdateTest >> testAvailableCommandInputHint [

	| update cmd |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'available_commands_update').
		          ('availableCommands' -> {
			           { ('name' -> '/help').
			             ('description' -> 'Show help').
			             ('input' -> { ('hint' -> 'type a question') } asDictionary) }
				           asDictionary }) } asDictionary.
	cmd := update availableCommands first.
	self assert: cmd inputHint equals: 'type a question'
]

{ #category : 'tests' }
ACP2SessionUpdateTest >> testCurrentModeUpdate [

	| update |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'current_mode_update').
		          ('currentModeId' -> 'code') } asDictionary.
	self assert: update isCurrentModeUpdate.
	self assert: update currentModeId equals: 'code'
]

{ #category : 'tests' }
ACP2SessionUpdateTest >> testConfigOptionUpdate [

	| update opts |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'config_option_update').
		          ('configOptions' -> {
			           { ('id' -> 'mode'). ('name' -> 'Session Mode'). ('description' -> 'desc1'). ('category' -> Dictionary new) } asDictionary.
			           { ('id' -> 'model'). ('name' -> 'Model'). ('description' -> 'desc2'). ('category' -> Dictionary new) } asDictionary }) }
		          asDictionary.
	self assert: update isConfigOptionUpdate.
	opts := update configOptions.
	self assert: opts size equals: 2.
	self assert: opts first id equals: 'mode'.
	self assert: opts first name equals: 'Session Mode'
]

{ #category : 'tests' }
ACP2SessionUpdateTest >> testSessionInfoUpdate [

	| update |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'session_info_update').
		          ('title' -> 'My Session').
		          ('updatedAt' -> '2024-01-01T00:00:00Z') } asDictionary.
	self assert: update isSessionInfoUpdate.
	self assert: update title equals: 'My Session'.
	self assert: update updatedAt equals: '2024-01-01T00:00:00Z'
]

{ #category : 'tests' }
ACP2SessionUpdateTest >> testUsageUpdate [

	| update |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'usage_update').
		          ('cost' -> 0.05).
		          ('size' -> 1024).
		          ('used' -> 512) } asDictionary.
	self assert: update isUsageUpdate.
	self assert: update cost equals: 0.05.
	self assert: update size equals: 1024.
	self assert: update used equals: 512
]

{ #category : 'tests' }
ACP2SessionUpdateTest >> testUserMessageChunk [

	| update content |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'user_message_chunk').
		          ('content' -> {
			           ('type' -> 'text').
			           ('text' -> 'What''s the capital of France?') } asDictionary) }
		          asDictionary.
	self assert: update isUserMessageChunk.
	content := update content.
	self assert: content class equals: ACP2ContentBlock.
	self assert: content text equals: 'What''s the capital of France?'
]

{ #category : 'tests' }
ACP2SessionUpdateTest >> testConfigOptionsEmptyWhenWrongType [

	| update |
	update := ACP2SessionUpdate fromDictionary:
		          { ('sessionUpdate' -> 'usage_update') } asDictionary.
	self assert: update configOptions isEmpty
]

{ #category : 'tests' }
ACP2SessionUpdateTest >> testStateUpdateRunningHasNoStopReason [

	| update |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'state_update').
		          ('state' -> 'running') } asDictionary.
	self assert: update isStateUpdate.
	self assert: update state equals: 'running'.
	self assert: update stopReason isNil
]

{ #category : 'tests' }
ACP2SessionUpdateTest >> testStateUpdateIdleCarriesStopReason [

	| update |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'state_update').
		          ('state' -> 'idle').
		          ('stopReason' -> 'end_turn') } asDictionary.
	self assert: update state equals: 'idle'.
	self assert: update stopReason equals: 'end_turn'
]
