"
I represent an in-flight JSON-RPC request, allowing the sender to block until a response arrives.

Responsibility:
- I hold a Semaphore that the calling process waits on until a response is received
- I store the response result (on success) or error dictionary (on failure)
- I signal ACP2RequestError if the response contains an error, otherwise I return the result

Collaborators:
- ACP2Connection: creates me, stores me in pendingRequests, and calls #resolveWith: or #rejectWith: when the response arrives
- ACP2RequestError: I signal it on error responses or timeout
- Semaphore: I use it internally to block the caller

Public API and Key Messages:
- #resolveWith: - store result and signal the semaphore (called by ACP2Connection)
- #rejectWith: - store error and signal the semaphore (called by ACP2Connection)
- #wait - block until resolved, then return result or signal ACP2RequestError
- #waitWithTimeout: - like #wait but raises ACP2RequestError on timeout

Internal Representation:
- semaphore - Semaphore used to block/unblock the waiting process
- result - the successful response result
- error - the error Dictionary on failure
- isResolved - true once either #resolveWith: or #rejectWith: has been called
"
Class {
	#name : 'ACP2PendingRequest',
	#superclass : 'Object',
	#instVars : [
		'semaphore',
		'result',
		'error',
		'isResolved'
	],
	#category : 'ACP2-Connection',
	#package : 'ACP2-Connection'
}

{ #category : 'accessing' }
ACP2PendingRequest >> error [

	^ error
]

{ #category : 'accessing' }
ACP2PendingRequest >> error: anObject [

	error := anObject
]

{ #category : 'initialization' }
ACP2PendingRequest >> initialize [

	super initialize.
	semaphore := Semaphore new.
	isResolved := false
]

{ #category : 'testing' }
ACP2PendingRequest >> isResolved [

	^ isResolved
]

{ #category : 'accessing' }
ACP2PendingRequest >> isResolved: aBoolean [

	isResolved := aBoolean
]

{ #category : 'actions' }
ACP2PendingRequest >> rejectWith: anErrorDictionary [

	self error: anErrorDictionary.
	self isResolved: true.
	self semaphore signal
]

{ #category : 'actions' }
ACP2PendingRequest >> resolveWith: aResult [

	self result: aResult.
	self isResolved: true.
	self semaphore signal
]

{ #category : 'accessing' }
ACP2PendingRequest >> result [

	^ result
]

{ #category : 'accessing' }
ACP2PendingRequest >> result: anObject [

	result := anObject
]

{ #category : 'accessing' }
ACP2PendingRequest >> semaphore [

	^ semaphore
]

{ #category : 'actions' }
ACP2PendingRequest >> wait [

	self semaphore wait.
	self error ifNotNil: [:err | ACP2RequestError signalForRpcError: err ].
	^ self result
]

{ #category : 'actions' }
ACP2PendingRequest >> waitWithTimeout: aDuration [

	(self semaphore waitTimeoutSeconds: aDuration asSeconds)
		ifTrue: [ ACP2RequestError signal: 'Request timed out' ].
	self error ifNotNil: [:err | ACP2RequestError signalForRpcError: err ].
	^ self result
]
