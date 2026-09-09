"
I wrap OSSUnixSubprocess to launch and manage an ACP agent subprocess with stdin/stdout pipes.

Responsibility:
- I launch the agent process with configured command, arguments, working directory, and environment
- I expose typed stream accessors for stdin (writer) and stdout (reader)
- I perform graceful shutdown: close stdin → wait → SIGTERM → wait → SIGKILL
- I sanitize environment variables that may contain WideStrings (e.g. Japanese chars in PATH)

Collaborators:
- OSSUnixSubprocess: the underlying subprocess I configure and run
- ACP2NdJsonTransport: reads my stdinStream/stdoutStream after launch
- ACP2Client: configures me and calls #launch / #terminate

Public API and Key Messages:
- #launch - start the subprocess; terminates any previously running process first
- #terminate - graceful shutdown with escalation (stdin close → SIGTERM → SIGKILL)
- #stdinStream - returns the stdin writer for sending data to the agent
- #stdoutStream - returns the stdout reader for receiving agent output
- #isRunning - true if the subprocess is alive
- #command: / #arguments: / #workingDirectory: - configure before calling #launch

Internal Representation:
- command - executable path string
- arguments - Array of argument strings
- workingDirectory - optional working directory string
- envVariables - Dictionary of custom environment variable overrides
- process - the OSSUnixSubprocess instance

Implementation Points:
- OSSubprocess memCopy fails on WideStrings; #ensureByteString: converts them to UTF-8 ByteStrings before passing to OSSUnixSubprocess
- The full parent environment is copied first, then custom variables are overlaid
- #stdoutStream uses non-blocking pipes; ACP2NdJsonTransport polls for data with a delay
"
Class {
	#name : 'ACP2ProcessLauncher',
	#superclass : 'Object',
	#instVars : [
		'command',
		'arguments',
		'workingDirectory',
		'envVariables',
		'process'
	],
	#category : 'ACP2-Transport',
	#package : 'ACP2-Transport'
}

{ #category : 'accessing' }
ACP2ProcessLauncher >> arguments [

	^ arguments
]

{ #category : 'accessing' }
ACP2ProcessLauncher >> arguments: anArray [

	arguments := anArray
]

{ #category : 'accessing' }
ACP2ProcessLauncher >> command [

	^ command
]

{ #category : 'accessing' }
ACP2ProcessLauncher >> command: aString [

	command := aString
]

{ #category : 'private' }
ACP2ProcessLauncher >> ensureByteString: aString [
	"Convert a potentially WideString to a ByteString with UTF-8 encoding.
	OSSubprocess memCopy requires ByteString (responds to tfPointerAddress)."

	aString isWideString ifFalse: [ ^ aString ].
	^ aString utf8Encoded asString
]

{ #category : 'accessing' }
ACP2ProcessLauncher >> environmentAt: aKey put: aValue [

	envVariables at: aKey put: aValue
]

{ #category : 'accessing' }
ACP2ProcessLauncher >> exitStatus [

	^ self process exitStatusInterpreter exitStatus
]

{ #category : 'initialization' }
ACP2ProcessLauncher >> initialize [

	super initialize.
	arguments := #().
	envVariables := Dictionary new
]

{ #category : 'testing' }
ACP2ProcessLauncher >> isRunning [

	^ self process isNotNil and: [ self process isRunning ]
]

{ #category : 'operations' }
ACP2ProcessLauncher >> launch [

	self isRunning ifTrue: [ self terminate ].
	process := OSSUnixSubprocess new
		command: command;
		arguments: arguments;
		redirectStdin;
		redirectStdout;
		redirectStderr;
		yourself.
	self setupEnvironmentOn: self process.
	self workingDirectory ifNotNil: [
		self process workingDirectory: self workingDirectory ].
	self process run
]

{ #category : 'private' }
ACP2ProcessLauncher >> process [

	^ process
]

{ #category : 'private' }
ACP2ProcessLauncher >> setupEnvironmentOn: aProcess [
	"Copy parent environment variables with WideString safety,
	then overlay custom variables. OSSubprocess cannot memCopy WideStrings."

	OSEnvironment current asDictionary keysAndValuesDo: [ :key :value |
		aProcess
			environmentAt: (self ensureByteString: key)
			put: (self ensureByteString: value) ].
	envVariables keysAndValuesDo: [ :key :value |
		aProcess environmentAt: key put: value ]
]

{ #category : 'accessing' }
ACP2ProcessLauncher >> stdinStream [

	^ self process stdinStream writer
]

{ #category : 'accessing' }
ACP2ProcessLauncher >> stdoutStream [
	"Return the stdout reader (OSSAttachableFileStream). Non-blocking by default."

	^ self process stdoutStream reader
]

{ #category : 'operations' }
ACP2ProcessLauncher >> terminate [
	"Graceful shutdown escalation: close stdin → wait → SIGTERM → wait → SIGKILL."

	self process ifNil: [ ^ self ].
	[ self process stdinStream close ] on: Error do: [ :e | ].
	[ self process waitForExitWithTimeout: 5 seconds. ^ self ]
		on: OSSTimeout
		do: [ :e | ].
	[ self process sigterm ] on: Error do: [ :e | ^ self ].
	[ self process waitForExitWithTimeout: 3 seconds. ^ self ]
		on: OSSTimeout
		do: [ :e | ].
	[ self process sigkill ] on: Error do: [ :e | ]
]

{ #category : 'accessing' }
ACP2ProcessLauncher >> workingDirectory [

	^ workingDirectory
]

{ #category : 'accessing' }
ACP2ProcessLauncher >> workingDirectory: aString [

	workingDirectory := aString
]
