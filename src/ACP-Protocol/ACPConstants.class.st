Class {
	#name : 'ACPConstants',
	#superclass : 'SharedPool',
	#classVars : [
		'ACPMethodAuthenticate',
		'ACPMethodInitialize',
		'ACPMethodReadTextFile',
		'ACPMethodRequestPermission',
		'ACPMethodSessionCancel',
		'ACPMethodSessionFork',
		'ACPMethodSessionList',
		'ACPMethodSessionLoad',
		'ACPMethodSessionNew',
		'ACPMethodSessionPrompt',
		'ACPMethodSessionResume',
		'ACPMethodSessionSetConfigOption',
		'ACPMethodSessionSetMode',
		'ACPMethodSessionSetModel',
		'ACPMethodSessionUpdate',
		'ACPMethodTerminalCreate',
		'ACPMethodTerminalKill',
		'ACPMethodTerminalOutput',
		'ACPMethodTerminalRelease',
		'ACPMethodTerminalWaitForExit',
		'ACPMethodWriteTextFile',
		'ACPProtocolVersion'
	],
	#category : 'ACP-Protocol'
}

{ #category : 'accessing' }
ACPConstants class >> protocolVersion [

	^ ACPProtocolVersion
]

{ #category : 'class initialization' }
ACPConstants class >> initialize [

	self initializeProtocolVersion.
	self initializeClientToAgentMethods.
	self initializeAgentToClientMethods
]

{ #category : 'class initialization' }
ACPConstants class >> initializeAgentToClientMethods [

	ACPMethodSessionUpdate := 'session/update'.
	ACPMethodRequestPermission := 'session/request_permission'.
	ACPMethodReadTextFile := 'fs/read_text_file'.
	ACPMethodWriteTextFile := 'fs/write_text_file'.
	ACPMethodTerminalCreate := 'terminal/create'.
	ACPMethodTerminalOutput := 'terminal/output'.
	ACPMethodTerminalWaitForExit := 'terminal/wait_for_exit'.
	ACPMethodTerminalKill := 'terminal/kill'.
	ACPMethodTerminalRelease := 'terminal/release'
]

{ #category : 'class initialization' }
ACPConstants class >> initializeClientToAgentMethods [

	ACPMethodInitialize := 'initialize'.
	ACPMethodAuthenticate := 'authenticate'.
	ACPMethodSessionNew := 'session/new'.
	ACPMethodSessionLoad := 'session/load'.
	ACPMethodSessionPrompt := 'session/prompt'.
	ACPMethodSessionCancel := 'session/cancel'.
	ACPMethodSessionSetMode := 'session/set_mode'.
	ACPMethodSessionSetConfigOption := 'session/set_config_option'.
	ACPMethodSessionSetModel := 'session/set_model'.
	ACPMethodSessionList := 'session/list'.
	ACPMethodSessionFork := 'session/fork'.
	ACPMethodSessionResume := 'session/resume'
]

{ #category : 'class initialization' }
ACPConstants class >> initializeProtocolVersion [

	ACPProtocolVersion := 1
]
