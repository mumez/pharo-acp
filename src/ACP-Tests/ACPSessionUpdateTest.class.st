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
