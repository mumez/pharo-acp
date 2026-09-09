Class {
	#name : 'ACP2TranscriptHandler',
	#superclass : 'ACP2ClientHandler',
	#category : 'ACP2-Client',
	#package : 'ACP2-Client'
}

{ #category : 'agent-callbacks' }
ACP2TranscriptHandler >> requestPermission: anACPRequestPermission [

	Transcript
		show: 'Permission requested: ' , anACPRequestPermission printString;
		cr.
	^ anACPRequestPermission makeResponse selectOptionId: 'allow'; yourself
]

{ #category : 'agent-callbacks' }
ACP2TranscriptHandler >> sessionUpdate: aSessionUpdate [

	Transcript
		show: 'Session update [' , aSessionUpdate sessionUpdate , ']: ';
		cr.
	(aSessionUpdate isAgentMessage or: [ aSessionUpdate isAgentMessageChunk ])
		ifTrue: [ Transcript show: aSessionUpdate content text; cr ]
]
