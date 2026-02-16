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
	#category : 'ACP-Transport'
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

{ #category : 'private - accessing' }
ACPNdJsonTransport >> isClosed: aBoolean [

	isClosed := aBoolean
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
ACPNdJsonTransport >> isAtEnd [
	"Check if the stream has reached EOF.
	 When useAtEnd is false (OSSPipe), only isClosed is checked because
	 OSSPipe atEnd unreliably returns true when no data is available yet."

	^ self isClosed or: [ self useAtEnd and: [ self readStream atEnd ] ]
]

{ #category : 'private' }
ACPNdJsonTransport >> readLine [
	"Read one LF-terminated line from the stream, polling with delay for non-blocking pipes.
	 Return the line content (without LF), or nil on EOF/closed."

	| lfIndex chunk line |
	[
		lfIndex := self readBuffer indexOf: Character lf.
		lfIndex > 0 ifTrue: [
			line := self readBuffer copyFrom: 1 to: lfIndex - 1.
			self readBuffer: (self readBuffer copyFrom: lfIndex + 1 to: self readBuffer size).
			^ line ].
		[ chunk := self readStream upToEnd ]
			on: Error
			do: [ :e | ^ nil ].
		(chunk isNil or: [ chunk isEmpty ])
			ifTrue: [
				self isAtEnd ifTrue: [
					self readBuffer ifEmpty: [ ^ nil ].
					line := self readBuffer.
					self readBuffer: ''.
					^ line ].
				self pollDelay wait ]
			ifFalse: [ self readBuffer: (self readBuffer , chunk) ]
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

{ #category : 'private - accessing' }
ACPNdJsonTransport >> readBuffer [

	^ readBuffer
]

{ #category : 'private - accessing' }
ACPNdJsonTransport >> readBuffer: aString [

	readBuffer := aString
]

{ #category : 'accessing' }
ACPNdJsonTransport >> useAtEnd [

	^ useAtEnd
]

{ #category : 'accessing' }
ACPNdJsonTransport >> useAtEnd: aBoolean [

	useAtEnd := aBoolean
]

{ #category : 'private - accessing' }
ACPNdJsonTransport >> writeMutex [

	^ writeMutex
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
	self writeMutex critical: [
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
