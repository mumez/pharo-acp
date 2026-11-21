"
I represent a tool_call_update session update: a patch to a tool call reported earlier in the session.

Responsibility:
- I expose the patched fields of the tool call (toolCallId, name, status, content)
- I tell whether this patch sets the tool call's capabilities and whether it now advertises cancel

Collaborators:
- ACP2SessionUpdate: creates me via #toolCallUpdate
- ACP2ToolCallContent: the typed element of content
- ACP2ClientConnection: #cancelToolCall: sends tool_call/cancel for a cancellable tool call

Public API:
- toolCallId / name / status / content - the patched fields
- hasCapabilities - whether this patch sets capabilities (when false, the previous capabilities still apply)
- isCancellable - whether this patch advertises capabilities.cancel

Implementation Points:
- capabilities follows patch semantics: absent leaves it unchanged, while null or an object without cancel withdraws cancel
"
Class {
	#name : 'ACP2ToolCallUpdate',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2ToolCallUpdate >> content [

	^ self valuesAt: 'content' typed: ACP2ToolCallContent in: self rawValues
]

{ #category : 'accessing' }
ACP2ToolCallUpdate >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ToolCallUpdate >> status [

	^ self rawValues at: 'status' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ToolCallUpdate >> toolCallId [

	^ self rawValues at: 'toolCallId' ifAbsent: []
]

{ #category : 'testing' }
ACP2ToolCallUpdate >> hasCapabilities [

	^ self rawValues includesKey: 'capabilities'
]

{ #category : 'testing' }
ACP2ToolCallUpdate >> isCancellable [

	^ self advertisesCapability: 'cancel'
]
