Class {
	#name : 'ACP2NdJsonTransportTest',
	#superclass : 'TestCase',
	#instVars : [
		'readStream',
		'writeStream',
		'transport'
	],
	#category : 'ACP2-Tests',
	#package : 'ACP2-Tests'
}

{ #category : 'helpers' }
ACP2NdJsonTransportTest >> feedLine: aString [
	"Append a UTF-8 encoded line to readStream and reset position for reading."

	| pos |
	pos := readStream position.
	readStream setToEnd.
	readStream nextPutAll: (aString , String lf) utf8Encoded.
	readStream position: pos
]

{ #category : 'running' }
ACP2NdJsonTransportTest >> setUp [

	super setUp.
	readStream := ReadWriteStream on: ByteArray new.
	writeStream := ReadWriteStream on: ByteArray new.
	transport := ACP2NdJsonTransport
		writeStream: writeStream
		readStream: readStream
]

{ #category : 'tests - state' }
ACP2NdJsonTransportTest >> testCloseMarksAsClosed [

	transport close.
	self assert: transport isClosed
]

{ #category : 'tests - state' }
ACP2NdJsonTransportTest >> testIsClosedInitiallyFalse [

	self deny: transport isClosed
]

{ #category : 'tests - reading' }
ACP2NdJsonTransportTest >> testReadMessageParsesJson [

	| result |
	self feedLine: '{"jsonrpc":"2.0","method":"test"}'.
	result := transport readMessage.
	self assert: (result at: 'method') equals: 'test'
]

{ #category : 'tests - reading' }
ACP2NdJsonTransportTest >> testReadMessageReturnsNilOnEmptyStream [

	| result |
	result := transport readMessage.
	self assert: result isNil
]

{ #category : 'tests - reading' }
ACP2NdJsonTransportTest >> testReadMessageSkipsInvalidJson [

	| result |
	self feedLine: 'not valid json'.
	result := transport readMessage.
	self assert: result isNil
]

{ #category : 'tests - reading' }
ACP2NdJsonTransportTest >> testReadMessageWithJapanese [

	| result |
	self feedLine: '{"text":"\u3053\u3093\u306b\u3061\u306f"}'.
	result := transport readMessage.
	self assert: (result at: 'text') equals: 'こんにちは'
]

{ #category : 'tests - reading' }
ACP2NdJsonTransportTest >> testReadMessageWithNestedObject [

	| result |
	self feedLine: '{"params":{"key":"value","num":42}}'.
	result := transport readMessage.
	self assert: ((result at: 'params') at: 'key') equals: 'value'.
	self assert: ((result at: 'params') at: 'num') equals: 42
]

{ #category : 'tests - reading' }
ACP2NdJsonTransportTest >> testReadMultipleMessages [

	| first second |
	self feedLine: '{"id":1}'.
	self feedLine: '{"id":2}'.
	first := transport readMessage.
	second := transport readMessage.
	self assert: (first at: 'id') equals: 1.
	self assert: (second at: 'id') equals: 2
]

{ #category : 'tests - writing' }
ACP2NdJsonTransportTest >> testWriteMessageProducesNdjson [

	| dict output |
	dict := Dictionary new
		at: 'jsonrpc' put: '2.0';
		at: 'method' put: 'initialize';
		yourself.
	transport writeMessage: dict.
	output := self writtenOutput utf8Decoded.
	self assert: (output endsWith: String lf).
	self
		assert: (STONJSON fromString: output trimRight)
		equals: dict
]

{ #category : 'tests - writing' }
ACP2NdJsonTransportTest >> testWriteMessageWhenClosedSignalsError [

	transport close.
	self
		should: [ transport writeMessage: { 'id' -> 1 } asDictionary ]
		raise: ACP2Error
]

{ #category : 'tests - writing' }
ACP2NdJsonTransportTest >> testWriteMessageWithJapanese [

	| dict output parsed |
	dict := { 'text' -> 'こんにちは世界' } asDictionary.
	transport writeMessage: dict.
	output := self writtenOutput utf8Decoded trimRight.
	parsed := STONJSON fromString: output.
	self assert: (parsed at: 'text') equals: 'こんにちは世界'
]

{ #category : 'tests - writing' }
ACP2NdJsonTransportTest >> testWriteMultipleMessages [

	transport writeMessage: { 'id' -> 1 } asDictionary.
	transport writeMessage: { 'id' -> 2 } asDictionary.
	self
		assert: (self writtenOutput utf8Decoded lines size)
		equals: 2
]

{ #category : 'tests - roundtrip' }
ACP2NdJsonTransportTest >> testWriteThenReadRoundtrip [

	| original readerTransport parsed |
	original := {
		'jsonrpc' -> '2.0'.
		'id' -> 1.
		'method' -> 'test'.
		'params' -> { 'key' -> 'value' } asDictionary
	} asDictionary.
	transport writeMessage: original.
	readerTransport := ACP2NdJsonTransport
		writeStream: (ReadWriteStream on: ByteArray new)
		readStream: (ReadStream on: self writtenOutput).
	parsed := readerTransport readMessage.
	self assert: (parsed at: 'jsonrpc') equals: '2.0'.
	self assert: (parsed at: 'id') equals: 1.
	self assert: (parsed at: 'method') equals: 'test'.
	self assert: ((parsed at: 'params') at: 'key') equals: 'value'
]

{ #category : 'helpers' }
ACP2NdJsonTransportTest >> writtenOutput [
	"Return the content written to writeStream."

	^ writeStream contents
]
