"
I am a test double for an ACPProcessLauncher whose agent process has already exited.

Responsibility:
- I answer false to #isRunning so the transport treats the read stream as ended

Collaborators:
- ACPNdJsonTransport: asks me #isRunning via #processLauncher
- ACPNdJsonTransportTest: installs me with #processLauncher:

Public API and Key Messages:
- #isRunning - always false
"
Class {
	#name : 'ACPExitedProcessLauncher',
	#superclass : 'Object',
	#category : 'ACP-Tests',
	#package : 'ACP-Tests'
}

{ #category : 'testing' }
ACPExitedProcessLauncher >> isRunning [

	^ false
]
