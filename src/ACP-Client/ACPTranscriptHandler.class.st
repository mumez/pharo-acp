Class {
	#name : 'ACPTranscriptHandler',
	#superclass : 'ACPClientHandler',
	#category : 'ACP-Client',
	#package : 'ACP-Client'
}

{ #category : 'agent-callbacks' }
ACPTranscriptHandler >> requestPermission: aDictionary [

	Transcript
		show: 'Permission requested: ' , aDictionary printString;
		cr.
	^ { 'allow' -> true } asDictionary
]

{ #category : 'agent-callbacks' }
ACPTranscriptHandler >> sessionUpdate: aDictionary [

	Transcript
		show: 'Session update: ' , aDictionary printString;
		cr
]
