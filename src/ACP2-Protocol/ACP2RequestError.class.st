"
I represent a JSON-RPC protocol error as a Smalltalk exception, carrying the RPC error code, message, and optional data.

Responsibility:
- I carry a JSON-RPC error code, message string, and optional data payload
- I provide factory methods for standard ACP/JSON-RPC error conditions
- I convert between Smalltalk exception and RPC error dictionary representations

Collaborators:
- JRPCConstantsSharedPool: I reference standard error codes (MethodNotFound, InvalidParams, InternalError)
- ACP2PendingRequest: signals me when a response contains an error

Public API and Key Messages:
- #signalForRpcError: - create and signal from a raw error Dictionary (used by ACP2PendingRequest)
- #methodNotFound: - factory for method-not-found errors
- #invalidParams: - factory for invalid parameter errors
- #internalError: - factory for internal errors
- #authRequired - factory for authentication-required errors
- #asRpcErrorDictionary - convert to a JSON-RPC error Dictionary for wire transmission

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
