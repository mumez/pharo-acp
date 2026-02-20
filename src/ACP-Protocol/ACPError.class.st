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
