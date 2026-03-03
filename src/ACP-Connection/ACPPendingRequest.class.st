"
I represent an in-flight JSON-RPC request, allowing the sender to block until a response arrives.

Responsibility:
- I hold a Semaphore that the calling process waits on until a response is received
- I store the response result (on success) or error dictionary (on failure)
- I signal ACPRequestError if the response contains an error, otherwise I return the result

Collaborators:
- ACPConnection: creates me, stores me in pendingRequests, and calls #resolveWith: or #rejectWith: when the response arrives
- ACPRequestError: I signal it on error responses or timeout
- Semaphore: I use it internally to block the caller

Public API and Key Messages:
- #resolveWith: - store result and signal the semaphore (called by ACPConnection)
- #rejectWith: - store error and signal the semaphore (called by ACPConnection)
- #wait - block until resolved, then return result or signal ACPRequestError
- #waitWithTimeout: - like #wait but raises ACPRequestError on timeout

Internal Representation:
- semaphore - Semaphore used to block/unblock the waiting process
- result - the successful response result
- error - the error Dictionary on failure
- isResolved - true once either #resolveWith: or #rejectWith: has been called
"
Class {
	#name : 'ACPPendingRequest',
	#superclass : 'Object',
	#instVars : [
		'semaphore',
		'result',
		'error',
		'isResolved'
	],
	#category : 'ACP-Connection',
	#package : 'ACP-Connection'
}

{ #category : 'accessing' }
ACPPendingRequest >> error [

	^ error
]

{ #category : 'accessing' }
ACPPendingRequest >> error: anObject [

	error := anObject
]

{ #category : 'initialization' }
ACPPendingRequest >> initialize [

	super initialize.
	semaphore := Semaphore new.
	isResolved := false
]

{ #category : 'testing' }
ACPPendingRequest >> isResolved [

	^ isResolved
]

{ #category : 'accessing' }
ACPPendingRequest >> isResolved: aBoolean [

	isResolved := aBoolean
]

{ #category : 'actions' }
ACPPendingRequest >> rejectWith: anErrorDictionary [

	self error: anErrorDictionary.
	self isResolved: true.
	self semaphore signal
]

{ #category : 'actions' }
ACPPendingRequest >> resolveWith: aResult [

	self result: aResult.
	self isResolved: true.
	self semaphore signal
]

{ #category : 'accessing' }
ACPPendingRequest >> result [

	^ result
]

{ #category : 'accessing' }
ACPPendingRequest >> result: anObject [

	result := anObject
]

{ #category : 'accessing' }
ACPPendingRequest >> semaphore [

	^ semaphore
]

{ #category : 'actions' }
ACPPendingRequest >> wait [

	self semaphore wait.
	self error ifNotNil: [:err | ACPRequestError signalForRpcError: err ].
	^ self result
]

{ #category : 'actions' }
ACPPendingRequest >> waitWithTimeout: aDuration [

	(self semaphore waitTimeoutSeconds: aDuration asSeconds)
		ifTrue: [ ACPRequestError signal: 'Request timed out' ].
	self error ifNotNil: [:err | ACPRequestError signalForRpcError: err ].
	^ self result
]
