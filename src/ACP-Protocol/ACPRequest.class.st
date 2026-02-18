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
	#category : 'ACP-Protocol'
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
