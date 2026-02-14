Class {
	#name : 'ACPNdJsonTransport',
	#superclass : 'Object',
	#instVars : [
		'writeStream',
		'readStream',
		'writeMutex',
		'isClosed'
	],
	#category : 'ACP-Transport'
}

{ #category : 'instance creation' }
ACPNdJsonTransport class >> on: anACPProcessLauncher [

	^ self new
		  writeStream: anACPProcessLauncher stdinStream;
		  readStream: anACPProcessLauncher stdoutStream;
		  yourself
]

{ #category : 'instance creation' }
ACPNdJsonTransport class >> writeStream: aWriteStream readStream: aReadStream [

	^ self new
		  writeStream: aWriteStream;
		  readStream: aReadStream;
		  yourself
]

{ #category : 'operations' }
ACPNdJsonTransport >> close [

	isClosed := true.
	self writeStream close
]

{ #category : 'initialization' }
ACPNdJsonTransport >> initialize [

	super initialize.
	writeMutex := Mutex new.
	isClosed := false
]

{ #category : 'testing' }
ACPNdJsonTransport >> isClosed [

	^ isClosed
]

{ #category : 'operations' }
ACPNdJsonTransport >> readMessage [

	| line |
	[ line := self readStream upTo: Character lf ]
		on: Error
		do: [ :e | ^ nil ].
	line ifNil: [ ^ nil ].
	line ifEmpty: [ ^ nil ].
	[ ^ STONJSON fromString: line ]
		on: Error
		do: [ :e | ^ nil ]
]

{ #category : 'accessing' }
ACPNdJsonTransport >> readStream [

	^ readStream
]

{ #category : 'accessing' }
ACPNdJsonTransport >> readStream: aStream [

	readStream := aStream
]

{ #category : 'operations' }
ACPNdJsonTransport >> writeMessage: aDictionary [

	self isClosed ifTrue: [ ACPError transportIsClosed signal ].
	writeMutex critical: [
		self writeStream
			nextPutAll: (STONJSON toString: aDictionary);
			nextPut: Character lf;
			flush ]
]

{ #category : 'accessing' }
ACPNdJsonTransport >> writeStream [

	^ writeStream
]

{ #category : 'accessing' }
ACPNdJsonTransport >> writeStream: aStream [

	writeStream := aStream
]
