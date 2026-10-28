Class {
	#name : 'ACP2IncomingRequestTest',
	#superclass : 'TestCase',
	#category : 'ACP2-Tests',
	#package : 'ACP2-Tests'
}

{ #category : 'tests' }
ACP2IncomingRequestTest >> testCancelCancelsToken [

	| token request |
	token := ACP2CancellationToken new.
	request := ACP2IncomingRequest id: 1 process: nil token: token.
	request cancel.
	self assert: token isCancelled
]

{ #category : 'tests' }
ACP2IncomingRequestTest >> testTerminateDoesNotTerminateCallingProcess [

	| request |
	request := ACP2IncomingRequest
		           id: 1
		           process: Processor activeProcess
		           token: ACP2CancellationToken new.
	request terminate.
	self deny: Processor activeProcess isTerminated
]

{ #category : 'tests' }
ACP2IncomingRequestTest >> testTerminateTerminatesProcess [

	| process request |
	process := [ Semaphore new wait ] forkAt: Processor userBackgroundPriority.
	request := ACP2IncomingRequest id: 1 process: process token: ACP2CancellationToken new.
	request terminate.
	self assert: process isTerminated
]
