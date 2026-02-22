Class {
	#name : 'ACPSessionUpdate',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPSessionUpdate >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACPSessionUpdate >> updateType [

	^ self updateDict at: 'sessionUpdate' ifAbsent: []
]

{ #category : 'private' }
ACPSessionUpdate >> updateDict [

	^ self rawValues at: 'update' ifAbsentPut: [ Dictionary new ]
]

{ #category : 'accessing' }
ACPSessionUpdate >> content [

    ^ self valueAt: 'content' typed: ACPContentBlock in: self updateDict
]

{ #category : 'accessing' }
ACPSessionUpdate >> availableCommands [

	self isAvailableCommandsUpdate ifFalse: [ ^ #() ].
	^ self valuesAt: 'availableCommands' typed: ACPAvailableCommand in: self updateDict
]

{ #category : 'accessing' }
ACPSessionUpdate >> entries [

	self isPlan ifFalse: [ ^ #() ].
	^ self valuesAt: 'entries' typed: ACPPlanEntry in: self updateDict
]

{ #category : 'accessing' }
ACPSessionUpdate >> toolCall [

	self isToolCall ifFalse: [ ^ nil ].
	^ ACPToolCall fromDictionary: self updateDict
]

{ #category : 'accessing' }
ACPSessionUpdate >> toolCallUpdate [

	self isToolCallUpdate ifFalse: [ ^ nil ].
	^ ACPToolCallUpdate fromDictionary: self updateDict
]

{ #category : 'testing' }
ACPSessionUpdate >> isAgentMessageChunk [

	^ self updateType = 'agent_message_chunk'
]

{ #category : 'testing' }
ACPSessionUpdate >> isAgentThoughtChunk [

	^ self updateType = 'agent_thought_chunk'
]

{ #category : 'testing' }
ACPSessionUpdate >> isAvailableCommandsUpdate [

	^ self updateType = 'available_commands_update'
]

{ #category : 'testing' }
ACPSessionUpdate >> isConfigOptionUpdate [

	^ self updateType = 'config_option_update'
]

{ #category : 'testing' }
ACPSessionUpdate >> isCurrentModeUpdate [

	^ self updateType = 'current_mode_update'
]

{ #category : 'testing' }
ACPSessionUpdate >> isPlan [

	^ self updateType = 'plan'
]

{ #category : 'testing' }
ACPSessionUpdate >> isSessionInfoUpdate [

	^ self updateType = 'session_info_update'
]

{ #category : 'testing' }
ACPSessionUpdate >> isToolCall [

	^ self updateType = 'tool_call'
]

{ #category : 'testing' }
ACPSessionUpdate >> isToolCallUpdate [

	^ self updateType = 'tool_call_update'
]

{ #category : 'testing' }
ACPSessionUpdate >> isUsageUpdate [

	^ self updateType = 'usage_update'
]

{ #category : 'testing' }
ACPSessionUpdate >> isUserMessageChunk [

	^ self updateType = 'user_message_chunk'
]

{ #category : 'accessing' }
ACPSessionUpdate >> currentModeId [

	^ self updateDict at: 'currentModeId' ifAbsent: []
]

{ #category : 'accessing' }
ACPSessionUpdate >> configOptions [

	self isConfigOptionUpdate ifFalse: [ ^ #() ].
	^ self valuesAt: 'configOptions' typed: ACPConfigOption in: self updateDict
]

{ #category : 'accessing' }
ACPSessionUpdate >> title [

	^ self updateDict at: 'title' ifAbsent: []
]

{ #category : 'accessing' }
ACPSessionUpdate >> updatedAt [

	^ self updateDict at: 'updatedAt' ifAbsent: []
]

{ #category : 'accessing' }
ACPSessionUpdate >> cost [

	^ self updateDict at: 'cost' ifAbsent: []
]

{ #category : 'accessing' }
ACPSessionUpdate >> size [

	^ self updateDict at: 'size' ifAbsent: []
]

{ #category : 'accessing' }
ACPSessionUpdate >> used [

	^ self updateDict at: 'used' ifAbsent: []
]
