Class {
	#name : 'ACPNdJsonTransportTest',
	#superclass : 'TestCase',
	#instVars : [
		'readStream',
		'writeStream',
		'transport'
	],
	#category : 'ACP-Tests',
	#package : 'ACP-Tests'
}

{ #category : 'helpers' }
ACPNdJsonTransportTest >> feedLine: aString [
	"Append a UTF-8 encoded line to readStream and reset position for reading."

	| pos |
	pos := readStream position.
	readStream setToEnd.
	readStream nextPutAll: (aString , String lf) utf8Encoded.
	readStream position: pos
]

{ #category : 'helpers' }
ACPNdJsonTransportTest >> launchShellScript: aString [
	"Launch /bin/sh running aString and return the launched ACPProcessLauncher."

	^ ACPProcessLauncher new
		  command: '/bin/sh';
		  arguments: { '-c'. aString };
		  launch;
		  yourself
]

{ #category : 'running' }
ACPNdJsonTransportTest >> setUp [

	super setUp.
	readStream := ReadWriteStream on: ByteArray new.
	writeStream := ReadWriteStream on: ByteArray new.
	transport := ACPNdJsonTransport
		writeStream: writeStream
		readStream: readStream
]

{ #category : 'tests - state' }
ACPNdJsonTransportTest >> testCloseMarksAsClosed [

	transport close.
	self assert: transport isClosed
]

{ #category : 'tests - state' }
ACPNdJsonTransportTest >> testIsClosedInitiallyFalse [

	self deny: transport isClosed
]

{ #category : 'tests - reading' }
ACPNdJsonTransportTest >> testReadMessageDrainsDataLeftAfterTheProcessExits [
	"The agent may write its last line right after an empty read and then exit.
	 Seeing the exited process, the transport must still drain the pipe once
	 instead of dropping that line."

	| drainingTransport result |
	drainingTransport := ACPNdJsonTransport
		                     writeStream: (ReadWriteStream on: ByteArray new)
		                     readStream: (ACPScriptedReadStream chunks: {
					                      ByteArray new.
					                      ('{"jsonrpc":"2.0","id":1,"result":{}}' , String lf) utf8Encoded }).
	drainingTransport
		useAtEnd: false;
		processLauncher: ACPExitedProcessLauncher new.
	result := drainingTransport readMessage.
	self assert: result notNil.
	self assert: (result at: 'id') equals: 1.
	self assert: drainingTransport readMessage isNil
]

{ #category : 'tests - reading' }
ACPNdJsonTransportTest >> testReadMessageSkipsLineWithInvalidUtf8 [
	"A complete line that is not valid UTF-8 cannot be a message; it is skipped
	 and the following line is still delivered."

	| result |
	readStream nextPutAll: #[ 16rFF 16rFE ] , (String lf , '{"jsonrpc":"2.0","method":"test"}' , String lf) utf8Encoded.
	readStream reset.
	result := transport readMessage.
	self assert: (result at: 'method') equals: 'test'
]

{ #category : 'tests - reading' }
ACPNdJsonTransportTest >> testReadMessageEndsWhenTheRemainderIsTruncatedUtf8 [
	"The agent may exit in the middle of a multi-byte character, leaving an
	 unterminated remainder that is not valid UTF-8. The transport must end
	 the stream with nil instead of raising a decoding error."

	| truncatingTransport |
	truncatingTransport := ACPNdJsonTransport
		                       writeStream: (ReadWriteStream on: ByteArray new)
		                       readStream: (ACPScriptedReadStream chunks: {
					                        ('{"text":"' utf8Encoded , ('あ' utf8Encoded first: 2)) }).
	truncatingTransport
		useAtEnd: false;
		processLauncher: ACPExitedProcessLauncher new.
	self assert: truncatingTransport readMessage isNil
]

{ #category : 'tests - reading' }
ACPNdJsonTransportTest >> testReadMessageParsesJson [

	| result |
	self feedLine: '{"jsonrpc":"2.0","method":"test"}'.
	result := transport readMessage.
	self assert: (result at: 'method') equals: 'test'
]

{ #category : 'tests - reading' }
ACPNdJsonTransportTest >> testReadMessageReturnsLastLineWrittenBeforeTheProcessExits [
	"A response written just before the agent exits (e.g. an error response)
	 must still be delivered, followed by nil for the ended stream."

	| launcher processTransport result next done |
	launcher := self launchShellScript:
		            'printf ''{"jsonrpc":"2.0","id":1,"result":{}}\n''; exit 1'.
	processTransport := ACPNdJsonTransport on: launcher.
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
ACPNdJsonTransportTest >> testReadMessageReturnsNilOnEmptyStream [

	| result |
	result := transport readMessage.
	self assert: result isNil
]

{ #category : 'tests - reading' }
ACPNdJsonTransportTest >> testReadMessageReturnsNilWhenTheProcessExits [
	"Subprocess pipes do not report atEnd reliably, so the transport must notice
	that the agent process exited; otherwise readMessage polls forever and a
	request sent to an agent that failed to start never completes."

	| launcher processTransport result done |
	launcher := ACPProcessLauncher new
		            command: '/bin/sh';
		            arguments: #( '-c' 'exit 1' );
		            yourself.
	launcher launch.
	processTransport := ACPNdJsonTransport on: launcher.
	done := Semaphore new.
	[
	result := processTransport readMessage.
	done signal ] fork.
	[
	self deny: (done waitTimeoutSeconds: 5).
	self assert: result isNil ] ensure: [ launcher terminate ]
]

{ #category : 'tests - reading' }
ACPNdJsonTransportTest >> testReadMessageSkipsInvalidJson [

	| result |
	self feedLine: 'not valid json'.
	result := transport readMessage.
	self assert: result isNil
]

{ #category : 'tests - reading' }
ACPNdJsonTransportTest >> testReadMessageWithJapanese [

	| result |
	self feedLine: '{"text":"\u3053\u3093\u306b\u3061\u306f"}'.
	result := transport readMessage.
	self assert: (result at: 'text') equals: 'こんにちは'
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
ACPNdJsonTransportTest >> testReadMultipleMessages [

	| first second |
	self feedLine: '{"id":1}'.
	self feedLine: '{"id":2}'.
	first := transport readMessage.
	second := transport readMessage.
	self assert: (first at: 'id') equals: 1.
	self assert: (second at: 'id') equals: 2
]

{ #category : 'tests - writing' }
ACPNdJsonTransportTest >> testWriteMessageProducesNdjson [

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
ACPNdJsonTransportTest >> testWriteMessageWhenClosedSignalsError [

	transport close.
	self
		should: [ transport writeMessage: { 'id' -> 1 } asDictionary ]
		raise: ACPError
]

{ #category : 'tests - writing' }
ACPNdJsonTransportTest >> testWriteMessageWithJapanese [

	| dict output parsed |
	dict := { 'text' -> 'こんにちは世界' } asDictionary.
	transport writeMessage: dict.
	output := self writtenOutput utf8Decoded trimRight.
	parsed := STONJSON fromString: output.
	self assert: (parsed at: 'text') equals: 'こんにちは世界'
]

{ #category : 'tests - writing' }
ACPNdJsonTransportTest >> testWriteMultipleMessages [

	transport writeMessage: { 'id' -> 1 } asDictionary.
	transport writeMessage: { 'id' -> 2 } asDictionary.
	self
		assert: (self writtenOutput utf8Decoded lines size)
		equals: 2
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
		writeStream: (ReadWriteStream on: ByteArray new)
		readStream: (ReadStream on: self writtenOutput).
	parsed := readerTransport readMessage.
	self assert: (parsed at: 'jsonrpc') equals: '2.0'.
	self assert: (parsed at: 'id') equals: 1.
	self assert: (parsed at: 'method') equals: 'test'.
	self assert: ((parsed at: 'params') at: 'key') equals: 'value'
]

{ #category : 'helpers' }
ACPNdJsonTransportTest >> writtenOutput [
	"Return the content written to writeStream."

	^ writeStream contents
]
