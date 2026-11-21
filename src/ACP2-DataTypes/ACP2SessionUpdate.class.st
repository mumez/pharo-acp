"
I represent the update object of a v2 session/update notification: one event reported by the agent while a session exists.

Responsibility:
- I tell which kind of update this is (the sessionUpdate discriminator) through is* tests
- I expose the fields shared by several kinds (content, messageId, compactionId, ...)
- I hand out a typed object for kinds with their own structure

Collaborators:
- ACP2ClientConnection: creates me from the params of each session/update notification
- ACP2ClientHandler: receives me in #sessionUpdate:
- ACP2StateUpdate, ACP2ToolCall, ACP2ToolCallUpdate, ACP2TerminalUpdate, ACP2Notice, ACP2CompactionUpdate,
  ACP2SubagentUpdate, ACP2SessionMessage: the typed views I return

Public API:
- sessionUpdate - the raw kind string
- is* - kind tests (isAgentMessageChunk, isStateUpdate, isToolCallUpdate, isTerminalUpdate, isNotice,
  isCompactionUpdate, isCompactionSummaryChunk, isReplayComplete, isSubagentUpdate, isSessionMessage,
  isSessionMessageChunk, ...)
- stateUpdate / toolCall / toolCallUpdate / terminalUpdate / notice / compactionUpdate / subagentUpdate /
  sessionMessage - typed view for the matching kind, nil for any other kind
- content / messageId / compactionId - shared fields of chunk kinds (e.g. session_message_chunk, compaction_summary_chunk)
- state / stopReason - shortcuts into a state_update

