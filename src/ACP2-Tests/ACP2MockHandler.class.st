Class {
	#name : 'ACP2MockHandler',
	#superclass : 'ACP2ClientHandler',
	#instVars : [
		'lastUpdate',
		'updates',
		'permissionRequest'
	],
	#category : 'ACP2-Tests',
	#package : 'ACP2-Tests'
}

{ #category : 'initialization' }
ACP2MockHandler >> initialize [

	super initialize.
	updates := OrderedCollection new
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
