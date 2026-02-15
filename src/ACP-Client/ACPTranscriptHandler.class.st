Class {
	#name : 'ACPTranscriptHandler',
	#superclass : 'ACPClientHandler',
	#category : 'ACP-Client'
}

{ #category : 'agent-callbacks' }
ACPTranscriptHandler >> sessionUpdate: aDictionary [

	Transcript
		show: 'Session update: ' , aDictionary printString;
		cr
]

{ #category : 'agent-callbacks' }
ACPTranscriptHandler >> requestPermission: aDictionary [

	Transcript
		show: 'Permission requested: ' , aDictionary printString;
		cr.
	^ { 'allow' -> true } asDictionary
]
