Class {
	#name : 'ACP2SmokeHandler',
	#superclass : 'ACP2MockHandler',
	#category : 'ACP2-Tests',
	#package : 'ACP2-Tests'
}

{ #category : 'agent-callbacks' }
ACP2SmokeHandler >> requestPermission: aDictionary [
	"Auto-approve with the ACP protocol format expected by agents."

	permissionRequest := aDictionary.
	^ {
		  ('outcome' -> {
			   ('outcome' -> 'selected').
			   ('optionId' -> 'allow') } asDictionary) } asDictionary
]

{ #category : 'agent-callbacks' }
ACP2SmokeHandler >> sessionUpdate: aSessionUpdate [

	super sessionUpdate: aSessionUpdate.
	Transcript show: aSessionUpdate sessionUpdate printString; nl
]
