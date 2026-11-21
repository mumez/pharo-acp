"
I represent a JSON-RPC protocol error as a Smalltalk exception, carrying the RPC error code, message, and optional data.

Responsibility:
- I carry a JSON-RPC error code, message string, and optional data payload
- I provide factory methods for standard ACP/JSON-RPC error conditions
- I convert between Smalltalk exception and RPC error dictionary representations

Collaborators:
- JRPCConstantsSharedPool: I reference standard error codes (MethodNotFound, InvalidParams, InternalError)
- ACP2SessionNotFoundErrorData, ACP2UnsupportedProtocolVersionErrorData: the data shapes ACP defines for -32002 and -32022
- ACP2PendingRequest: signals me when a response contains an error

Public API and Key Messages:
- #signalForRpcError: - create and signal from a raw error Dictionary (used by ACP2PendingRequest)
- #methodNotFound: - factory for method-not-found errors
- #invalidParams: - factory for invalid parameter errors
- #internalError: - factory for internal errors
- #authRequired - factory for authentication-required errors
- #sessionNotFound: - factory for -32002 with ACP2SessionNotFoundErrorData (unknown or inactive session)
- #unsupportedProtocolVersion:supported: - factory for -32022 with ACP2UnsupportedProtocolVersionErrorData
- #isMethodNotFound / #isSessionNotFound / #isUnsupportedProtocolVersion - test the kind of error
- #sessionNotFoundData / #unsupportedProtocolVersionData - typed view of my data, or nil when it does not have that shape
- #asRpcErrorDictionary - convert to a JSON-RPC error Dictionary for wire transmission
- #asJRPCResponseWithId: - error response used when a request handler signals me (keeps my code, message, and data)

Internal Representation:
- code - Integer JSON-RPC error code
- rpcMessage - String error message (overrides #messageText)
- data - Optional extra error data (nil if absent)
"
Class {
	#name : 'ACP2RequestError',
	#superclass : 'Error',
	#instVars : [
		'code',
		'rpcMessage',
		'data'
	],
	#pools : [
		'JRPCConstantsSharedPool'
	],
	#category : 'ACP2-Protocol',
	#package : 'ACP2-Protocol'
}

{ #category : 'factory' }
ACP2RequestError class >> authRequired [

	^ self code: -32000 message: 'Authentication required'
]

{ #category : 'constants' }
ACP2RequestError class >> resourceNotFoundCode [

	^ -32002
]

{ #category : 'factory' }
ACP2RequestError class >> sessionNotFound: aSessionId [

	^ self
		  code: self resourceNotFoundCode
		  message: 'Session not found: ' , aSessionId asString
		  data: (ACP2SessionNotFoundErrorData buildBy: [ :data | data sessionId: aSessionId ])
				  asDictionary
]

{ #category : 'factory' }
ACP2RequestError class >> unsupportedProtocolVersion: aRequestedVersion supported: anArray [

	^ self
		  code: self unsupportedProtocolVersionCode
		  message: 'Unsupported protocol version: ' , aRequestedVersion printString
		  data: (ACP2UnsupportedProtocolVersionErrorData buildBy: [ :data |
				   data
					   requested: aRequestedVersion;
					   supported: anArray ]) asDictionary
]

{ #category : 'constants' }
ACP2RequestError class >> unsupportedProtocolVersionCode [

	^ -32022
]

{ #category : 'instance creation' }
ACP2RequestError class >> code: aCode message: aMessage [

	^ self new
		  code: aCode;
		  rpcMessage: aMessage;
		  yourself
]

{ #category : 'instance creation' }
ACP2RequestError class >> code: aCode message: aMessage data: aData [

	^ self new
		  code: aCode;
		  rpcMessage: aMessage;
		  data: aData;
		  yourself
]

{ #category : 'factory' }
ACP2RequestError class >> internalError: aMessage [

	^ self code: InternalError message: aMessage
]

{ #category : 'factory' }
ACP2RequestError class >> invalidParams: aMessage [

	^ self code: InvalidParams message: aMessage
]

{ #category : 'factory' }
ACP2RequestError class >> invalidRequest: aMessage [

	^ self code: InvalidRequest message: aMessage
]

{ #category : 'factory' }
ACP2RequestError class >> methodNotFound: aMethodName [

	^ self
		  code: MethodNotFound
		  message: 'Method not found: ' , aMethodName
]

{ #category : 'factory' }
ACP2RequestError class >> signalForRpcError: anErrorDictionary [

	(self
		 code: (anErrorDictionary at: 'code')
		 message: (anErrorDictionary at: 'message')
		 data: (anErrorDictionary at: 'data' ifAbsent: [ nil ]))
		signal
]

{ #category : 'converting' }
ACP2RequestError >> asJRPCResponseWithId: anId [
	"Called by JRPCMessageProcessor when a handler signals me; keep my code instead of JRPC's generic internal error."

	^ JRPCErrorResponseObject
		  id: anId
		  error: (self data
				   ifNil: [ JRPCErrorObject code: self code message: self rpcMessage ]
				   ifNotNil: [ :aData |
				   JRPCErrorObject code: self code message: self rpcMessage data: aData ])
]

{ #category : 'converting' }
ACP2RequestError >> asRpcErrorDictionary [

	| dict |
	dict := Dictionary new.
	dict at: 'code' put: code.
	dict at: 'message' put: rpcMessage.
	data ifNotNil: [ dict at: 'data' put: data ].
	^ dict
]

{ #category : 'accessing' }
ACP2RequestError >> code [

	^ code
]

{ #category : 'accessing' }
ACP2RequestError >> code: anInteger [

	code := anInteger
]

{ #category : 'accessing' }
ACP2RequestError >> data [

	^ data
]

{ #category : 'accessing' }
ACP2RequestError >> data: anObject [

	data := anObject
]

{ #category : 'testing' }
ACP2RequestError >> isMethodNotFound [

	^ code = MethodNotFound
]

{ #category : 'testing' }
ACP2RequestError >> isSessionNotFound [
	"-32002 is also used for other missing resources; only data naming a session means a missing session."

	^ self sessionNotFoundData notNil
]

{ #category : 'testing' }
ACP2RequestError >> isUnsupportedProtocolVersion [

	^ code = self class unsupportedProtocolVersionCode
]

{ #category : 'accessing' }
ACP2RequestError >> sessionNotFoundData [

	(code = self class resourceNotFoundCode and: [
		 data isDictionary and: [ data includesKey: 'sessionId' ] ]) ifFalse: [ ^ nil ].
	^ ACP2SessionNotFoundErrorData fromDictionary: data
]

{ #category : 'accessing' }
ACP2RequestError >> unsupportedProtocolVersionData [

	(self isUnsupportedProtocolVersion and: [ data isDictionary ]) ifFalse: [ ^ nil ].
	^ ACP2UnsupportedProtocolVersionErrorData fromDictionary: data
]

{ #category : 'accessing' }
ACP2RequestError >> messageText [

	^ rpcMessage ifNil: [ super messageText ]
]

{ #category : 'accessing' }
ACP2RequestError >> rpcMessage [

	^ rpcMessage
]

{ #category : 'accessing' }
ACP2RequestError >> rpcMessage: aString [

	rpcMessage := aString
]
