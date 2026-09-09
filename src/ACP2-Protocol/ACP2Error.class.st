"
I represent an ACP infrastructure error distinct from JSON-RPC protocol errors.

Responsibility:
- I carry a symbol identifying the kind of infrastructure error that occurred
- I am used for transport-level failures (e.g. writing to a closed transport)

Collaborators:
- ACP2NdJsonTransport: signals me via #transportIsClosed when a write is attempted on a closed stream

Public API and Key Messages:
- #transportIsClosed - factory for the transport-is-closed error condition

Internal Representation:
- kind - Symbol identifying the error type (e.g. #transportIsClosed)
"
Class {
	#name : 'ACP2Error',
	#superclass : 'Error',
	#instVars : [
		'kind'
	],
	#category : 'ACP2-Protocol',
	#package : 'ACP2-Protocol'
}

{ #category : 'instance creation' }
ACP2Error class >> kind: aSymbol [

	^ self new
		  kind: aSymbol;
		  yourself
]

{ #category : 'instance creation' }
ACP2Error class >> transportIsClosed [

	^ self kind: #transportIsClosed
]

{ #category : 'accessing' }
ACP2Error >> kind [

	^ kind
]

{ #category : 'accessing' }
ACP2Error >> kind: aSymbol [

	kind := aSymbol
]
