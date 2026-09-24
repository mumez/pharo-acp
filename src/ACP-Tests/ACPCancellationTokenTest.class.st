Class {
	#name : 'ACPCancellationTokenTest',
	#superclass : 'TestCase',
	#category : 'ACP-Tests',
	#package : 'ACP-Tests'
}

{ #category : 'tests' }
ACPCancellationTokenTest >> testCancelRunsCallbacksOnce [

	| token count |
	token := ACPCancellationToken new.
	count := 0.
	token whenCancelledDo: [ count := count + 1 ].
	self deny: token isCancelled.
	token cancel.
	token cancel.
	self assert: token isCancelled.
	self assert: count equals: 1
]

{ #category : 'tests' }
ACPCancellationTokenTest >> testCurrentIsBoundDuringRequest [

	| token |
	token := ACPCancellationToken new.
	ACPCurrentCancellationToken
		value: token
		during: [ self assert: ACPCancellationToken current identicalTo: token ]
]

{ #category : 'tests' }
ACPCancellationTokenTest >> testCurrentOutsideRequestIsNotCancelled [

	self deny: ACPCancellationToken current isCancelled
]

{ #category : 'tests' }
ACPCancellationTokenTest >> testSignalIfCancelled [

	| token |
	token := ACPCancellationToken new.
	token signalIfCancelled.
	token cancel.
	self should: [ token signalIfCancelled ] raise: ACPRequestCancelled
]

{ #category : 'tests' }
ACPCancellationTokenTest >> testRequestCancelledIsNotAnError [

	self deny: (ACPRequestCancelled inheritsFrom: Error).
	self assert: (ACPRequestCancelled inheritsFrom: Abort)
]

{ #category : 'tests' }
ACPCancellationTokenTest >> testWhenCancelledDoAfterCancelRunsImmediately [

	| token ran |
	token := ACPCancellationToken new.
	token cancel.
	ran := false.
	token whenCancelledDo: [ ran := true ].
	self assert: ran
]
