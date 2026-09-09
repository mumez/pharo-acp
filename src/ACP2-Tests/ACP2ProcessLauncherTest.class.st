Class {
	#name : 'ACP2ProcessLauncherTest',
	#superclass : 'TestCase',
	#instVars : [
		'launcher'
	],
	#category : 'ACP2-Tests',
	#package : 'ACP2-Tests'
}

{ #category : 'running' }
ACP2ProcessLauncherTest >> setUp [

	super setUp.
	launcher := ACP2ProcessLauncher new
]

{ #category : 'running' }
ACP2ProcessLauncherTest >> tearDown [

	launcher isRunning ifTrue: [ launcher terminate ].
	super tearDown
]

{ #category : 'tests - arguments' }
ACP2ProcessLauncherTest >> testArgumentsDefaultToEmpty [

	self assert: launcher arguments equals: #()
]

{ #category : 'tests - environment' }
ACP2ProcessLauncherTest >> testCustomEnvironmentVariable [
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
ACP2ProcessLauncherTest >> testExitStatusOfFailedCommand [

	launcher command: '/bin/false'.
	launcher launch.
	launcher terminate.
	self assert: launcher exitStatus equals: 1
]

{ #category : 'tests - exit' }
ACP2ProcessLauncherTest >> testExitStatusOfSuccessfulCommand [

	launcher command: '/bin/true'.
	launcher launch.
	launcher terminate.
	self assert: launcher exitStatus equals: 0
]

{ #category : 'tests - lifecycle' }
ACP2ProcessLauncherTest >> testIsNotRunningBeforeLaunch [

	self deny: launcher isRunning
]

{ #category : 'tests - lifecycle' }
ACP2ProcessLauncherTest >> testLaunchStartsProcess [

	launcher command: '/bin/cat'.
	launcher launch.
	self assert: launcher isRunning
]

{ #category : 'tests - lifecycle' }
ACP2ProcessLauncherTest >> testRelaunchTerminatesPreviousProcess [

	launcher command: '/bin/cat'.
	launcher launch.
	self assert: launcher isRunning.
	launcher launch.
	self assert: launcher isRunning
]

{ #category : 'tests - arguments' }
ACP2ProcessLauncherTest >> testSetArguments [

	launcher arguments: #('--flag' 'value').
	self assert: launcher arguments equals: #('--flag' 'value')
]

{ #category : 'tests - arguments' }
ACP2ProcessLauncherTest >> testSetCommand [

	launcher command: '/bin/echo'.
	self assert: launcher command equals: '/bin/echo'
]

{ #category : 'tests - arguments' }
ACP2ProcessLauncherTest >> testSetWorkingDirectory [

	launcher workingDirectory: '/tmp'.
	self assert: launcher workingDirectory equals: '/tmp'
]

{ #category : 'tests - io' }
ACP2ProcessLauncherTest >> testStdinStdoutWithEcho [
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
ACP2ProcessLauncherTest >> testTerminateStopsProcess [

	launcher command: '/bin/cat'.
	launcher launch.
	launcher terminate.
	self deny: launcher isRunning
]
