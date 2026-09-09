"
I represent a single ACP content block, discriminated by a 'type' field.

Responsibility:
- On the result side I decode a content-block dictionary from session/update
  notifications, providing typed accessors for all known fields.
- On the params side I serialize via asDictionary, returning rawValues directly.
- I am dual-use: the same class is used for both sending and receiving content.

Collaborators:
- ACP2ContentChunk: wraps me for streamed content
- ACP2Values: my superclass; rawValues used for both reading and writing

Public API:
- type     - discriminator: 'text', 'image', 'audio', 'resource_link', 'resource'
- text     - text string (type='text')
- data     - base64 binary data (type='image' or 'audio')
- mimeType - MIME type for binary data
- uri      - resource URI (type='resource_link' or 'resource')
- asDictionary - returns rawValues for params-side serialization
"
Class {
	#name : 'ACP2ContentBlock',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'instance creation' }
ACP2ContentBlock class >> audio: aBase64String mimeType: aMimeType [

	^ self buildBy: [ :b |
		b type: 'audio'.
		b data: aBase64String.
		b mimeType: aMimeType ]
]

{ #category : 'instance creation' }
ACP2ContentBlock class >> image: aBase64String mimeType: aMimeType [

	^ self buildBy: [ :b |
		b type: 'image'.
		b data: aBase64String.
		b mimeType: aMimeType ]
]

{ #category : 'instance creation' }
ACP2ContentBlock class >> resource: aUri blob: aContent [

	^ self resource: aUri blob: aContent mimeType: nil
]

{ #category : 'instance creation' }
ACP2ContentBlock class >> fromDictionary: aDictionary [

	| instance |
	instance := super fromDictionary: aDictionary.
	instance rawValues at: 'resource' ifPresent: [ :dict |
		instance resource: (ACP2EmbeddedResource fromDictionary: dict) ].
	^ instance
]

{ #category : 'instance creation' }
ACP2ContentBlock class >> resource: aUri blob: aContent mimeType: aMimeType [

	^ self buildBy: [ :b |
		b type: 'resource'.
		b resource uri: aUri; blob: aContent; mimeType: aMimeType ]
]

{ #category : 'instance creation' }
ACP2ContentBlock class >> resource: aUri text: aContent [

	^ self resource: aUri text: aContent mimeType: nil
]

{ #category : 'instance creation' }
ACP2ContentBlock class >> resource: aUri text: aContent mimeType: aMimeType [

	^ self buildBy: [ :b |
		b type: 'resource'.
		b resource uri: aUri; text: aContent; mimeType: aMimeType ]
]

{ #category : 'instance creation' }
ACP2ContentBlock class >> resourceLink: aUri name: aName [

	^ self buildBy: [ :b |
		b type: 'resource_link'.
		b uri: aUri.
		b name: aName ]
]

{ #category : 'instance creation' }
ACP2ContentBlock class >> text: aString [

	^ self buildBy: [ :b |
		b type: 'text'.
		b text: aString ]
]

{ #category : 'converting' }
ACP2ContentBlock >> asDictionary [

	| dict |
	dict := self rawValues ifNil: [ ^ Dictionary new ].
	dict := Dictionary newFrom: dict.
	self trimNested: (self rawValues at: 'resource' ifAbsent: [ nil ]) named: 'resource' in: dict.
	^ dict
]

{ #category : 'accessing' }
ACP2ContentBlock >> blob [

	^ self rawValues at: 'blob' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ContentBlock >> blob: aString [

	self rawValues at: 'blob' put: aString
]

{ #category : 'accessing' }
ACP2ContentBlock >> resource [

	^ self rawValues at: 'resource' ifAbsentPut: [ ACP2EmbeddedResource new ]
]

{ #category : 'accessing' }
ACP2ContentBlock >> resource: anACPEmbeddedResource [

	self rawValues at: 'resource' put: anACPEmbeddedResource
]

{ #category : 'accessing' }
ACP2ContentBlock >> data [

	^ self rawValues at: 'data' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ContentBlock >> data: aString [

	self rawValues at: 'data' put: aString
]

{ #category : 'accessing' }
ACP2ContentBlock >> mimeType [

	^ self rawValues at: 'mimeType' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ContentBlock >> mimeType: aString [

	aString ifNil: [ ^ self ].
	self rawValues at: 'mimeType' put: aString
]

{ #category : 'accessing' }
ACP2ContentBlock >> text [

	^ self rawValues at: 'text' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ContentBlock >> text: aString [

	self rawValues at: 'text' put: aString
]

{ #category : 'accessing' }
ACP2ContentBlock >> type [

	^ self rawValues at: 'type' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ContentBlock >> type: aString [

	self rawValues at: 'type' put: aString
]

{ #category : 'accessing' }
ACP2ContentBlock >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ContentBlock >> name: aString [

	self rawValues at: 'name' put: aString
]

{ #category : 'accessing' }
ACP2ContentBlock >> size [

	^ self rawValues at: 'size' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ContentBlock >> size: anInteger [

	self rawValues at: 'size' put: anInteger
]

{ #category : 'accessing' }
ACP2ContentBlock >> title [

	^ self rawValues at: 'title' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ContentBlock >> title: aString [

	self rawValues at: 'title' put: aString
]

{ #category : 'accessing' }
ACP2ContentBlock >> uri [

	^ self rawValues at: 'uri' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ContentBlock >> uri: aString [

	self rawValues at: 'uri' put: aString
]
