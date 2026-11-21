"
I represent a v2 subagent_update session update: it announces a child session of the current session and patches what the parent knows about it.

Responsibility:
- I identify the child session and expose its display metadata, capabilities, state, and directories
- I tell whether this patch sets capabilities or state at all

Collaborators:
- ACP2SessionUpdate: creates me via #subagentUpdate
- ACP2StateUpdate: the typed value of state

Public API:
- sessionId - the child session (always present)
- title / description - display metadata for the child
- hasCapabilities - whether this patch sets capabilities
- isCancellable - whether the child currently advertises capabilities.cancel
- hasState - whether this patch sets state
- state - the child's ACP2StateUpdate, or nil when absent or cleared
- cwd / additionalDirectories - where the agent placed the child (nil while inherited from the parent)

Implementation Points:
- Every field except sessionId follows patch semantics: absent leaves the stored value unchanged and null clears it.
  A null state removes the state report; it does not mean idle or cancelled
"
Class {
	#name : 'ACP2SubagentUpdate',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2SubagentUpdate >> additionalDirectories [

	^ self rawValues at: 'additionalDirectories' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACP2SubagentUpdate >> cwd [

	^ self rawValues at: 'cwd' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACP2SubagentUpdate >> description [

	^ self rawValues at: 'description' ifAbsent: [ nil ]
]

{ #category : 'testing' }
ACP2SubagentUpdate >> hasCapabilities [

	^ self rawValues includesKey: 'capabilities'
]

{ #category : 'testing' }
ACP2SubagentUpdate >> hasState [

	^ self rawValues includesKey: 'state'
]

{ #category : 'testing' }
ACP2SubagentUpdate >> isCancellable [

	^ self advertisesCapability: 'cancel'
]

{ #category : 'accessing' }
ACP2SubagentUpdate >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACP2SubagentUpdate >> state [

	| state |
	state := self rawValues at: 'state' ifAbsent: [ nil ].
	^ state isDictionary
		  ifTrue: [ ACP2StateUpdate fromDictionary: state ]
		  ifFalse: [ nil ]
]

{ #category : 'accessing' }
ACP2SubagentUpdate >> title [

	^ self rawValues at: 'title' ifAbsent: [ nil ]
]
