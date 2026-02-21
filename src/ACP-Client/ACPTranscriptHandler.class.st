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
ACPTranscriptHandler >> sessionUpdate: aSessionUpdate [

	Transcript
		show: 'Session update [' , aSessionUpdate updateType , ']: ';
		show: aSessionUpdate printString;
		cr
]
