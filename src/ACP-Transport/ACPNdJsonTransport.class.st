Class {
	#name : 'ACPNdJsonTransport',
	#superclass : 'Object',
	#instVars : [
		'writeStream',
		'readStream',
		'writeMutex',
		'isClosed',
		'readBuffer',
		'pollDelay'
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
	isClosed := false.
	readBuffer := ''.
	pollDelay := 500 milliSeconds
]

{ #category : 'testing' }
ACPNdJsonTransport >> isClosed [

	^ isClosed
]

{ #category : 'accessing' }
ACPNdJsonTransport >> pollDelay [

	^ pollDelay
]

{ #category : 'accessing' }
ACPNdJsonTransport >> pollDelay: aDuration [

	pollDelay := aDuration
]

{ #category : 'private' }
ACPNdJsonTransport >> readLine [
	"Read one LF-terminated line from the stream, polling with delay for non-blocking pipes.
	 Return the line content (without LF), or nil on EOF."

	| lfIndex chunk line |
	[
		lfIndex := readBuffer indexOf: Character lf.
		lfIndex > 0 ifTrue: [
			line := readBuffer copyFrom: 1 to: lfIndex - 1.
			readBuffer := readBuffer copyFrom: lfIndex + 1 to: readBuffer size.
			^ line ].
		[ chunk := readStream upToEnd ]
			on: Error
			do: [ :e | ^ nil ].
		(chunk isNil or: [ chunk isEmpty ])
			ifTrue: [
				readStream atEnd
					ifTrue: [
						readBuffer ifEmpty: [ ^ nil ].
						line := readBuffer.
						readBuffer := ''.
						^ line ]
					ifFalse: [ self pollDelay wait ] ]
			ifFalse: [ readBuffer := readBuffer , chunk ]
	] repeat
]

{ #category : 'operations' }
ACPNdJsonTransport >> readMessage [
	"Poll non-blocking read stream until a complete JSON line is available.
	 Return parsed Dictionary, or nil on EOF or parse error."

	| line |
	line := self readLine.
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
