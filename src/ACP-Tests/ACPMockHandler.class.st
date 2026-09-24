Class {
	#name : 'ACPMockHandler',
	#superclass : 'ACPClientHandler',
	#instVars : [
		'lastUpdate',
		'updates',
		'permissionRequest',
		'elicitationRequest',
		'completedElicitationIds'
	],
	#category : 'ACP-Tests',
	#package : 'ACP-Tests'
}

{ #category : 'initialization' }
ACPMockHandler >> initialize [

	super initialize.
	updates := OrderedCollection new.
	completedElicitationIds := OrderedCollection new
]

{ #category : 'accessing' }
ACPMockHandler >> completedElicitationIds [

	^ completedElicitationIds
]

{ #category : 'agent-callbacks' }
ACPMockHandler >> completeElicitation: anACPCompleteElicitation [

	completedElicitationIds add: anACPCompleteElicitation elicitationId
]

{ #category : 'agent-callbacks' }
ACPMockHandler >> createElicitation: anACPCreateElicitation [

	elicitationRequest := anACPCreateElicitation.
	^ anACPCreateElicitation makeResponse accept: { ('name' -> 'mock') } asDictionary;
		  yourself
]

{ #category : 'accessing' }
ACPMockHandler >> elicitationRequest [

	^ elicitationRequest
]

{ #category : 'accessing' }
ACPMockHandler >> lastUpdate [

	^ lastUpdate
]

{ #category : 'accessing' }
ACPMockHandler >> permissionRequest [

	^ permissionRequest
]

{ #category : 'agent-callbacks' }
ACPMockHandler >> requestPermission: anACPRequestPermission [

	permissionRequest := anACPRequestPermission.
	^ anACPRequestPermission makeResponse allowOnce
]

{ #category : 'agent-callbacks' }
ACPMockHandler >> sessionUpdate: aSessionUpdate [

	lastUpdate := aSessionUpdate.
	updates add: aSessionUpdate
]

{ #category : 'accessing' }
ACPMockHandler >> updates [

	^ updates
]
