Class {
	#name : 'ACP2Constants',
	#superclass : 'SharedPool',
	#classVars : [
		'ACP2MethodAuthLogout',
		'ACP2MethodInitialize',
		'ACP2MethodRequestPermission',
		'ACP2MethodSessionCancel',
		'ACP2MethodSessionClose',
		'ACP2MethodSessionList',
		'ACP2MethodSessionNew',
		'ACP2MethodSessionPrompt',
		'ACP2MethodSessionResume',
		'ACP2MethodSessionUpdate',
		'ACP2ProtocolVersion'
	],
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'class initialization' }
ACP2Constants class >> initialize [

	self initializeProtocolVersion.
	self initializeClientToAgentMethods.
	self initializeAgentToClientMethods
]

{ #category : 'class initialization' }
ACP2Constants class >> initializeAgentToClientMethods [

	ACP2MethodSessionUpdate := 'session/update'.
	ACP2MethodRequestPermission := 'session/request_permission'
]

{ #category : 'class initialization' }
ACP2Constants class >> initializeClientToAgentMethods [

	ACP2MethodInitialize := 'initialize'.
	ACP2MethodSessionNew := 'session/new'.
	ACP2MethodSessionList := 'session/list'.
	ACP2MethodSessionResume := 'session/resume'.
	ACP2MethodSessionClose := 'session/close'.
	ACP2MethodSessionPrompt := 'session/prompt'.
	ACP2MethodSessionCancel := 'session/cancel'.
	ACP2MethodAuthLogout := 'auth/logout'
]

{ #category : 'class initialization' }
ACP2Constants class >> initializeProtocolVersion [

	ACP2ProtocolVersion := 2
]

{ #category : 'accessing' }
ACP2Constants class >> protocolVersion [

	^ ACP2ProtocolVersion
]
