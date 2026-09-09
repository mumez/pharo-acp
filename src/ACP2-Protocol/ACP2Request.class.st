"
I am a simple value object pairing an ACP method name with its parameters dictionary.

Responsibility:
- I carry a method name string and a params dictionary for one ACP JSON-RPC call
- I provide named factory methods for every ACP operation, reading method name constants from ACP2Constants

Collaborators:
- ACP2Constants (SharedPool): I read ACP method name constants (ACP2MethodInitialize, ACP2MethodSessionPrompt, etc.)
- ACP2ClientConnection: creates me and passes my method/params to ACP2Connection

Public API and Key Messages:
- #initialize: / #newSession: / #prompt: / #cancel: / #loadSession: / #authenticate: etc. - named constructors for each ACP operation
- #method / #params - accessors for the constructed values
"
Class {
	#name : 'ACP2Request',
	#superclass : 'Object',
	#instVars : [
		'method',
		'params'
	],
	#pools : [
		'ACP2Constants'
	],
	#category : 'ACP2-Protocol',
	#package : 'ACP2-Protocol'
}

{ #category : 'instance creation' }
ACP2Request class >> cancel: aParamsOrDictionary [

	^ self method: ACP2MethodSessionCancel params: aParamsOrDictionary asDictionary
]

{ #category : 'instance creation' }
ACP2Request class >> closeSession: aParamsOrDictionary [

	^ self method: ACP2MethodSessionClose params: aParamsOrDictionary asDictionary
]

{ #category : 'instance creation' }
ACP2Request class >> initialize: aParamsOrDictionary [

	^ self method: ACP2MethodInitialize params: aParamsOrDictionary asDictionary
]

{ #category : 'instance creation' }
ACP2Request class >> listSessions: aParamsOrDictionary [

	^ self method: ACP2MethodSessionList params: aParamsOrDictionary asDictionary
]

{ #category : 'instance creation' }
ACP2Request class >> logout: aParamsOrDictionary [

	^ self method: ACP2MethodAuthLogout params: aParamsOrDictionary asDictionary
]

{ #category : 'instance creation' }
ACP2Request class >> method: aMethodString params: aDictionary [

	^ self new
		  method: aMethodString;
		  params: aDictionary;
		  yourself
]

{ #category : 'instance creation' }
ACP2Request class >> newSession: aParamsOrDictionary [

	^ self method: ACP2MethodSessionNew params: aParamsOrDictionary asDictionary
]

{ #category : 'instance creation' }
ACP2Request class >> prompt: aParamsOrDictionary [

	^ self method: ACP2MethodSessionPrompt params: aParamsOrDictionary asDictionary
]

{ #category : 'instance creation' }
ACP2Request class >> resumeSession: aParamsOrDictionary [

	^ self method: ACP2MethodSessionResume params: aParamsOrDictionary asDictionary
]

{ #category : 'accessing' }
ACP2Request >> method [

	^ method
]

{ #category : 'accessing' }
ACP2Request >> method: aString [

	method := aString
]

{ #category : 'accessing' }
ACP2Request >> params [

	^ params
]

{ #category : 'accessing' }
ACP2Request >> params: aDictionary [

	params := aDictionary
]
