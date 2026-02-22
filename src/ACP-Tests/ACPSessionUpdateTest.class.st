Class {
	#name : 'ACPSessionUpdateTest',
	#superclass : 'TestCase',
	#category : 'ACP-Tests',
	#package : 'ACP-Tests'
}

{ #category : 'tests' }
ACPSessionUpdateTest >> testSessionId [

	| update |
	update := ACPSessionUpdate fromDictionary: {
		          ('sessionId' -> 'sess-001').
		          ('update' -> { ('sessionUpdate' -> 'agent_message_chunk') } asDictionary) }
		          asDictionary.
	self assert: update sessionId equals: 'sess-001'
]

{ #category : 'tests' }
ACPSessionUpdateTest >> testUpdateType [

	| update |
	update := ACPSessionUpdate fromDictionary: {
		          ('sessionId' -> 'sess-001').
		          ('update' -> { ('sessionUpdate' -> 'agent_message_chunk') } asDictionary) }
		          asDictionary.
	self assert: update updateType equals: 'agent_message_chunk'
]

{ #category : 'tests' }
ACPSessionUpdateTest >> testAgentMessageChunk [

	| update content |
	update := ACPSessionUpdate fromDictionary: {
		          ('sessionId' -> 'sess-001').
		          ('update' -> {
			           ('sessionUpdate' -> 'agent_message_chunk').
			           ('content' -> {
				            ('type' -> 'text').
				            ('text' -> 'Hello from agent') } asDictionary) } asDictionary) }
		          asDictionary.
	content := update content.
	self assert: content class equals: ACPContentBlock.
	self assert: content text equals: 'Hello from agent'
]

{ #category : 'tests' }
ACPSessionUpdateTest >> testAvailableCommandsUpdate [

	| update cmds |
	update := ACPSessionUpdate fromDictionary: {
		          ('sessionId' -> 'sess-001').
		          ('update' -> {
			           ('sessionUpdate' -> 'available_commands_update').
			           ('availableCommands' -> {
				            { ('name' -> '/help'). ('description' -> 'Show help') } asDictionary.
				            { ('name' -> '/quit'). ('description' -> 'Quit') } asDictionary }) }
			           asDictionary) } asDictionary.
	cmds := update availableCommands.
	self assert: cmds size equals: 2.
	self assert: cmds first name equals: '/help'
]

{ #category : 'tests' }
ACPSessionUpdateTest >> testIsMessageChunk [

	| chunk available |
	chunk := ACPSessionUpdate fromDictionary:
		         { ('update' -> { ('sessionUpdate' -> 'agent_message_chunk') } asDictionary) }
		         asDictionary.
	available := ACPSessionUpdate fromDictionary:
		             { ('update' -> { ('sessionUpdate' -> 'available_commands_update') } asDictionary) }
		             asDictionary.
	self assert: chunk isAgentMessageChunk.
	self deny: chunk isAvailableCommandsUpdate.
	self deny: available isAgentMessageChunk.
	self assert: available isAvailableCommandsUpdate
]

{ #category : 'tests' }
ACPSessionUpdateTest >> testAvailableCommandInputHint [

	| update cmd |
	update := ACPSessionUpdate fromDictionary: {
		          ('update' -> {
			           ('sessionUpdate' -> 'available_commands_update').
			           ('availableCommands' -> {
				            { ('name' -> '/help').
				              ('description' -> 'Show help').
				              ('input' -> { ('hint' -> 'type a question') } asDictionary) }
					            asDictionary }) } asDictionary) } asDictionary.
	cmd := update availableCommands first.
	self assert: cmd inputHint equals: 'type a question'
]

{ #category : 'tests' }
ACPSessionUpdateTest >> testCurrentModeUpdate [

	| update |
	update := ACPSessionUpdate fromDictionary: {
		          ('sessionId' -> 'sess-001').
		          ('update' -> {
			           ('sessionUpdate' -> 'current_mode_update').
			           ('currentModeId' -> 'code') } asDictionary) } asDictionary.
	self assert: update isCurrentModeUpdate.
	self assert: update currentModeId equals: 'code'
]

{ #category : 'tests' }
ACPSessionUpdateTest >> testConfigOptionUpdate [

	| update opts |
	update := ACPSessionUpdate fromDictionary: {
		          ('sessionId' -> 'sess-001').
		          ('update' -> {
			           ('sessionUpdate' -> 'config_option_update').
			           ('configOptions' -> {
				            { ('id' -> 'mode'). ('name' -> 'Session Mode'). ('description' -> 'desc1'). ('category' -> Dictionary new) } asDictionary.
				            { ('id' -> 'model'). ('name' -> 'Model'). ('description' -> 'desc2'). ('category' -> Dictionary new) } asDictionary }) }
			           asDictionary) } asDictionary.
	self assert: update isConfigOptionUpdate.
	opts := update configOptions.
	self assert: opts size equals: 2.
	self assert: opts first id equals: 'mode'.
	self assert: opts first name equals: 'Session Mode'
]

{ #category : 'tests' }
ACPSessionUpdateTest >> testSessionInfoUpdate [

	| update |
	update := ACPSessionUpdate fromDictionary: {
		          ('sessionId' -> 'sess-001').
		          ('update' -> {
			           ('sessionUpdate' -> 'session_info_update').
			           ('title' -> 'My Session').
			           ('updatedAt' -> '2024-01-01T00:00:00Z') } asDictionary) } asDictionary.
	self assert: update isSessionInfoUpdate.
	self assert: update title equals: 'My Session'.
	self assert: update updatedAt equals: '2024-01-01T00:00:00Z'
]

{ #category : 'tests' }
ACPSessionUpdateTest >> testUsageUpdate [

	| update |
	update := ACPSessionUpdate fromDictionary: {
		          ('sessionId' -> 'sess-001').
		          ('update' -> {
			           ('sessionUpdate' -> 'usage_update').
			           ('cost' -> 0.05).
			           ('size' -> 1024).
			           ('used' -> 512) } asDictionary) } asDictionary.
	self assert: update isUsageUpdate.
	self assert: update cost equals: 0.05.
	self assert: update size equals: 1024.
	self assert: update used equals: 512
]

{ #category : 'tests' }
ACPSessionUpdateTest >> testUserMessageChunk [

	| update content |
	update := ACPSessionUpdate fromDictionary: {
		          ('sessionId' -> 'sess-789').
		          ('update' -> {
			           ('sessionUpdate' -> 'user_message_chunk').
			           ('content' -> {
				            ('type' -> 'text').
				            ('text' -> 'What''s the capital of France?') } asDictionary) } asDictionary) }
		          asDictionary.
	self assert: update isUserMessageChunk.
	content := update content.
	self assert: content class equals: ACPContentBlock.
	self assert: content text equals: 'What''s the capital of France?'
]

{ #category : 'tests' }
ACPSessionUpdateTest >> testConfigOptionsEmptyWhenWrongType [

	| update |
	update := ACPSessionUpdate fromDictionary: {
		          ('update' -> { ('sessionUpdate' -> 'usage_update') } asDictionary) } asDictionary.
	self assert: update configOptions isEmpty
]
