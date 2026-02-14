Class {
	#name : 'ACPNdJsonTransportTest',
	#superclass : 'TestCase',
	#instVars : [
		'readStream',
		'writeStream',
		'transport'
	],
	#category : 'ACP-Tests'
}

{ #category : 'running' }
ACPNdJsonTransportTest >> setUp [

	super setUp.
	readStream := ReadWriteStream on: String new.
	writeStream := ReadWriteStream on: String new.
	transport := ACPNdJsonTransport
		writeStream: writeStream
		readStream: readStream
]

{ #category : 'helpers' }
ACPNdJsonTransportTest >> feedLine: aString [
	"Append a line to readStream and reset position for reading."

	| pos |
	pos := readStream position.
	readStream setToEnd.
	readStream
		nextPutAll: aString;
		nextPut: Character lf.
	readStream position: pos
]

{ #category : 'helpers' }
ACPNdJsonTransportTest >> writtenOutput [
	"Return the content written to writeStream."

	^ writeStream contents
]

{ #category : 'tests - writing' }
ACPNdJsonTransportTest >> testWriteMessageProducesNdjson [

	| dict output |
	dict := Dictionary new
		at: 'jsonrpc' put: '2.0';
		at: 'method' put: 'initialize';
		yourself.
	transport writeMessage: dict.
	output := self writtenOutput.
	self assert: (output endsWith: String lf).
	self
		assert: (STONJSON fromString: (output trimRight))
		equals: dict
]

{ #category : 'tests - writing' }
ACPNdJsonTransportTest >> testWriteMultipleMessages [

	transport writeMessage: { 'id' -> 1 } asDictionary.
	transport writeMessage: { 'id' -> 2 } asDictionary.
	self
		assert: (self writtenOutput lines size)
		equals: 2
]

{ #category : 'tests - writing' }
ACPNdJsonTransportTest >> testWriteMessageWithJapanese [

	| dict output parsed |
	dict := { 'text' -> 'こんにちは世界' } asDictionary.
	transport writeMessage: dict.
	output := self writtenOutput trimRight.
	parsed := STONJSON fromString: output.
	self assert: (parsed at: 'text') equals: 'こんにちは世界'
]

{ #category : 'tests - writing' }
ACPNdJsonTransportTest >> testWriteMessageWhenClosedSignalsError [

	transport close.
	self
		should: [ transport writeMessage: { 'id' -> 1 } asDictionary ]
		raise: ACPError
]

{ #category : 'tests - reading' }
ACPNdJsonTransportTest >> testReadMessageParsesJson [

	| result |
	self feedLine: '{"jsonrpc":"2.0","method":"test"}'.
	result := transport readMessage.
	self assert: (result at: 'method') equals: 'test'
]

{ #category : 'tests - reading' }
ACPNdJsonTransportTest >> testReadMessageWithNestedObject [

	| result |
	self feedLine: '{"params":{"key":"value","num":42}}'.
	result := transport readMessage.
	self assert: ((result at: 'params') at: 'key') equals: 'value'.
	self assert: ((result at: 'params') at: 'num') equals: 42
]

{ #category : 'tests - reading' }
ACPNdJsonTransportTest >> testReadMessageWithJapanese [

	| result |
	self feedLine: '{"text":"\u3053\u3093\u306b\u3061\u306f"}'.
	result := transport readMessage.
	self assert: (result at: 'text') equals: 'こんにちは'
]

{ #category : 'tests - reading' }
ACPNdJsonTransportTest >> testReadMessageReturnsNilOnEmptyStream [

	| result |
	result := transport readMessage.
	self assert: result isNil
]

{ #category : 'tests - reading' }
ACPNdJsonTransportTest >> testReadMessageSkipsInvalidJson [

	| result |
	self feedLine: 'not valid json'.
	result := transport readMessage.
	self assert: result isNil
]

{ #category : 'tests - reading' }
ACPNdJsonTransportTest >> testReadMultipleMessages [

	| first second |
	self feedLine: '{"id":1}'.
	self feedLine: '{"id":2}'.
	first := transport readMessage.
	second := transport readMessage.
	self assert: (first at: 'id') equals: 1.
	self assert: (second at: 'id') equals: 2
]

{ #category : 'tests - roundtrip' }
ACPNdJsonTransportTest >> testWriteThenReadRoundtrip [

	| original readerTransport parsed |
	original := {
		'jsonrpc' -> '2.0'.
		'id' -> 1.
		'method' -> 'test'.
		'params' -> { 'key' -> 'value' } asDictionary
	} asDictionary.
	transport writeMessage: original.
	readerTransport := ACPNdJsonTransport
		writeStream: (ReadWriteStream on: String new)
		readStream: (ReadStream on: self writtenOutput).
	parsed := readerTransport readMessage.
	self assert: (parsed at: 'jsonrpc') equals: '2.0'.
	self assert: (parsed at: 'id') equals: 1.
	self assert: (parsed at: 'method') equals: 'test'.
	self assert: ((parsed at: 'params') at: 'key') equals: 'value'
]

{ #category : 'tests - state' }
ACPNdJsonTransportTest >> testIsClosedInitiallyFalse [

	self deny: transport isClosed
]

{ #category : 'tests - state' }
ACPNdJsonTransportTest >> testCloseMarksAsClosed [

	transport close.
	self assert: transport isClosed
]
