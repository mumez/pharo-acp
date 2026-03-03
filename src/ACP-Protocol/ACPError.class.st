"
I represent an ACP infrastructure error distinct from JSON-RPC protocol errors.

Responsibility:
- I carry a symbol identifying the kind of infrastructure error that occurred
- I am used for transport-level failures (e.g. writing to a closed transport)

Collaborators:
- ACPNdJsonTransport: signals me via #transportIsClosed when a write is attempted on a closed stream

Public API and Key Messages:
- #transportIsClosed - factory for the transport-is-closed error condition

Internal Representation:
- kind - Symbol identifying the error type (e.g. #transportIsClosed)
"
Class {
	#name : 'ACPError',
	#superclass : 'Error',
	#instVars : [
		'kind'
	],
	#category : 'ACP-Protocol',
	#package : 'ACP-Protocol'
}

{ #category : 'instance creation' }
ACPError class >> kind: aSymbol [

	^ self new
		  kind: aSymbol;
		  yourself
]

{ #category : 'instance creation' }
ACPError class >> transportIsClosed [

	^ self kind: #transportIsClosed
]

{ #category : 'accessing' }
ACPError >> kind [

	^ kind
]

{ #category : 'accessing' }
ACPError >> kind: aSymbol [

	kind := aSymbol
]
