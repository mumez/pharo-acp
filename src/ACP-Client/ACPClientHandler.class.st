"
I am the abstract base class defining the callback interface for agent-initiated requests.

Responsibility:
- I declare the two required callbacks that subclasses must implement: #sessionUpdate: and #requestPermission:
- I provide default implementations for terminal and filesystem callbacks that signal methodNotFound, allowing subclasses to opt in selectively

Collaborators:
- ACPClientConnection: registers my methods as handlers and calls them when the agent sends requests or notifications
- ACPSessionUpdate: passed to #sessionUpdate: on each agent progress notification
- ACPRequestPermission: passed to #requestPermission:; the method must return an ACPRequestPermissionResponse
- ACPCreateElicitation / ACPCompleteElicitation: passed to the elicitation callbacks

Public API and Key Messages:
- #sessionUpdate: - called on each session/update notification (streaming progress); subclasses must implement
- #requestPermission: - called when the agent requests user permission for a tool; must return ACPRequestPermissionResponse; subclasses must implement
- #readTextFile: / #writeTextFile: - filesystem callbacks; default signals methodNotFound
- #createTerminal: / #terminalOutput: / #waitForTerminalExit: / #killTerminal: / #releaseTerminal: - terminal callbacks; default signals methodNotFound
- #createElicitation: - ask the user for input (form or URL mode); must return an ACPCreateElicitationResponse; default signals invalidParams (-32602)
- #completeElicitation: - a URL-mode elicitation finished; default ignores it

Implementation Points:
- Subclass and implement at minimum #sessionUpdate: and #requestPermission:
- Override terminal/filesystem methods only if the agent requires those capabilities
- To support elicitation, override #createElicitation: (and #completeElicitation: for URL mode) and advertise
  the implemented modes, e.g. initializeBy: [ :p | p capabilities elicitation enableForm ]
- See ACPTranscriptHandler for a minimal concrete example
"
Class {
	#name : 'ACPClientHandler',
	#superclass : 'Object',
	#pools : [
		'ACPConstants'
	],
	#category : 'ACP-Client',
	#package : 'ACP-Client'
}

{ #category : 'agent-callbacks - elicitation' }
ACPClientHandler >> completeElicitation: anACPCompleteElicitation [
	"Notification from the agent that the URL-mode elicitation with anACPCompleteElicitation elicitationId finished.
	 Unknown or already-completed IDs must be ignored."

	^ self
]

{ #category : 'agent-callbacks - elicitation' }
ACPClientHandler >> createElicitation: anACPCreateElicitation [
	"Request from the agent to ask the user for input. Must return an ACPCreateElicitationResponse
	 (see anACPCreateElicitation makeResponse): accept: with the submitted content, decline, or cancel.
	 Only called for modes advertised in the client capabilities (other form/url requests are rejected
	 with -32602 before reaching here).
	 - Form mode: render anACPCreateElicitation requestedSchema, pre-populate defaults, validate the input.
	 - URL mode: show the full URL and its host (#urlHost), and open it only after the user consents;
	   never prefetch it or open it automatically.
	 While waiting for the user, use ACPCancellationToken current (e.g. #whenCancelledDo:) to stop
	 when the agent cancels the request."

	^ (ACPRequestError invalidParams: 'Elicitation is not supported by this client') signal
]

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
