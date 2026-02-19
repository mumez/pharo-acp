Class {
	#name : 'ACPProcessLauncherTest',
	#superclass : 'TestCase',
	#instVars : [
		'launcher'
	],
	#category : 'ACP-Tests',
	#package : 'ACP-Tests'
}

{ #category : 'running' }
ACPProcessLauncherTest >> setUp [

	super setUp.
	launcher := ACPProcessLauncher new
]

{ #category : 'running' }
ACPProcessLauncherTest >> tearDown [

	launcher isRunning ifTrue: [ launcher terminate ].
	super tearDown
]

{ #category : 'tests - arguments' }
ACPProcessLauncherTest >> testArgumentsDefaultToEmpty [

	self assert: launcher arguments equals: #()
]

{ #category : 'tests - environment' }
ACPProcessLauncherTest >> testCustomEnvironmentVariable [
	"Verify custom env vars are passed to child process."

	| output process |
	launcher command: '/bin/sh'.
	launcher arguments: #('-c' 'echo $ACP_TEST_VAR').
	launcher environmentAt: 'ACP_TEST_VAR' put: 'test_value'.
	launcher launch.
	process := launcher process.
	process waitForExit.
	output := process stdoutStream upToEnd.
	self assert: (output trimRight) equals: 'test_value'
]

{ #category : 'tests - exit' }
ACPProcessLauncherTest >> testExitStatusOfFailedCommand [

	launcher command: '/bin/false'.
	launcher launch.
	launcher terminate.
	self assert: launcher exitStatus equals: 1
]

{ #category : 'tests - exit' }
ACPProcessLauncherTest >> testExitStatusOfSuccessfulCommand [

	launcher command: '/bin/true'.
	launcher launch.
	launcher terminate.
	self assert: launcher exitStatus equals: 0
]

{ #category : 'tests - lifecycle' }
ACPProcessLauncherTest >> testIsNotRunningBeforeLaunch [

	self deny: launcher isRunning
]

{ #category : 'tests - lifecycle' }
ACPProcessLauncherTest >> testLaunchStartsProcess [

	launcher command: '/bin/cat'.
	launcher launch.
	self assert: launcher isRunning
]

{ #category : 'tests - lifecycle' }
ACPProcessLauncherTest >> testRelaunchTerminatesPreviousProcess [

	launcher command: '/bin/cat'.
	launcher launch.
	self assert: launcher isRunning.
	launcher launch.
	self assert: launcher isRunning
]

{ #category : 'tests - arguments' }
ACPProcessLauncherTest >> testSetArguments [

	launcher arguments: #('--flag' 'value').
	self assert: launcher arguments equals: #('--flag' 'value')
]

{ #category : 'tests - arguments' }
ACPProcessLauncherTest >> testSetCommand [

	launcher command: '/bin/echo'.
	self assert: launcher command equals: '/bin/echo'
]

{ #category : 'tests - arguments' }
ACPProcessLauncherTest >> testSetWorkingDirectory [

	launcher workingDirectory: '/tmp'.
	self assert: launcher workingDirectory equals: '/tmp'
]

{ #category : 'tests - io' }
ACPProcessLauncherTest >> testStdinStdoutWithEcho [
	"Use echo via sh to test stdout reading after process exits (no blocking)."

	| output process |
	launcher command: '/bin/sh'.
	launcher arguments: #('-c' 'echo hello').
	launcher launch.
	process := launcher process.
	process waitForExit.
	output := process stdoutStream upToEnd.
	self assert: (output trimRight) equals: 'hello'
]

{ #category : 'tests - lifecycle' }
ACPProcessLauncherTest >> testTerminateStopsProcess [

	launcher command: '/bin/cat'.
	launcher launch.
	launcher terminate.
	self deny: launcher isRunning
]
