"
I tell a request handler that the agent has cancelled the incoming request it is handling ($/cancel_request).

Responsibility:
- I record whether the request has been cancelled
- I run callbacks registered by the handler when the cancellation arrives, so a handler that is
  waiting (for example, for user input) can wake up and stop

Collaborators:
- ACPConnection: creates one of me per incoming request and sends #cancel when $/cancel_request arrives
- ACPCurrentCancellationToken: makes me available to the handler as #current
- ACPRequestCancelled: signaled by #signalIfCancelled

Public API and Key Messages:
- #current (class side) - the token of the request handled by the current process
  (a token that is never cancelled when called outside of an incoming request)
- #isCancelled - true once the request has been cancelled
- #whenCancelledDo: - evaluate a block when cancelled (immediately if already cancelled)
- #signalIfCancelled - signal ACPRequestCancelled if cancelled; the connection then responds with -32800
- #cancel - mark as cancelled and run the callbacks (called by ACPConnection)

Example:
	| token answered |
	token := ACPCancellationToken current.
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
	#name : 'ACPCancellationToken',
	#superclass : 'Object',
	#instVars : [
		'isCancelled',
		'callbacks',
		'mutex'
	],
	#category : 'ACP-Connection',
	#package : 'ACP-Connection'
}

{ #category : 'accessing' }
ACPCancellationToken class >> current [

	^ ACPCurrentCancellationToken value ifNil: [ self new ]
]

{ #category : 'operations' }
ACPCancellationToken >> cancel [

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
ACPCancellationToken >> initialize [

	super initialize.
	isCancelled := false.
	callbacks := OrderedCollection new.
	mutex := Mutex new
]

{ #category : 'testing' }
ACPCancellationToken >> isCancelled [

	^ isCancelled
]

{ #category : 'operations' }
ACPCancellationToken >> signalIfCancelled [

	self isCancelled ifTrue: [ ACPRequestCancelled new signal ]
]

{ #category : 'operations' }
ACPCancellationToken >> whenCancelledDo: aBlock [

	| runNow |
	runNow := mutex critical: [
		          isCancelled ifFalse: [ callbacks add: aBlock ].
		          isCancelled ].
	runNow ifTrue: [ aBlock value ]
]
