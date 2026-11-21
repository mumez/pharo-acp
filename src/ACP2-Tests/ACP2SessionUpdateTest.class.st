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

{ #category : 'tests' }
ACP2SessionUpdateTest >> testMessageId [

	| update |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'agent_message_chunk').
		          ('messageId' -> 'msg-001').
		          ('content' -> {
			           ('type' -> 'text').
			           ('text' -> 'Hello') } asDictionary) } asDictionary.
	self assert: update messageId equals: 'msg-001'
]

{ #category : 'tests' }
ACP2SessionUpdateTest >> testMessageIdAbsent [

	| update |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'agent_message_chunk').
		          ('content' -> {
			           ('type' -> 'text').
			           ('text' -> 'Hello') } asDictionary) } asDictionary.
	self assert: update messageId isNil
]

{ #category : 'tests' }
ACP2SessionUpdateTest >> testToolCallName [

	| update toolCall |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'tool_call').
		          ('toolCallId' -> 'call_001').
		          ('title' -> 'Reading configuration file').
		          ('name' -> 'read_file') } asDictionary.
	toolCall := update toolCall.
	self assert: toolCall title equals: 'Reading configuration file'.
	self assert: toolCall name equals: 'read_file'
]

{ #category : 'tests' }
ACP2SessionUpdateTest >> testToolCallUpdateName [

	| update toolCallUpdate |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'tool_call_update').
		          ('toolCallId' -> 'call_001').
		          ('name' -> 'write_file') } asDictionary.
	toolCallUpdate := update toolCallUpdate.
	self assert: toolCallUpdate name equals: 'write_file'
]

{ #category : 'tests' }
ACP2SessionUpdateTest >> testToolCallUpdateNameAbsent [

	| update |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'tool_call_update').
		          ('toolCallId' -> 'call_001') } asDictionary.
	self assert: update toolCallUpdate name isNil
]

{ #category : 'tests' }
ACP2SessionUpdateTest >> testToolCallUpdateCancellable [

	| update |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'tool_call_update').
		          ('toolCallId' -> 'call_001').
		          ('capabilities' -> { ('cancel' -> Dictionary new) } asDictionary) }
		          asDictionary.
	self assert: update toolCallUpdate hasCapabilities.
	self assert: update toolCallUpdate isCancellable
]

{ #category : 'tests' }
ACP2SessionUpdateTest >> testToolCallUpdateCancelWithdrawn [

	| update |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'tool_call_update').
		          ('toolCallId' -> 'call_001').
		          ('capabilities' -> { ('cancel' -> nil) } asDictionary) } asDictionary.
	self assert: update toolCallUpdate hasCapabilities.
	self deny: update toolCallUpdate isCancellable
]

{ #category : 'tests' }
ACP2SessionUpdateTest >> testToolCallUpdateCapabilitiesNull [

	| update |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'tool_call_update').
		          ('toolCallId' -> 'call_001').
		          ('capabilities' -> nil) } asDictionary.
	self assert: update toolCallUpdate hasCapabilities.
	self deny: update toolCallUpdate isCancellable
]

{ #category : 'tests' }
ACP2SessionUpdateTest >> testToolCallUpdateCapabilitiesAbsent [

	| update |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'tool_call_update').
		          ('toolCallId' -> 'call_001') } asDictionary.
	self deny: update toolCallUpdate hasCapabilities.
	self deny: update toolCallUpdate isCancellable
]

