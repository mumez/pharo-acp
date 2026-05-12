"
I am a simple value object pairing an ACP method name with its parameters dictionary.

Responsibility:
- I carry a method name string and a params dictionary for one ACP JSON-RPC call
- I provide named factory methods for every ACP operation, reading method name constants from ACPConstants

Collaborators:
- ACPConstants (SharedPool): I read ACP method name constants (ACPMethodInitialize, ACPMethodSessionPrompt, etc.)
- ACPClientConnection: creates me and passes my method/params to ACPConnection

Public API and Key Messages:
- #initialize: / #newSession: / #prompt: / #cancel: / #loadSession: / #authenticate: etc. - named constructors for each ACP operation
- #method / #params - accessors for the constructed values
"
Class {
	#name : 'ACPRequest',
	#superclass : 'Object',
	#instVars : [
		'method',
		'params'
	],
	#pools : [
		'ACPConstants'
	],
	#category : 'ACP-Protocol',
	#package : 'ACP-Protocol'
}

{ #category : 'instance creation' }
ACPRequest class >> authenticate: aParamsOrDictionary [

	^ self method: ACPMethodAuthenticate params: aParamsOrDictionary asDictionary
]

{ #category : 'instance creation' }
ACPRequest class >> cancel: aParamsOrDictionary [

	^ self method: ACPMethodSessionCancel params: aParamsOrDictionary asDictionary
]

{ #category : 'instance creation' }
ACPRequest class >> initialize: aParamsOrDictionary [

	^ self method: ACPMethodInitialize params: aParamsOrDictionary asDictionary
]

{ #category : 'instance creation' }
ACPRequest class >> listSessions: aParamsOrDictionary [

	^ self method: ACPMethodSessionList params: aParamsOrDictionary asDictionary
]

{ #category : 'instance creation' }
ACPRequest class >> loadSession: aParamsOrDictionary [

	^ self method: ACPMethodSessionLoad params: aParamsOrDictionary asDictionary
]

{ #category : 'instance creation' }
ACPRequest class >> method: aMethodString params: aDictionary [

	^ self new
		  method: aMethodString;
		  params: aDictionary;
		  yourself
]

{ #category : 'instance creation' }
ACPRequest class >> newSession: aParamsOrDictionary [

	^ self method: ACPMethodSessionNew params: aParamsOrDictionary asDictionary
]

{ #category : 'instance creation' }
ACPRequest class >> prompt: aParamsOrDictionary [

	^ self method: ACPMethodSessionPrompt params: aParamsOrDictionary asDictionary
]

{ #category : 'instance creation' }
ACPRequest class >> resumeSession: aParamsOrDictionary [

	^ self method: ACPMethodSessionResume params: aParamsOrDictionary asDictionary
]

{ #category : 'instance creation' }
ACPRequest class >> setSessionConfigOption: aParamsOrDictionary [

	^ self method: ACPMethodSessionSetConfigOption params: aParamsOrDictionary asDictionary
]

{ #category : 'instance creation' }
ACPRequest class >> setSessionMode: aParamsOrDictionary [

	^ self method: ACPMethodSessionSetMode params: aParamsOrDictionary asDictionary
]

{ #category : 'instance creation' }
ACPRequest class >> setSessionModel: aParamsOrDictionary [

	^ self method: ACPMethodSessionSetModel params: aParamsOrDictionary asDictionary
]

{ #category : 'accessing' }
ACPRequest >> method [

	^ method
]

{ #category : 'accessing' }
ACPRequest >> method: aString [

	method := aString
]

{ #category : 'accessing' }
ACPRequest >> params [

	^ params
]

{ #category : 'accessing' }
ACPRequest >> params: aDictionary [

	params := aDictionary
]
