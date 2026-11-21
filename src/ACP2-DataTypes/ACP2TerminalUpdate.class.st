"
I represent a v2 terminal_update session update: an upsert for the stored state of an agent-owned terminal.

Responsibility:
- I identify the terminal and expose its command, working directory, output, exit status, and size
- I tell whether this patch sets capabilities and whether the terminal now advertises cancel

Collaborators:
- ACP2SessionUpdate: creates me via #terminalUpdate
- ACP2ClientConnection: #cancelTerminal: sends terminal/cancel for a cancellable terminal

Public API:
- terminalId - the terminal (always present)
- command / cwd - how the terminal was started
- outputData - the output text, or nil
- hasExited / exitCode / signal - the exit status (nil fields while still running)
- hasSize / columns / rows - the terminal size (cols and rows on the wire)
- hasCapabilities - whether this patch sets capabilities (when false, the previous capabilities still apply)
- isCancellable - whether this patch advertises capabilities.cancel

Implementation Points:
- Every field except terminalId follows patch semantics: absent leaves the stored value unchanged and null clears it.
  Use rawValues includesKey: (or hasSize / hasCapabilities) to tell an absent field from a cleared one
- hasExited answers true only for a concrete exitStatus object, so a cleared (null) exitStatus reads as not exited, like an absent one;
  use rawValues includesKey: 'exitStatus' when the difference matters
"
Class {
	#name : 'ACP2TerminalUpdate',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2TerminalUpdate >> columns [

	^ self field: 'cols' of: 'size'
]

{ #category : 'accessing' }
ACP2TerminalUpdate >> command [

	^ self rawValues at: 'command' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACP2TerminalUpdate >> cwd [

	^ self rawValues at: 'cwd' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACP2TerminalUpdate >> exitCode [

	^ self field: 'exitCode' of: 'exitStatus'
]

{ #category : 'private' }
ACP2TerminalUpdate >> field: fieldName of: propName [

	| nested |
	nested := self rawValues at: propName ifAbsent: [ nil ].
	nested isDictionary ifFalse: [ ^ nil ].
	^ nested at: fieldName ifAbsent: [ nil ]
]

{ #category : 'testing' }
ACP2TerminalUpdate >> hasCapabilities [

	^ self rawValues includesKey: 'capabilities'
]

{ #category : 'testing' }
ACP2TerminalUpdate >> hasExited [

	^ (self rawValues at: 'exitStatus' ifAbsent: [ nil ]) isDictionary
]

{ #category : 'testing' }
ACP2TerminalUpdate >> hasSize [

	^ self rawValues includesKey: 'size'
]

{ #category : 'testing' }
ACP2TerminalUpdate >> isCancellable [

	^ self advertisesCapability: 'cancel'
]

{ #category : 'accessing' }
ACP2TerminalUpdate >> outputData [

	^ self field: 'data' of: 'output'
]

{ #category : 'accessing' }
ACP2TerminalUpdate >> rows [

	^ self field: 'rows' of: 'size'
]

{ #category : 'accessing' }
ACP2TerminalUpdate >> signal [

	^ self field: 'signal' of: 'exitStatus'
]

{ #category : 'accessing' }
ACP2TerminalUpdate >> terminalId [

	^ self rawValues at: 'terminalId' ifAbsent: [ nil ]
]
