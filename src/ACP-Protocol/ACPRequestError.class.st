Class {
	#name : 'ACPRequestError',
	#superclass : 'Error',
	#pools : [
		'JRPCConstantsSharedPool'
	],
	#instVars : [
		'code',
		'rpcMessage',
		'data'
	],
	#category : 'ACP-Protocol'
}

{ #category : 'instance creation' }
ACPRequestError class >> code: aCode message: aMessage [

	^ self new
		  code: aCode;
		  rpcMessage: aMessage;
		  yourself
]

{ #category : 'instance creation' }
ACPRequestError class >> code: aCode message: aMessage data: aData [

	^ self new
		  code: aCode;
		  rpcMessage: aMessage;
		  data: aData;
		  yourself
]

{ #category : 'factory' }
ACPRequestError class >> authRequired [

	^ self code: -32000 message: 'Authentication required'
]

{ #category : 'factory' }
ACPRequestError class >> internalError: aMessage [

	^ self code: InternalError message: aMessage
]

{ #category : 'factory' }
ACPRequestError class >> invalidParams: aMessage [

	^ self code: InvalidParams message: aMessage
]

{ #category : 'factory' }
ACPRequestError class >> methodNotFound: aMethodName [

	^ self
		  code: MethodNotFound
		  message: 'Method not found: ' , aMethodName
]

{ #category : 'factory' }
ACPRequestError class >> signalForRpcError: anErrorDictionary [

	(self
		 code: (anErrorDictionary at: 'code')
		 message: (anErrorDictionary at: 'message')
		 data: (anErrorDictionary at: 'data' ifAbsent: [ nil ]))
		signal
]

{ #category : 'converting' }
ACPRequestError >> asRpcErrorDictionary [

	| dict |
	dict := Dictionary new.
	dict at: 'code' put: code.
	dict at: 'message' put: rpcMessage.
	data ifNotNil: [ dict at: 'data' put: data ].
	^ dict
]

{ #category : 'accessing' }
ACPRequestError >> code [

	^ code
]

{ #category : 'accessing' }
ACPRequestError >> code: anInteger [

	code := anInteger
]

{ #category : 'accessing' }
ACPRequestError >> data [

	^ data
]

{ #category : 'accessing' }
ACPRequestError >> data: anObject [

	data := anObject
]

{ #category : 'accessing' }
ACPRequestError >> messageText [

	^ rpcMessage ifNil: [ super messageText ]
]

{ #category : 'accessing' }
ACPRequestError >> rpcMessage [

	^ rpcMessage
]

{ #category : 'accessing' }
ACPRequestError >> rpcMessage: aString [

	rpcMessage := aString
]
