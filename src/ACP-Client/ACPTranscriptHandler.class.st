Class {
	#name : 'ACPTranscriptHandler',
	#superclass : 'ACPClientHandler',
	#category : 'ACP-Client',
	#package : 'ACP-Client'
}

{ #category : 'agent-callbacks' }
ACPTranscriptHandler >> requestPermission: anACPRequestPermission [

	Transcript
		show: 'Permission requested: ' , anACPRequestPermission printString;
		cr.
	^ anACPRequestPermission makeResponse allowAlways
]

{ #category : 'agent-callbacks' }
ACPTranscriptHandler >> sessionUpdate: aSessionUpdate [

	Transcript
		show: 'Session update [' , aSessionUpdate updateType , ']: ';
		show: aSessionUpdate printString;
		cr
]
