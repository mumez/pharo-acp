"
I am a test double for an ACP2ProcessLauncher whose agent process has already exited.

Responsibility:
- I answer false to #isRunning so the transport treats the read stream as ended

Collaborators:
- ACP2NdJsonTransport: asks me #isRunning via #processLauncher
- ACP2NdJsonTransportTest: installs me with #processLauncher:

Public API and Key Messages:
- #isRunning - always false
"
Class {
	#name : 'ACP2ExitedProcessLauncher',
	#superclass : 'Object',
	#category : 'ACP2-Tests',
	#package : 'ACP2-Tests'
}

{ #category : 'testing' }
ACP2ExitedProcessLauncher >> isRunning [

	^ false
]
