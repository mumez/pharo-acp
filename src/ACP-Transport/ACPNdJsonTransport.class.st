Class {
	#name : 'ACPNdJsonTransport',
	#superclass : 'Object',
	#instVars : [
		'writeStream',
		'readStream',
		'writeMutex',
		'isClosed',
		'readBuffer',
		'pollDelay',
		'useAtEnd'
	],
	#category : 'ACP-Transport',
	#package : 'ACP-Transport'
}

{ #category : 'instance creation' }
ACPNdJsonTransport class >> on: anACPProcessLauncher [
	"OSSPipe atEnd is unreliable for non-blocking pipes — disable it."

	^ self new
		  writeStream: anACPProcessLauncher stdinStream;
		  readStream: anACPProcessLauncher stdoutStream;
		  useAtEnd: false;
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

	self isClosed: true.
	self writeStream close
]

{ #category : 'initialization' }
ACPNdJsonTransport >> initialize [

	super initialize.
	writeMutex := Mutex new.
	isClosed := false.
	readBuffer := ''.
	pollDelay := 500 milliSeconds.
	useAtEnd := true
]

{ #category : 'private' }
ACPNdJsonTransport >> isAtEnd [
	"Check if the stream has reached EOF.
	 When useAtEnd is false (OSSPipe), only isClosed is checked because
	 OSSPipe atEnd unreliably returns true when no data is available yet."

	^ self isClosed or: [ self useAtEnd and: [ self readStream atEnd ] ]
]

{ #category : 'testing' }
ACPNdJsonTransport >> isClosed [

	^ isClosed
]

{ #category : 'private - accessing' }
ACPNdJsonTransport >> isClosed: aBoolean [

	isClosed := aBoolean
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
	 Return the line content (without LF), or nil on EOF/closed."

	| lfIndex chunk line |
	[
		lfIndex := readBuffer indexOf: Character lf.
		lfIndex > 0 ifTrue: [
			line := readBuffer copyFrom: 1 to: lfIndex - 1.
			readBuffer := readBuffer copyFrom: lfIndex + 1 to: readBuffer size.
			^ line ].
		[ chunk := self readStream upToEnd ]
			on: Error
			do: [ :e | ^ nil ].
		chunk isEmptyOrNil
			ifTrue: [
				self isAtEnd ifTrue: [
					readBuffer ifEmpty: [ ^ nil ].
					line := readBuffer.
					readBuffer := ''.
					^ line ].
				self pollDelay wait ]
			ifFalse: [ readBuffer := readBuffer , chunk ]
	] repeat
]

{ #category : 'operations' }
ACPNdJsonTransport >> readMessage [
	"Poll non-blocking read stream until a complete JSON line is available.
	 Return parsed Dictionary, or nil when closed.
	 Empty lines are skipped (common in ndjson streams)."

	| line |
	[
		line := self readLine.
		line ifNil: [ ^ nil ].
		line ifEmpty: [ "skip empty lines, read next" ]
			ifNotEmpty: [
				[ ^ STONJSON fromString: line ]
					on: Error
					do: [ :e | ^ nil ] ]
	] repeat
]

{ #category : 'accessing' }
ACPNdJsonTransport >> readStream [

	^ readStream
]

{ #category : 'accessing' }
ACPNdJsonTransport >> readStream: aStream [

	readStream := aStream
]

{ #category : 'accessing' }
ACPNdJsonTransport >> useAtEnd [

	^ useAtEnd
]

{ #category : 'accessing' }
ACPNdJsonTransport >> useAtEnd: aBoolean [

	useAtEnd := aBoolean
]

{ #category : 'operations' }
ACPNdJsonTransport >> writeMessage: aDictionary [

	self isClosed ifTrue: [ ACPError transportIsClosed signal ].
	self writeMutex critical: [
		self writeStream
			nextPutAll: (STONJSON toString: aDictionary);
			nextPut: Character lf;
			flush ]
]

{ #category : 'private - accessing' }
ACPNdJsonTransport >> writeMutex [

	^ writeMutex
]

{ #category : 'accessing' }
ACPNdJsonTransport >> writeStream [

	^ writeStream
]

{ #category : 'accessing' }
ACPNdJsonTransport >> writeStream: aStream [

	writeStream := aStream
]
