"
I represent one piece of background work that continues while a session is in a given state (v2 BackgroundWork).

Responsibility:
- I tell what kind of work it is (terminal, tool_call, subagent) and identify it

Collaborators:
- ACP2StateUpdate: the typed element of its background

Public API:
- type - the raw type string
- isTerminal / isToolCall / isSubagent - type tests
- terminalId - the terminal still running (type terminal)
- toolCallId - the tool call still running (type tool_call)
- sessionId - the child session still working (type subagent)
"
Class {
	#name : 'ACP2BackgroundWork',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'testing' }
ACP2BackgroundWork >> isSubagent [

	^ self type = 'subagent'
]

{ #category : 'testing' }
ACP2BackgroundWork >> isTerminal [

	^ self type = 'terminal'
]

{ #category : 'testing' }
ACP2BackgroundWork >> isToolCall [

	^ self type = 'tool_call'
]

{ #category : 'accessing' }
ACP2BackgroundWork >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACP2BackgroundWork >> terminalId [

	^ self rawValues at: 'terminalId' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACP2BackgroundWork >> toolCallId [

	^ self rawValues at: 'toolCallId' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACP2BackgroundWork >> type [

	^ self rawValues at: 'type' ifAbsent: [ nil ]
]
