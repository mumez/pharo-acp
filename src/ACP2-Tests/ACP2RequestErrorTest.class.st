"
I test ACP2RequestError: its ACP-specific error codes and the typed views of their data.

Responsibility:
- I verify the -32002 (session not found) and -32022 (unsupported protocol version) factories and tests
- I verify that error data with an ACP-defined shape is decoded into ACP2SessionNotFoundErrorData and ACP2UnsupportedProtocolVersionErrorData
- I verify that errors from the wire (#signalForRpcError:) keep their data

Collaborators:
- ACP2RequestError: the class under test
- ACP2SessionNotFoundErrorData, ACP2UnsupportedProtocolVersionErrorData: the typed error data
"
Class {
	#name : 'ACP2RequestErrorTest',
	#superclass : 'TestCase',
	#category : 'ACP2-Tests',
	#package : 'ACP2-Tests'
}

{ #category : 'helpers' }
ACP2RequestErrorTest >> errorFromRpcError: anErrorDictionary [

	^ [
	  ACP2RequestError signalForRpcError: anErrorDictionary.
	  nil ]
		  on: ACP2RequestError
		  do: [ :e | e return: e ]
]

{ #category : 'tests' }
ACP2RequestErrorTest >> testIsMethodNotFound [

	self assert: (ACP2RequestError methodNotFound: 'tool_call/cancel') isMethodNotFound.
	self deny: (ACP2RequestError invalidParams: 'bad') isMethodNotFound
]

{ #category : 'tests' }
ACP2RequestErrorTest >> testOtherErrorsHaveNoTypedData [

	| error |
	error := ACP2RequestError code: -32002 message: 'Resource not found' data: 'file.txt'.
	self deny: error isSessionNotFound.
	self assert: error sessionNotFoundData isNil.
	self deny: error isUnsupportedProtocolVersion.
	self assert: error unsupportedProtocolVersionData isNil
]

{ #category : 'tests' }
ACP2RequestErrorTest >> testSessionNotFound [

	| error |
	error := ACP2RequestError sessionNotFound: 'sess-001'.
	self assert: error code equals: -32002.
	self assert: error code equals: ACP2RequestError resourceNotFoundCode.
	self assert: error isSessionNotFound.
	self deny: error isUnsupportedProtocolVersion.
	self assert: (error asRpcErrorDictionary at: 'data') equals:
		{ ('sessionId' -> 'sess-001') } asDictionary
]

{ #category : 'tests' }
ACP2RequestErrorTest >> testSessionNotFoundDataFromRpcError [

	| error data |
	error := self errorFromRpcError: {
			         ('code' -> -32002).
			         ('message' -> 'Session not found').
			         ('data' -> { ('sessionId' -> 'sess-404') } asDictionary) }
			         asDictionary.
	self assert: error isSessionNotFound.
	data := error sessionNotFoundData.
	self assert: data class equals: ACP2SessionNotFoundErrorData.
	self assert: data sessionId equals: 'sess-404'
]

{ #category : 'tests' }
ACP2RequestErrorTest >> testUnsupportedProtocolVersion [

	| error |
	error := ACP2RequestError unsupportedProtocolVersion: 3 supported: #( 1 2 ).
	self assert: error code equals: -32022.
	self assert: error code equals: ACP2RequestError unsupportedProtocolVersionCode.
	self assert: error isUnsupportedProtocolVersion.
	self deny: error isSessionNotFound.
	self assert: (error asRpcErrorDictionary at: 'data') equals: {
			('requested' -> 3).
			('supported' -> #( 1 2 )) } asDictionary
]

{ #category : 'tests' }
ACP2RequestErrorTest >> testUnsupportedProtocolVersionDataFromRpcError [

	| error data |
	error := self errorFromRpcError: {
			         ('code' -> -32022).
			         ('message' -> 'Unsupported protocol version').
			         ('data' -> {
				          ('requested' -> 3).
				          ('supported' -> #( 1 2 )) } asDictionary) } asDictionary.
	self assert: error isUnsupportedProtocolVersion.
	data := error unsupportedProtocolVersionData.
	self assert: data class equals: ACP2UnsupportedProtocolVersionErrorData.
	self assert: data requested equals: 3.
	self assert: data supported equals: #( 1 2 )
]

{ #category : 'tests' }
ACP2RequestErrorTest >> testUnsupportedProtocolVersionWithoutData [

	| error |
	error := self errorFromRpcError: {
			         ('code' -> -32022).
			         ('message' -> 'Unsupported protocol version') } asDictionary.
	self assert: error isUnsupportedProtocolVersion.
	self assert: error unsupportedProtocolVersionData isNil
]
