Class {
	#name : 'ACPMockHandler',
	#superclass : 'ACPClientHandler',
	#instVars : [
		'lastUpdate',
		'permissionRequest'
	],
	#category : 'ACP-Tests'
}

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
ACPMockHandler >> sessionUpdate: aDictionary [

	lastUpdate := aDictionary
]
