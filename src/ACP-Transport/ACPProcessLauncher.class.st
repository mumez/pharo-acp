Class {
	#name : 'ACPProcessLauncher',
	#superclass : 'Object',
	#instVars : [
		'command',
		'arguments',
		'workingDirectory',
		'envVariables',
		'process'
	],
	#category : 'ACP-Transport',
	#package : 'ACP-Transport'
}

{ #category : 'accessing' }
ACPProcessLauncher >> arguments [

	^ arguments
]

{ #category : 'accessing' }
ACPProcessLauncher >> arguments: anArray [

	arguments := anArray
]

{ #category : 'accessing' }
ACPProcessLauncher >> command [

	^ command
]

{ #category : 'accessing' }
ACPProcessLauncher >> command: aString [

	command := aString
]

{ #category : 'private' }
ACPProcessLauncher >> ensureByteString: aString [
	"Convert a potentially WideString to a ByteString with UTF-8 encoding.
	OSSubprocess memCopy requires ByteString (responds to tfPointerAddress)."

	aString isWideString ifFalse: [ ^ aString ].
	^ aString utf8Encoded asString
]

{ #category : 'accessing' }
ACPProcessLauncher >> environmentAt: aKey put: aValue [

	envVariables at: aKey put: aValue
]

{ #category : 'accessing' }
ACPProcessLauncher >> exitStatus [

	^ self process exitStatusInterpreter exitStatus
]

{ #category : 'initialization' }
ACPProcessLauncher >> initialize [

	super initialize.
	arguments := #().
	envVariables := Dictionary new
]

{ #category : 'testing' }
ACPProcessLauncher >> isRunning [

	^ self process isNotNil and: [ self process isRunning ]
]

{ #category : 'operations' }
ACPProcessLauncher >> launch [

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
ACPProcessLauncher >> process [

	^ process
]

{ #category : 'private' }
ACPProcessLauncher >> setupEnvironmentOn: aProcess [
	"Copy parent environment variables with WideString safety,
	then overlay custom variables. OSSubprocess cannot memCopy WideStrings."

	Smalltalk os environment asDictionary keysAndValuesDo: [ :key :value |
		aProcess
			environmentAt: (self ensureByteString: key)
			put: (self ensureByteString: value) ].
	envVariables keysAndValuesDo: [ :key :value |
		aProcess environmentAt: key put: value ]
]

{ #category : 'accessing' }
ACPProcessLauncher >> stdinStream [

	^ self process stdinStream writer
]

{ #category : 'accessing' }
ACPProcessLauncher >> stdoutStream [
	"Return the stdout OSSPipe. Non-blocking by default."

	^ self process stdoutStream
]

{ #category : 'operations' }
ACPProcessLauncher >> terminate [
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
ACPProcessLauncher >> workingDirectory [

	^ workingDirectory
]

{ #category : 'accessing' }
ACPProcessLauncher >> workingDirectory: aString [

	workingDirectory := aString
]
