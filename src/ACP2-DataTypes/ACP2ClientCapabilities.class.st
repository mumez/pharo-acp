"
I represent the capabilities an ACP v2 client advertises in its initialize request (capabilities).

Responsibility:
- I hold the v2 structure: { auth: ACP2ClientAuthCapabilities, elicitation: ACP2ElicitationCapabilities }
- Sub-objects are created lazily for fluent building and omitted from the wire when nothing was advertised

Collaborators:
- ACP2InitializeParams: holds me under 'capabilities'
- ACP2ClientAuthCapabilities: authentication method types the client can handle
- ACP2ElicitationCapabilities: elicitation modes the client can handle
- ACP2ClientConnection: remembers the capabilities it sent, to reject unadvertised elicitation modes
- ACP2Values: my superclass

Public API:
- auth / auth: - authentication capabilities (e.g. `caps auth enableTerminal`)
- elicitation / elicitation: - elicitation capabilities (e.g. `caps elicitation enableForm`)

Implementation Points:
- ACP v2 has no client-side fs or terminal methods, so there are no fs / terminal capabilities here
"
Class {
	#name : 'ACP2ClientCapabilities',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'instance creation' }
ACP2ClientCapabilities class >> fromDictionary: aDictionary [

	| instance |
	instance := super fromDictionary: aDictionary.
	instance
		decode: 'auth' as: ACP2ClientAuthCapabilities;
		decode: 'elicitation' as: ACP2ElicitationCapabilities.
	^ instance
]

{ #category : 'converting' }
ACP2ClientCapabilities >> asDictionary [

	| dict |
	dict := super asDictionary.
	self trimNested: self auth named: 'auth' in: dict.
	self trimNested: self elicitation named: 'elicitation' in: dict.
	^ dict
]

{ #category : 'accessing' }
ACP2ClientCapabilities >> auth [

	^ self rawValues at: 'auth' ifAbsentPut: [ ACP2ClientAuthCapabilities new ]
]

{ #category : 'accessing' }
ACP2ClientCapabilities >> auth: anACP2ClientAuthCapabilities [

	self rawValues at: 'auth' put: anACP2ClientAuthCapabilities
]

{ #category : 'accessing' }
ACP2ClientCapabilities >> elicitation [

	^ self rawValues at: 'elicitation' ifAbsentPut: [ ACP2ElicitationCapabilities new ]
]

{ #category : 'accessing' }
ACP2ClientCapabilities >> elicitation: anACP2ElicitationCapabilities [

	self rawValues at: 'elicitation' put: anACP2ElicitationCapabilities
]