{ #category : 'tests - state update' }
ACP2SessionUpdateTest >> testStateUpdateStates [

	| stateOf |
	stateOf := [ :name |
	           (ACP2SessionUpdate fromDictionary: {
			            ('sessionUpdate' -> 'state_update').
			            ('state' -> name) } asDictionary) stateUpdate ].
	self assert: (stateOf value: 'running') isRunning.
	self assert: (stateOf value: 'idle') isIdle.
	self assert: (stateOf value: 'requires_action') isRequiresAction.
	self assert: (stateOf value: 'unknown') isUnknown.
	self deny: (stateOf value: 'unknown') isIdle.
	self assert: (stateOf value: 'unknown') state equals: 'unknown'
]

{ #category : 'tests - state update' }
ACP2SessionUpdateTest >> testStateUpdateNilForOtherKinds [

	| update |
	update := ACP2SessionUpdate fromDictionary:
		          { ('sessionUpdate' -> 'agent_message_chunk') } asDictionary.
	self assert: update stateUpdate isNil
]

{ #category : 'tests - state update' }
ACP2SessionUpdateTest >> testStateUpdateIdleStopReason [

	| state |
	state := (ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'state_update').
		          ('state' -> 'idle').
		          ('stopReason' -> 'end_turn') } asDictionary) stateUpdate.
	self assert: state stopReason equals: 'end_turn'.
	self deny: state isError.
	self assert: state error isNil
]

{ #category : 'tests - state update' }
ACP2SessionUpdateTest >> testStateUpdateStopReasonOnlyWhenIdle [

	| state |
	state := (ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'state_update').
		          ('state' -> 'running').
		          ('stopReason' -> 'end_turn') } asDictionary) stateUpdate.
	self assert: state stopReason isNil
]

{ #category : 'tests - state update' }
ACP2SessionUpdateTest >> testStateUpdateMalformedStopReasonIsNotReported [

	| state |
	state := (ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'state_update').
		          ('state' -> 'idle').
		          ('stopReason' -> 42) } asDictionary) stateUpdate.
	self assert: state stopReason isNil
]

{ #category : 'tests - state update' }
ACP2SessionUpdateTest >> testStateUpdateIdleWithErrorStopReason [

	| state |
	state := (ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'state_update').
		          ('state' -> 'idle').
		          ('stopReason' -> 'error').
		          ('error' -> {
			           ('code' -> -32603).
			           ('message' -> 'Model backend failed') } asDictionary) }
		          asDictionary) stateUpdate.
	self assert: state stopReason equals: 'error'.
	self assert: state isError.
	self assert: state errorCode equals: -32603.
	self assert: state errorMessage equals: 'Model backend failed'.
	self assert: (state error at: 'code') equals: -32603
]

{ #category : 'tests - state update' }
ACP2SessionUpdateTest >> testStateUpdateErrorStopReasonWithoutDetails [

	| state |
	state := (ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'state_update').
		          ('state' -> 'idle').
		          ('stopReason' -> 'error').
		          ('error' -> nil) } asDictionary) stateUpdate.
	self assert: state isError.
	self assert: state error isNil.
	self assert: state errorCode isNil.
	self assert: state errorMessage isNil
]

