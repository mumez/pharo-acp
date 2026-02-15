Class {
	#name : 'ACPSmokeHandler',
	#superclass : 'ACPMockHandler',
	#category : 'ACP-Tests'
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
ACPSmokeHandler >> sessionUpdate: aDictionary [

	| update |
	super sessionUpdate: aDictionary.
	update := aDictionary at: 'update' ifAbsent: [ aDictionary ].
	Transcript
		show: 'Session update: '
			, (update at: 'sessionUpdate' ifAbsent: [ 'unknown' ]);
		cr
]
