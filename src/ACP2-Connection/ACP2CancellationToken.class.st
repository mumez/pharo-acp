"
I tell a request handler that the agent has cancelled the incoming request it is handling ($/cancel_request).

Responsibility:
- I record whether the request has been cancelled
- I run callbacks registered by the handler when the cancellation arrives, so a handler that is
  waiting (for example, for user input) can wake up and stop

Collaborators:
- ACP2Connection: creates one of me per incoming request and sends #cancel when $/cancel_request arrives
- ACP2CurrentCancellationToken: makes me available to the handler as #current
- ACP2RequestCancelled: signaled by #signalIfCancelled

Public API and Key Messages:
- #current (class side) - the token of the request handled by the current process
  (a token that is never cancelled when called outside of an incoming request)
- #isCancelled - true once the request has been cancelled
- #whenCancelledDo: - evaluate a block when cancelled (immediately if already cancelled)
- #signalIfCancelled - signal ACP2RequestCancelled if cancelled; the connection then responds with -32800
- #cancel - mark as cancelled and run the callbacks (called by ACP2Connection)

Example:
	| token answered |
	token := ACP2CancellationToken current.
	answered := Semaphore new.
	token whenCancelledDo: [ answered signal ].
	self askUserThenSignal: answered.
	answered wait.
	token signalIfCancelled.

Internal Representation:
- isCancelled - Boolean
- callbacks - blocks to evaluate on cancellation
- mutex - guards isCancelled and callbacks

Implementation Points:
- Cancellation is cooperative: a handler that never checks me simply completes, and its result is sent as usual
- Callbacks run in the process that sends #cancel (the connection's read loop), so they should be short,
  e.g. signaling a semaphore
"
Class {
	#name : 'ACP2CancellationToken',
	#superclass : 'Object',
	#instVars : [
		'isCancelled',
		'callbacks',
		'mutex'
	],
	#category : 'ACP2-Connection',
	#package : 'ACP2-Connection'
}

{ #category : 'accessing' }
ACP2CancellationToken class >> current [

	^ ACP2CurrentCancellationToken value ifNil: [ self new ]
]

{ #category : 'operations' }
ACP2CancellationToken >> cancel [

	| toRun |
	toRun := mutex critical: [
		         isCancelled
			         ifTrue: [ #(  ) ]
			         ifFalse: [
				         | blocks |
				         isCancelled := true.
				         blocks := callbacks.
				         callbacks := OrderedCollection new.
				         blocks ] ].
	toRun do: [ :each | each value ]
]

{ #category : 'initialization' }
ACP2CancellationToken >> initialize [

	super initialize.
	isCancelled := false.
	callbacks := OrderedCollection new.
	mutex := Mutex new
]

{ #category : 'testing' }
ACP2CancellationToken >> isCancelled [

	^ isCancelled
]

{ #category : 'operations' }
ACP2CancellationToken >> signalIfCancelled [

	self isCancelled ifTrue: [ ACP2RequestCancelled new signal ]
]

{ #category : 'operations' }
ACP2CancellationToken >> whenCancelledDo: aBlock [

	| runNow |
	runNow := mutex critical: [
		          isCancelled ifFalse: [ callbacks add: aBlock ].
		          isCancelled ].
	runNow ifTrue: [ aBlock value ]
]
