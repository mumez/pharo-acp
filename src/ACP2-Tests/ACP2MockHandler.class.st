Class {
	#name : 'ACP2MockHandler',
	#superclass : 'ACP2ClientHandler',
	#instVars : [
		'lastUpdate',
		'updates',
		'permissionRequest',
		'elicitationRequest',
		'completedElicitationIds'
	],
	#category : 'ACP2-Tests',
	#package : 'ACP2-Tests'
}

{ #category : 'initialization' }
ACP2MockHandler >> initialize [

	super initialize.
	updates := OrderedCollection new.
	completedElicitationIds := OrderedCollection new
]

{ #category : 'accessing' }
ACP2MockHandler >> completedElicitationIds [

	^ completedElicitationIds
]

{ #category : 'agent-callbacks' }
ACP2MockHandler >> completeElicitation: anACPCompleteElicitation [

	completedElicitationIds add: anACPCompleteElicitation elicitationId
]

{ #category : 'agent-callbacks' }
ACP2MockHandler >> createElicitation: anACPCreateElicitation [

	elicitationRequest := anACPCreateElicitation.
	^ anACPCreateElicitation makeResponse accept: { ('name' -> 'mock') } asDictionary;
		  yourself
]

{ #category : 'accessing' }
ACP2MockHandler >> elicitationRequest [

	^ elicitationRequest
]

{ #category : 'accessing' }
ACP2MockHandler >> lastUpdate [

	^ lastUpdate
]

{ #category : 'accessing' }
ACP2MockHandler >> permissionRequest [

	^ permissionRequest
]

{ #category : 'agent-callbacks' }
ACP2MockHandler >> requestPermission: anACPRequestPermission [

	permissionRequest := anACPRequestPermission.
	^ anACPRequestPermission makeResponse allowOnce
]

{ #category : 'agent-callbacks' }
ACP2MockHandler >> sessionUpdate: aSessionUpdate [

	lastUpdate := aSessionUpdate.
	updates add: aSessionUpdate
]

{ #category : 'accessing' }
ACP2MockHandler >> updates [

	^ updates
]