Implementation Points:
- I keep the raw dictionary; typed views are built on demand from the same rawValues
- Unknown kinds are kept as-is so that clients can ignore them
"
Class {
	#name : 'ACP2SessionUpdate',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2SessionUpdate >> sessionUpdate [

	^ self rawValues at: 'sessionUpdate' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionUpdate >> content [

    ^ self valueAt: 'content' typed: ACP2ContentBlock in: self rawValues
]

{ #category : 'accessing' }
ACP2SessionUpdate >> state [

	^ self rawValues at: 'state' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionUpdate >> stopReason [

	^ self stateUpdate ifNotNil: [ :stateUpdate | stateUpdate stopReason ]
]

{ #category : 'accessing' }
ACP2SessionUpdate >> stateUpdate [

	self isStateUpdate ifFalse: [ ^ nil ].
	^ ACP2StateUpdate fromDictionary: self rawValues
]

{ #category : 'accessing' }
ACP2SessionUpdate >> messageId [

	^ self rawValues at: 'messageId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionUpdate >> availableCommands [

	self isAvailableCommandsUpdate ifFalse: [ ^ #() ].
	^ self valuesAt: 'availableCommands' typed: ACP2AvailableCommand in: self rawValues
]

{ #category : 'accessing' }
ACP2SessionUpdate >> entries [

	self isPlan ifFalse: [ ^ #() ].
	^ self valuesAt: 'entries' typed: ACP2PlanEntry in: self rawValues
]

{ #category : 'accessing' }
ACP2SessionUpdate >> toolCall [

	self isToolCall ifFalse: [ ^ nil ].
	^ ACP2ToolCall fromDictionary: self rawValues
]

{ #category : 'accessing' }
ACP2SessionUpdate >> toolCallUpdate [

	self isToolCallUpdate ifFalse: [ ^ nil ].
	^ ACP2ToolCallUpdate fromDictionary: self rawValues
]

{ #category : 'testing' }
ACP2SessionUpdate >> isUserMessage [

	^ self sessionUpdate = 'user_message'
]

{ #category : 'testing' }
ACP2SessionUpdate >> isAgentMessage [

	^ self sessionUpdate = 'agent_message'
]

{ #category : 'testing' }
ACP2SessionUpdate >> isAgentMessageChunk [

	^ self sessionUpdate = 'agent_message_chunk'
]

{ #category : 'testing' }
ACP2SessionUpdate >> isStateUpdate [

	^ self sessionUpdate = 'state_update'
]

{ #category : 'testing' }
ACP2SessionUpdate >> isAgentThoughtChunk [

	^ self sessionUpdate = 'agent_thought_chunk'
]

{ #category : 'testing' }
ACP2SessionUpdate >> isAvailableCommandsUpdate [

	^ self sessionUpdate = 'available_commands_update'
]

{ #category : 'testing' }
ACP2SessionUpdate >> isConfigOptionUpdate [

	^ self sessionUpdate = 'config_option_update'
]

{ #category : 'testing' }
ACP2SessionUpdate >> isCurrentModeUpdate [

	^ self sessionUpdate = 'current_mode_update'
]

{ #category : 'testing' }
ACP2SessionUpdate >> isPlan [

	^ self sessionUpdate = 'plan'
]

{ #category : 'testing' }
ACP2SessionUpdate >> isSessionInfoUpdate [

	^ self sessionUpdate = 'session_info_update'
]

{ #category : 'testing' }
ACP2SessionUpdate >> isToolCall [

	^ self sessionUpdate = 'tool_call'
]

{ #category : 'testing' }
ACP2SessionUpdate >> isToolCallUpdate [

	^ self sessionUpdate = 'tool_call_update'
]

{ #category : 'testing' }
ACP2SessionUpdate >> isUsageUpdate [

	^ self sessionUpdate = 'usage_update'
]

{ #category : 'testing' }
ACP2SessionUpdate >> isUserMessageChunk [

	^ self sessionUpdate = 'user_message_chunk'
]

{ #category : 'accessing' }
ACP2SessionUpdate >> currentModeId [

	^ self rawValues at: 'currentModeId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionUpdate >> configOptions [

	self isConfigOptionUpdate ifFalse: [ ^ #() ].
	^ self valuesAt: 'configOptions' typed: ACP2ConfigOption in: self rawValues
]

{ #category : 'accessing' }
ACP2SessionUpdate >> title [

	^ self rawValues at: 'title' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionUpdate >> updatedAt [

	^ self rawValues at: 'updatedAt' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionUpdate >> cost [

	^ self rawValues at: 'cost' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionUpdate >> size [

	^ self rawValues at: 'size' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionUpdate >> used [

	^ self rawValues at: 'used' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionUpdate >> compactionId [

	^ self rawValues at: 'compactionId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SessionUpdate >> compactionUpdate [

	self isCompactionUpdate ifFalse: [ ^ nil ].
	^ ACP2CompactionUpdate fromDictionary: self rawValues
]

{ #category : 'accessing' }
ACP2SessionUpdate >> notice [

	self isNotice ifFalse: [ ^ nil ].
	^ ACP2Notice fromDictionary: self rawValues
]

{ #category : 'accessing' }
ACP2SessionUpdate >> sessionMessage [

	self isSessionMessage ifFalse: [ ^ nil ].
	^ ACP2SessionMessage fromDictionary: self rawValues
]

{ #category : 'accessing' }
ACP2SessionUpdate >> subagentUpdate [

	self isSubagentUpdate ifFalse: [ ^ nil ].
	^ ACP2SubagentUpdate fromDictionary: self rawValues
]

{ #category : 'testing' }
ACP2SessionUpdate >> isCompactionSummaryChunk [

	^ self sessionUpdate = 'compaction_summary_chunk'
]

{ #category : 'testing' }
ACP2SessionUpdate >> isCompactionUpdate [

	^ self sessionUpdate = 'compaction_update'
]

{ #category : 'testing' }
ACP2SessionUpdate >> isNotice [

	^ self sessionUpdate = 'notice'
]

{ #category : 'testing' }
ACP2SessionUpdate >> isReplayComplete [

	^ self sessionUpdate = 'replay_complete'
]

{ #category : 'testing' }
ACP2SessionUpdate >> isSessionMessage [

	^ self sessionUpdate = 'session_message'
]

{ #category : 'testing' }
ACP2SessionUpdate >> isSessionMessageChunk [

	^ self sessionUpdate = 'session_message_chunk'
]

{ #category : 'testing' }
ACP2SessionUpdate >> isSubagentUpdate [

	^ self sessionUpdate = 'subagent_update'
]

{ #category : 'accessing' }
ACP2SessionUpdate >> terminalUpdate [

	self isTerminalUpdate ifFalse: [ ^ nil ].
	^ ACP2TerminalUpdate fromDictionary: self rawValues
]

{ #category : 'testing' }
ACP2SessionUpdate >> isTerminalUpdate [

	^ self sessionUpdate = 'terminal_update'
]
