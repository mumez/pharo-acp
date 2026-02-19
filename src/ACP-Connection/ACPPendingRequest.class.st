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
