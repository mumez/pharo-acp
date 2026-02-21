Class {
	#name : 'ACPSmokeHandler',
	#superclass : 'ACPMockHandler',
	#category : 'ACP-Tests',
	#package : 'ACP-Tests'
}

{ #category : 'agent-callbacks' }
ACPSmokeHandler >> requestPermission: aDictionary [
	"Auto-approve with the ACP protocol format expected by agents."

	permissionRequest := aDictionary.
	^ {
		  ('outcome' -> {
			   ('outcome' -> 'selected').
			   ('optionId' -> 'allow') } asDictionary) } asDictionary
]

{ #category : 'agent-callbacks' }
ACPSmokeHandler >> sessionUpdate: aSessionUpdate [

	super sessionUpdate: aSessionUpdate.
	Transcript show: aSessionUpdate updateType printString; nl
]
