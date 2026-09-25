Class {
	#name : 'ACPIncomingRequestTest',
	#superclass : 'TestCase',
	#category : 'ACP-Tests',
	#package : 'ACP-Tests'
}

{ #category : 'tests' }
ACPIncomingRequestTest >> testCancelCancelsToken [

	| token request |
	token := ACPCancellationToken new.
	request := ACPIncomingRequest id: 1 process: nil token: token.
	request cancel.
	self assert: token isCancelled
]

{ #category : 'tests' }
ACPIncomingRequestTest >> testTerminateDoesNotTerminateCallingProcess [

	| request |
	request := ACPIncomingRequest
		           id: 1
		           process: Processor activeProcess
		           token: ACPCancellationToken new.
	request terminate.
	self deny: Processor activeProcess isTerminated
]

{ #category : 'tests' }
ACPIncomingRequestTest >> testTerminateTerminatesProcess [

	| process request |
	process := [ Semaphore new wait ] forkAt: Processor userBackgroundPriority.
	request := ACPIncomingRequest id: 1 process: process token: ACPCancellationToken new.
	request terminate.
	self assert: process isTerminated
]
