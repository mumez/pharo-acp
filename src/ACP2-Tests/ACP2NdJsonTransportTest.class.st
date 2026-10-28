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

{ #category : 'helpers' }
ACP2NdJsonTransportTest >> launchShellScript: aString [
	"Launch /bin/sh running aString and return the launched ACP2ProcessLauncher."

	^ ACP2ProcessLauncher new
		  command: '/bin/sh';
		  arguments: { '-c'. aString };
		  launch;
		  yourself
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
ACP2NdJsonTransportTest >> testReadMessageDrainsDataLeftAfterTheProcessExits [
	"The agent may write its last line right after an empty read and then exit.
	 Seeing the exited process, the transport must still drain the pipe once
	 instead of dropping that line."

	| drainingTransport result |
	drainingTransport := ACP2NdJsonTransport
		                     writeStream: (ReadWriteStream on: ByteArray new)
		                     readStream: (ACP2ScriptedReadStream chunks: {
					                      ByteArray new.
					                      ('{"jsonrpc":"2.0","id":1,"result":{}}' , String lf) utf8Encoded }).
	drainingTransport
		useAtEnd: false;
		processLauncher: ACP2ExitedProcessLauncher new.
	result := drainingTransport readMessage.
	self assert: result notNil.
	self assert: (result at: 'id') equals: 1.
	self assert: drainingTransport readMessage isNil
]

{ #category : 'tests - reading' }
ACP2NdJsonTransportTest >> testReadMessageSkipsLineWithInvalidUtf8 [
	"A complete line that is not valid UTF-8 cannot be a message; it is skipped
	 and the following line is still delivered."

	| result |
	readStream nextPutAll: #[ 16rFF 16rFE ] , (String lf , '{"jsonrpc":"2.0","method":"test"}' , String lf) utf8Encoded.
	readStream reset.
	result := transport readMessage.
	self assert: (result at: 'method') equals: 'test'
]

{ #category : 'tests - reading' }
ACP2NdJsonTransportTest >> testReadMessageEndsWhenTheRemainderIsTruncatedUtf8 [
	"The agent may exit in the middle of a multi-byte character, leaving an
	 unterminated remainder that is not valid UTF-8. The transport must end
	 the stream with nil instead of raising a decoding error."

	| truncatingTransport |
	truncatingTransport := ACP2NdJsonTransport
		                       writeStream: (ReadWriteStream on: ByteArray new)
		                       readStream: (ACP2ScriptedReadStream chunks: {
					                        ('{"text":"' utf8Encoded , ('あ' utf8Encoded first: 2)) }).
	truncatingTransport
		useAtEnd: false;
		processLauncher: ACP2ExitedProcessLauncher new.
	self assert: truncatingTransport readMessage isNil
]

{ #category : 'tests - reading' }
ACP2NdJsonTransportTest >> testReadMessageParsesJson [

	| result |
	self feedLine: '{"jsonrpc":"2.0","method":"test"}'.
	result := transport readMessage.
	self assert: (result at: 'method') equals: 'test'
]

{ #category : 'tests - reading' }
ACP2NdJsonTransportTest >> testReadMessageReturnsLastLineWrittenBeforeTheProcessExits [
	"A response written just before the agent exits (e.g. an error response)
	 must still be delivered, followed by nil for the ended stream."

	| launcher processTransport result next done |
	launcher := self launchShellScript:
		            'printf ''{"jsonrpc":"2.0","id":1,"result":{}}\n''; exit 1'.
	processTransport := ACP2NdJsonTransport on: launcher.
	done := Semaphore new.
	[
	result := processTransport readMessage.
	next := processTransport readMessage.
	done signal ] fork.
	[
	self deny: (done waitTimeoutSeconds: 5).
	self assert: result notNil.
	self assert: (result at: 'id') equals: 1.
	self assert: (result at: 'result') equals: Dictionary new.
	self assert: next isNil ] ensure: [ launcher terminate ]
]

{ #category : 'tests - reading' }
ACP2NdJsonTransportTest >> testReadMessageReturnsNilOnEmptyStream [

	| result |
	result := transport readMessage.
	self assert: result isNil
]

{ #category : 'tests - reading' }
ACP2NdJsonTransportTest >> testReadMessageReturnsNilWhenTheProcessExits [
	"Subprocess pipes do not report atEnd reliably, so the transport must notice
	that the agent process exited; otherwise readMessage polls forever and a
	request sent to an agent that failed to start never completes."

	| launcher processTransport result done |
	launcher := ACP2ProcessLauncher new
		            command: '/bin/sh';
		            arguments: #( '-c' 'exit 1' );
		            yourself.
	launcher launch.
	processTransport := ACP2NdJsonTransport on: launcher.
	done := Semaphore new.
	[
	result := processTransport readMessage.
	done signal ] fork.
	[
	self deny: (done waitTimeoutSeconds: 5).
	self assert: result isNil ] ensure: [ launcher terminate ]
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
