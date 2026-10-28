"
I am a test double for a non-blocking pipe read stream: each #upToEnd answers the next scripted chunk.

Responsibility:
- I answer the given ByteArray chunks one per #upToEnd, then an empty ByteArray once they are used up
- I let tests reproduce pipe timing (e.g. an empty read followed by late data) deterministically

Collaborators:
- ACP2NdJsonTransport: reads from me in #readLine
- ACP2NdJsonTransportTest: scripts the chunks I answer

Public API and Key Messages:
- ACP2ScriptedReadStream class >> #chunks: - create me with a sequence of ByteArray chunks
- #upToEnd - answer the next chunk, or an empty ByteArray when none is left

Internal Representation:
- chunks - OrderedCollection of ByteArrays still to be answered
"
Class {
	#name : 'ACP2ScriptedReadStream',
	#superclass : 'Object',
	#instVars : [
		'chunks'
	],
	#category : 'ACP2-Tests',
	#package : 'ACP2-Tests'
}

{ #category : 'instance creation' }
ACP2ScriptedReadStream class >> chunks: aCollectionOfByteArrays [

	^ self new
		  chunks: aCollectionOfByteArrays asOrderedCollection;
		  yourself
]

{ #category : 'accessing' }
ACP2ScriptedReadStream >> chunks: anOrderedCollection [

	chunks := anOrderedCollection
]

{ #category : 'accessing' }
ACP2ScriptedReadStream >> upToEnd [

	^ chunks ifEmpty: [ ByteArray new ] ifNotEmpty: [ chunks removeFirst ]
]
