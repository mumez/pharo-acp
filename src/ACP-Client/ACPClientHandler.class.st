Class {
	#name : 'ACPClientHandler',
	#superclass : 'Object',
	#pools : [
		'ACPConstants'
	],
	#category : 'ACP-Client',
	#package : 'ACP-Client'
}

{ #category : 'agent-callbacks - terminal' }
ACPClientHandler >> createTerminal: aDictionary [

	^ (ACPRequestError methodNotFound: ACPMethodTerminalCreate) signal
]

{ #category : 'agent-callbacks - terminal' }
ACPClientHandler >> killTerminal: aDictionary [

	^ (ACPRequestError methodNotFound: ACPMethodTerminalKill) signal
]

{ #category : 'agent-callbacks - filesystem' }
ACPClientHandler >> readTextFile: aDictionary [

	^ (ACPRequestError methodNotFound: ACPMethodReadTextFile) signal
]

{ #category : 'agent-callbacks - terminal' }
ACPClientHandler >> releaseTerminal: aDictionary [

	^ (ACPRequestError methodNotFound: ACPMethodTerminalRelease) signal
]

{ #category : 'agent-callbacks' }
ACPClientHandler >> requestPermission: anACPRequestPermission [
	"Request from agent for user permission (e.g. tool execution).
	anACPRequestPermission is ACPRequestPermission.
	Must return an ACPRequestPermissionResponse."

	^ self subclassResponsibility
]

{ #category : 'agent-callbacks' }
ACPClientHandler >> sessionUpdate: aSessionUpdate [
	"aSessionUpdate is ACPSessionUpdate"

	^ self subclassResponsibility
]

{ #category : 'agent-callbacks - terminal' }
ACPClientHandler >> terminalOutput: aDictionary [

	^ (ACPRequestError methodNotFound: ACPMethodTerminalOutput) signal
]

{ #category : 'agent-callbacks - terminal' }
ACPClientHandler >> waitForTerminalExit: aDictionary [

	^ (ACPRequestError methodNotFound: ACPMethodTerminalWaitForExit) signal
]

{ #category : 'agent-callbacks - filesystem' }
ACPClientHandler >> writeTextFile: aDictionary [

	^ (ACPRequestError methodNotFound: ACPMethodWriteTextFile) signal
]