{ #category : 'tests - state update' }
ACP2SessionUpdateTest >> testStateUpdateBackground [

	| background |
	background := (ACP2SessionUpdate fromDictionary: {
		               ('sessionUpdate' -> 'state_update').
		               ('state' -> 'idle').
		               ('background' -> {
			                { ('type' -> 'terminal'). ('terminalId' -> 'term-1') } asDictionary.
			                { ('type' -> 'tool_call'). ('toolCallId' -> 'call-1') } asDictionary.
			                { ('type' -> 'subagent'). ('sessionId' -> 'sess-child') } asDictionary }) }
		               asDictionary) stateUpdate background.
	self assert: background size equals: 3.
	self assert: (background allSatisfy: [ :each | each class = ACP2BackgroundWork ]).
	self assert: background first isTerminal.
	self assert: background first terminalId equals: 'term-1'.
	self assert: background second isToolCall.
	self assert: background second toolCallId equals: 'call-1'.
	self assert: background third isSubagent.
	self assert: background third sessionId equals: 'sess-child'
]

{ #category : 'tests - state update' }
ACP2SessionUpdateTest >> testStateUpdateBackgroundAbsentOrNull [

	| absent null |
	absent := (ACP2SessionUpdate fromDictionary: {
		           ('sessionUpdate' -> 'state_update').
		           ('state' -> 'running') } asDictionary) stateUpdate.
	null := (ACP2SessionUpdate fromDictionary: {
		         ('sessionUpdate' -> 'state_update').
		         ('state' -> 'running').
		         ('background' -> nil) } asDictionary) stateUpdate.
	self assert: absent background isEmpty.
	self assert: null background isEmpty
]

{ #category : 'tests - new kinds' }
ACP2SessionUpdateTest >> testNotice [

	| update notice |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'notice').
		          ('severity' -> 'warning').
		          ('title' -> 'Rate limited').
		          ('description' -> 'Retrying in 10s') } asDictionary.
	self assert: update isNotice.
	notice := update notice.
	self assert: notice class equals: ACP2Notice.
	self assert: notice severity equals: 'warning'.
	self assert: notice isWarning.
	self deny: notice isError.
	self deny: notice isInfo.
	self assert: notice title equals: 'Rate limited'.
	self assert: notice description equals: 'Retrying in 10s'
]

{ #category : 'tests - new kinds' }
ACP2SessionUpdateTest >> testNoticeNilForOtherKinds [

	self assert: (ACP2SessionUpdate fromDictionary:
			 { ('sessionUpdate' -> 'agent_message_chunk') } asDictionary) notice isNil
]

{ #category : 'tests - new kinds' }
ACP2SessionUpdateTest >> testCompactionUpdate [

	| update compaction |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'compaction_update').
		          ('compactionId' -> 'cmp-1').
		          ('status' -> 'completed').
		          ('summary' -> {
			           { ('type' -> 'text'). ('text' -> 'Earlier we...') } asDictionary }) }
		          asDictionary.
	self assert: update isCompactionUpdate.
	compaction := update compactionUpdate.
	self assert: compaction class equals: ACP2CompactionUpdate.
	self assert: compaction compactionId equals: 'cmp-1'.
	self assert: compaction status equals: 'completed'.
	self assert: compaction isCompleted.
	self deny: compaction isInProgress.
	self assert: compaction summary size equals: 1.
	self assert: compaction summary first class equals: ACP2ContentBlock.
	self assert: compaction summary first text equals: 'Earlier we...'.
	self assert: compaction error isNil
]

{ #category : 'tests - new kinds' }
ACP2SessionUpdateTest >> testCompactionUpdateFailed [

	| compaction |
	compaction := (ACP2SessionUpdate fromDictionary: {
		               ('sessionUpdate' -> 'compaction_update').
		               ('compactionId' -> 'cmp-1').
		               ('status' -> 'failed').
		               ('error' -> 'context too large') } asDictionary) compactionUpdate.
	self assert: compaction isFailed.
	self assert: compaction error equals: 'context too large'.
	self assert: compaction summary isEmpty
]

{ #category : 'tests - new kinds' }
ACP2SessionUpdateTest >> testCompactionUpdateStatuses [

	| statusOf |
	statusOf := [ :status |
	            (ACP2SessionUpdate fromDictionary: {
			             ('sessionUpdate' -> 'compaction_update').
			             ('compactionId' -> 'cmp-1').
			             ('status' -> status) } asDictionary) compactionUpdate ].
	self assert: (statusOf value: 'in_progress') isInProgress.
	self assert: (statusOf value: 'cancelled') isCancelled.
	self deny: (statusOf value: 'in_progress') isCancelled
]

{ #category : 'tests - new kinds' }
ACP2SessionUpdateTest >> testCompactionSummaryChunk [

	| update |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'compaction_summary_chunk').
		          ('compactionId' -> 'cmp-1').
		          ('content' -> {
			           ('type' -> 'text').
			           ('text' -> 'Earlier') } asDictionary) } asDictionary.
	self assert: update isCompactionSummaryChunk.
	self assert: update compactionId equals: 'cmp-1'.
	self assert: update content text equals: 'Earlier'
]

{ #category : 'tests - new kinds' }
ACP2SessionUpdateTest >> testReplayComplete [

	| update |
	update := ACP2SessionUpdate fromDictionary:
		          { ('sessionUpdate' -> 'replay_complete') } asDictionary.
	self assert: update isReplayComplete.
	self deny: update isNotice
]

{ #category : 'tests - new kinds' }
ACP2SessionUpdateTest >> testSubagentUpdate [

	| subagent |
	subagent := self fullSubagentUpdate subagentUpdate.
	self assert: subagent class equals: ACP2SubagentUpdate.
	self assert: subagent sessionId equals: 'sess-child'.
	self assert: subagent title equals: 'Researcher'.
	self assert: subagent description equals: 'Looks things up'.
	self assert: subagent hasCapabilities.
	self assert: subagent isCancellable.
	self assert: subagent cwd equals: '/work/child'.
	self assert: subagent additionalDirectories equals: #( '/work/shared' )
]

{ #category : 'tests - new kinds' }
ACP2SessionUpdateTest >> testSubagentUpdateState [

	| update subagent |
	update := self fullSubagentUpdate.
	self assert: update isSubagentUpdate.
	subagent := update subagentUpdate.
	self assert: subagent hasState.
	self assert: subagent state class equals: ACP2StateUpdate.
	self assert: subagent state isIdle.
	self assert: subagent state stopReason equals: 'end_turn'
]

{ #category : 'tests - new kinds' }
ACP2SessionUpdateTest >> testSubagentUpdatePatchSemantics [

	| absent cleared |
	absent := (ACP2SessionUpdate fromDictionary: {
		           ('sessionUpdate' -> 'subagent_update').
		           ('sessionId' -> 'sess-child') } asDictionary) subagentUpdate.
	self deny: absent hasCapabilities.
	self deny: absent isCancellable.
	self deny: absent hasState.
	self assert: absent state isNil.
	cleared := (ACP2SessionUpdate fromDictionary: {
		            ('sessionUpdate' -> 'subagent_update').
		            ('sessionId' -> 'sess-child').
		            ('capabilities' -> nil).
		            ('state' -> nil) } asDictionary) subagentUpdate.
	self assert: cleared hasCapabilities.
	self deny: cleared isCancellable.
	self assert: cleared hasState.
	self assert: cleared state isNil
]

{ #category : 'tests - new kinds' }
ACP2SessionUpdateTest >> testSessionMessage [

	| update message |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'session_message').
		          ('messageId' -> 'msg-1').
		          ('senderSessionId' -> 'sess-parent').
		          ('recipientSessionId' -> 'sess-child').
		          ('senderMessageId' -> 'msg-0').
		          ('recipientMessageId' -> 'msg-9').
		          ('content' -> {
			           { ('type' -> 'text'). ('text' -> 'Please check') } asDictionary }) }
		          asDictionary.
	self assert: update isSessionMessage.
	message := update sessionMessage.
	self assert: message class equals: ACP2SessionMessage.
	self assert: message messageId equals: 'msg-1'.
	self assert: message senderSessionId equals: 'sess-parent'.
	self assert: message recipientSessionId equals: 'sess-child'.
	self assert: message senderMessageId equals: 'msg-0'.
	self assert: message recipientMessageId equals: 'msg-9'.
	self assert: message content size equals: 1.
	self assert: message content first text equals: 'Please check'
]

{ #category : 'tests - new kinds' }
ACP2SessionUpdateTest >> testSessionMessageNilForOtherKinds [

	self assert: (ACP2SessionUpdate fromDictionary:
			 { ('sessionUpdate' -> 'session_message_chunk') } asDictionary)
			sessionMessage isNil
]

{ #category : 'tests - new kinds' }
ACP2SessionUpdateTest >> testSessionMessageChunk [

	| update |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'session_message_chunk').
		          ('messageId' -> 'msg-1').
		          ('content' -> {
			           ('type' -> 'text').
			           ('text' -> 'Please') } asDictionary) } asDictionary.
	self assert: update isSessionMessageChunk.
	self deny: update isSessionMessage.
	self assert: update messageId equals: 'msg-1'.
	self assert: update content text equals: 'Please'
]

{ #category : 'tests - tool call' }
ACP2SessionUpdateTest >> testToolCallUpdatePausedStatus [

	| update |
	update := ACP2SessionUpdate fromDictionary: {
		          ('sessionUpdate' -> 'tool_call_update').
		          ('toolCallId' -> 'call_001').
		          ('status' -> 'paused') } asDictionary.
	self assert: update toolCallUpdate status equals: 'paused'
]

{ #category : 'tests - tool call' }
ACP2SessionUpdateTest >> testToolCallContentSessionReference [

	| content |
	content := (ACP2SessionUpdate fromDictionary: {
		            ('sessionUpdate' -> 'tool_call_update').
		            ('toolCallId' -> 'call_001').
		            ('content' -> {
			             { ('type' -> 'session'). ('sessionId' -> 'sess-child') } asDictionary.
			             { ('type' -> 'content').
				             ('content' -> { ('type' -> 'text'). ('text' -> 'done') } asDictionary) }
				             asDictionary }) } asDictionary) toolCallUpdate content.
	self assert: content first isSession.
	self assert: content first sessionId equals: 'sess-child'.
	self deny: content second isSession.
	self assert: content second sessionId isNil.
	self assert: content second content text equals: 'done'
]

{ #category : 'tests - terminal' }
ACP2SessionUpdateTest >> testTerminalUpdate [

	| update terminal |
	update := self fullTerminalUpdate.
	self assert: update isTerminalUpdate.
	terminal := update terminalUpdate.
	self assert: terminal class equals: ACP2TerminalUpdate.
	self assert: terminal terminalId equals: 'term-1'.
	self assert: terminal command equals: 'npm test'.
	self assert: terminal cwd equals: '/work'.
	self assert: terminal outputData equals: 'PASS'.
	self assert: terminal hasExited.
	self assert: terminal exitCode equals: 0.
	self assert: terminal signal isNil
]

{ #category : 'tests - terminal' }
ACP2SessionUpdateTest >> testTerminalUpdateSizeAndCapabilities [

	| terminal |
	terminal := self fullTerminalUpdate terminalUpdate.
	self assert: terminal hasSize.
	self assert: terminal columns equals: 120.
	self assert: terminal rows equals: 40.
	self assert: terminal hasCapabilities.
	self assert: terminal isCancellable
]

{ #category : 'tests - terminal' }
ACP2SessionUpdateTest >> testTerminalUpdatePatchSemantics [

	| absent cleared |
	absent := (ACP2SessionUpdate fromDictionary: {
		           ('sessionUpdate' -> 'terminal_update').
		           ('terminalId' -> 'term-1') } asDictionary) terminalUpdate.
	self deny: absent hasCapabilities.
	self deny: absent isCancellable.
	self deny: absent hasSize.
	self assert: absent columns isNil.
	self assert: absent rows isNil.
	self deny: absent hasExited.
	self assert: absent exitCode isNil.
	self assert: absent outputData isNil.
	cleared := (ACP2SessionUpdate fromDictionary: {
		            ('sessionUpdate' -> 'terminal_update').
		            ('terminalId' -> 'term-1').
		            ('size' -> nil).
		            ('capabilities' -> { ('cancel' -> nil) } asDictionary) } asDictionary)
		           terminalUpdate.
	self assert: cleared hasSize.
	self assert: cleared columns isNil.
	self assert: cleared hasCapabilities.
	self deny: cleared isCancellable
]

{ #category : 'tests - terminal' }
ACP2SessionUpdateTest >> testTerminalUpdateNilForOtherKinds [

	self assert: (ACP2SessionUpdate fromDictionary:
			 { ('sessionUpdate' -> 'tool_call_update') } asDictionary) terminalUpdate isNil
]

{ #category : 'fixtures' }
ACP2SessionUpdateTest >> fullSubagentUpdate [

	^ ACP2SessionUpdate fromDictionary: {
			  ('sessionUpdate' -> 'subagent_update').
			  ('sessionId' -> 'sess-child').
			  ('title' -> 'Researcher').
			  ('description' -> 'Looks things up').
			  ('capabilities' -> { ('cancel' -> Dictionary new) } asDictionary).
			  ('state' -> {
				   ('state' -> 'idle').
				   ('stopReason' -> 'end_turn') } asDictionary).
			  ('cwd' -> '/work/child').
			  ('additionalDirectories' -> #( '/work/shared' )) } asDictionary
]

{ #category : 'fixtures' }
ACP2SessionUpdateTest >> fullTerminalUpdate [

	^ ACP2SessionUpdate fromDictionary: {
			  ('sessionUpdate' -> 'terminal_update').
			  ('terminalId' -> 'term-1').
			  ('command' -> 'npm test').
			  ('cwd' -> '/work').
			  ('output' -> { ('data' -> 'PASS') } asDictionary).
			  ('exitStatus' -> {
				   ('exitCode' -> 0).
				   ('signal' -> nil) } asDictionary).
			  ('size' -> {
				   ('cols' -> 120).
				   ('rows' -> 40) } asDictionary).
			  ('capabilities' -> { ('cancel' -> Dictionary new) } asDictionary) }
			  asDictionary
]
