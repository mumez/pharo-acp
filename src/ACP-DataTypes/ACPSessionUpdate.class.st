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

	^ self rawValues at: 'type' ifAbsent: []
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

	^ self valuesAt: 'availableCommands' typed: ACPAvailableCommand in: self updateDict
]

{ #category : 'testing' }
ACPSessionUpdate >> isMessageChunk [

	^ self updateType = 'agent_message_chunk'
]

{ #category : 'testing' }
ACPSessionUpdate >> isAvailableCommandsUpdate [

	^ self updateType = 'available_commands_update'
]
