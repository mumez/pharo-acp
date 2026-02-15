Class {
	#name : 'ACPClientHandler',
	#superclass : 'Object',
	#category : 'ACP-Client'
}

{ #category : 'agent-callbacks' }
ACPClientHandler >> sessionUpdate: aDictionary [
	"Notification from agent about session state changes."

	^ self subclassResponsibility
]

{ #category : 'agent-callbacks' }
ACPClientHandler >> requestPermission: aDictionary [
	"Request from agent for user permission (e.g. tool execution)."

	^ self subclassResponsibility
]

{ #category : 'agent-callbacks - filesystem' }
ACPClientHandler >> readTextFile: aDictionary [

	^ (ACPRequestError methodNotFound: 'fs/read_text_file') signal
]

{ #category : 'agent-callbacks - filesystem' }
ACPClientHandler >> writeTextFile: aDictionary [

	^ (ACPRequestError methodNotFound: 'fs/write_text_file') signal
]

{ #category : 'agent-callbacks - terminal' }
ACPClientHandler >> createTerminal: aDictionary [

	^ (ACPRequestError methodNotFound: 'terminal/create') signal
]

{ #category : 'agent-callbacks - terminal' }
ACPClientHandler >> terminalOutput: aDictionary [

	^ (ACPRequestError methodNotFound: 'terminal/output') signal
]

{ #category : 'agent-callbacks - terminal' }
ACPClientHandler >> waitForTerminalExit: aDictionary [

	^ (ACPRequestError methodNotFound: 'terminal/wait_for_exit') signal
]

{ #category : 'agent-callbacks - terminal' }
ACPClientHandler >> killTerminal: aDictionary [

	^ (ACPRequestError methodNotFound: 'terminal/kill') signal
]

{ #category : 'agent-callbacks - terminal' }
ACPClientHandler >> releaseTerminal: aDictionary [

	^ (ACPRequestError methodNotFound: 'terminal/release') signal
]
