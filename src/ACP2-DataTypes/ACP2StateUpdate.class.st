"
I represent a v2 StateUpdate snapshot: the activity state of a session, carried by a state_update session update or by the state field of a subagent_update.

Responsibility:
- I tell which state the session is in (running, idle, requires_action, unknown)
- I expose the stop reason of an idle transition, and the error details when it stopped with an error
- I list the background work that continues while the session is in this state

Collaborators:
- ACP2SessionUpdate: creates me via #stateUpdate for a state_update
- ACP2SubagentUpdate: creates me via #state for a child session's state
- ACP2BackgroundWork: the typed element of background

Public API:
- state - the raw state string
- isRunning / isIdle / isRequiresAction / isUnknown - state tests
- stopReason - the stop reason string; nil unless idle, and nil when omitted, null, or malformed
- isError - whether the idle transition ended with stopReason error
- error / errorCode / errorMessage - the JSON-RPC style error object of an error stop reason (nil when not given)
- background - the background work (empty when absent or null)

Implementation Points:
- error stays a plain Dictionary because ACP2-DataTypes does not depend on ACP2-Protocol (ACP2RequestError)
"
Class {
	#name : 'ACP2StateUpdate',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2StateUpdate >> background [

	^ self valuesAt: 'background' typed: ACP2BackgroundWork in: self rawValues
]

{ #category : 'accessing' }
ACP2StateUpdate >> error [

	| error |
	self isError ifFalse: [ ^ nil ].
	error := self rawValues at: 'error' ifAbsent: [ nil ].
	^ error isDictionary
		  ifTrue: [ error ]
		  ifFalse: [ nil ]
]

{ #category : 'accessing' }
ACP2StateUpdate >> errorCode [

	^ self error ifNotNil: [ :error | error at: 'code' ifAbsent: [ nil ] ]
]

{ #category : 'accessing' }
ACP2StateUpdate >> errorMessage [

	^ self error ifNotNil: [ :error | error at: 'message' ifAbsent: [ nil ] ]
]

{ #category : 'testing' }
ACP2StateUpdate >> isError [

	^ self stopReason = 'error'
]

{ #category : 'testing' }
ACP2StateUpdate >> isIdle [

	^ self state = 'idle'
]

{ #category : 'testing' }
ACP2StateUpdate >> isRequiresAction [

	^ self state = 'requires_action'
]

{ #category : 'testing' }
ACP2StateUpdate >> isRunning [

	^ self state = 'running'
]

{ #category : 'testing' }
ACP2StateUpdate >> isUnknown [

	^ self state = 'unknown'
]

{ #category : 'accessing' }
ACP2StateUpdate >> state [

	^ self rawValues at: 'state' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACP2StateUpdate >> stopReason [

	| stopReason |
	self isIdle ifFalse: [ ^ nil ].
	stopReason := self rawValues at: 'stopReason' ifAbsent: [ nil ].
	^ stopReason isString
		  ifTrue: [ stopReason ]
		  ifFalse: [ nil ]
]
