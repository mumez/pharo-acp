"
I implement newline-delimited JSON (ndjson) framing over a pair of read/write streams.

Responsibility:
- I serialize Dictionaries to UTF-8 JSON lines and write them to a write stream, protected by a Mutex
- I read LF-terminated lines from a read stream, buffering partial reads, and parse them as JSON
- I handle non-blocking OSSPipe reads by polling with a configurable delay instead of blocking

Collaborators:
- ACPProcessLauncher: provides the stdin/stdout streams I wrap
- ACPConnection: calls #readMessage and #writeMessage on me

Public API and Key Messages:
- #readMessage - read and parse the next JSON line; returns a Dictionary or nil on close
- #writeMessage: - serialize aDictionary as a JSON line and flush; mutex-protected
- #close - mark as closed and close the write stream
- #pollDelay: - configure polling interval for non-blocking pipes (default 500ms)

Internal Representation:
- writeStream / readStream - the underlying I/O streams
- writeMutex - Mutex protecting concurrent writes
- readBuffer - ByteArray accumulating partial line data between polls
- isClosed - true once close has been called
- pollDelay - Duration to wait when no data is available on a non-blocking pipe
- useAtEnd - false for OSSPipe (atEnd is unreliable); true for regular streams

Implementation Points:
- OSSPipe does not reliably report atEnd when data is temporarily unavailable; useAtEnd: false skips the check
- Streams are set to binary mode so UTF-8 ByteArrays are exchanged without re-encoding
- Empty lines in the ndjson stream are silently skipped
- A Mutex is required because multiple Pharo processes may call #writeMessage: concurrently
"
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
	"OSSPipe atEnd is unreliable for non-blocking pipes — disable it.
	 Both streams are set to binary mode so UTF-8 ByteArrays are exchanged as-is."

	| transport |
	transport := self new
		             writeStream: anACPProcessLauncher stdinStream;
		             readStream: anACPProcessLauncher stdoutStream;
		             useAtEnd: false;
		             yourself.
	transport writeStream binary.
	transport readStream binary.
	^ transport
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
	readBuffer := ByteArray new.
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
		lfIndex := readBuffer indexOf: Character lf asciiValue.
		lfIndex > 0 ifTrue: [
			line := (readBuffer copyFrom: 1 to: lfIndex - 1) utf8Decoded.
			readBuffer := readBuffer copyFrom: lfIndex + 1 to: readBuffer size.
			^ line ].
		[ chunk := self readStream upToEnd ]
			on: Error
			do: [ :e | ^ nil ].
		chunk isEmptyOrNil
			ifTrue: [
				self isAtEnd ifTrue: [
					readBuffer ifEmpty: [ ^ nil ].
					line := readBuffer utf8Decoded.
					readBuffer := ByteArray new.
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
			nextPutAll: (STONJSON toString: aDictionary) utf8Encoded;
			nextPut: Character lf asciiValue;
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
