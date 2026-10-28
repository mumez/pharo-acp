Class {
	#name : 'ACP2CancellationTokenTest',
	#superclass : 'TestCase',
	#category : 'ACP2-Tests',
	#package : 'ACP2-Tests'
}

{ #category : 'tests' }
ACP2CancellationTokenTest >> testCancelRunsCallbacksOnce [

	| token count |
	token := ACP2CancellationToken new.
	count := 0.
	token whenCancelledDo: [ count := count + 1 ].
	self deny: token isCancelled.
	token cancel.
	token cancel.
	self assert: token isCancelled.
	self assert: count equals: 1
]

{ #category : 'tests' }
ACP2CancellationTokenTest >> testCurrentIsBoundDuringRequest [

	| token |
	token := ACP2CancellationToken new.
	ACP2CurrentCancellationToken
		value: token
		during: [ self assert: ACP2CancellationToken current identicalTo: token ]
]

{ #category : 'tests' }
ACP2CancellationTokenTest >> testCurrentOutsideRequestIsNotCancelled [

	self deny: ACP2CancellationToken current isCancelled
]

{ #category : 'tests' }
ACP2CancellationTokenTest >> testSignalIfCancelled [

	| token |
	token := ACP2CancellationToken new.
	token signalIfCancelled.
	token cancel.
	self should: [ token signalIfCancelled ] raise: ACP2RequestCancelled
]

{ #category : 'tests' }
ACP2CancellationTokenTest >> testRequestCancelledIsNotAnError [

	self deny: (ACP2RequestCancelled inheritsFrom: Error).
	self assert: (ACP2RequestCancelled inheritsFrom: Abort)
]

{ #category : 'tests' }
ACP2CancellationTokenTest >> testWhenCancelledDoAfterCancelRunsImmediately [

	| token ran |
	token := ACP2CancellationToken new.
	token cancel.
	ran := false.
	token whenCancelledDo: [ ran := true ].
	self assert: ran
]
