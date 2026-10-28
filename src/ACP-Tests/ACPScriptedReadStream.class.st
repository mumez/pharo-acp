"
I am a test double for a non-blocking pipe read stream: each #upToEnd answers the next scripted chunk.

Responsibility:
- I answer the given ByteArray chunks one per #upToEnd, then an empty ByteArray once they are used up
- I let tests reproduce pipe timing (e.g. an empty read followed by late data) deterministically

Collaborators:
- ACPNdJsonTransport: reads from me in #readLine
- ACPNdJsonTransportTest: scripts the chunks I answer

Public API and Key Messages:
- ACPScriptedReadStream class >> #chunks: - create me with a sequence of ByteArray chunks
- #upToEnd - answer the next chunk, or an empty ByteArray when none is left
- #binary - no-op, as for a real pipe stream

Internal Representation:
- chunks - OrderedCollection of ByteArrays still to be answered
"
Class {
	#name : 'ACPScriptedReadStream',
	#superclass : 'Object',
	#instVars : [
		'chunks'
	],
	#category : 'ACP-Tests',
	#package : 'ACP-Tests'
}

{ #category : 'instance creation' }
ACPScriptedReadStream class >> chunks: aCollectionOfByteArrays [

	^ self new
		  chunks: aCollectionOfByteArrays asOrderedCollection;
		  yourself
]

{ #category : 'accessing' }
ACPScriptedReadStream >> binary [
]

{ #category : 'accessing' }
ACPScriptedReadStream >> chunks: anOrderedCollection [

	chunks := anOrderedCollection
]

{ #category : 'accessing' }
ACPScriptedReadStream >> upToEnd [

	^ chunks ifEmpty: [ ByteArray new ] ifNotEmpty: [ chunks removeFirst ]
]
