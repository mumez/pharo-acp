Class {
	#name : 'ACPMockHandler',
	#superclass : 'ACPClientHandler',
	#instVars : [
		'lastUpdate',
		'updates',
		'permissionRequest'
	],
	#category : 'ACP-Tests',
	#package : 'ACP-Tests'
}

{ #category : 'initialization' }
ACPMockHandler >> initialize [

	super initialize.
	updates := OrderedCollection new
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
ACPMockHandler >> requestPermission: aDictionary [

	permissionRequest := aDictionary.
	^ { 'allow' -> true } asDictionary
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
