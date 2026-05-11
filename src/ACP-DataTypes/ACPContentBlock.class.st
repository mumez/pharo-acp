"
I represent a single ACP content block, discriminated by a 'type' field.

Responsibility:
- On the result side I decode a content-block dictionary from session/update
  notifications, providing typed accessors for all known fields.
- On the params side I serialize via asDictionary, returning rawValues directly.
- I am dual-use: the same class is used for both sending and receiving content.

Collaborators:
- ACPContentChunk: wraps me for streamed content
- ACPValues: my superclass; rawValues used for both reading and writing

Public API:
- type     - discriminator: 'text', 'image', 'audio', 'resource_link', 'resource'
- text     - text string (type='text')
- data     - base64 binary data (type='image' or 'audio')
- mimeType - MIME type for binary data
- uri      - resource URI (type='resource_link' or 'resource')
- asDictionary - returns rawValues for params-side serialization
"
Class {
	#name : 'ACPContentBlock',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'instance creation' }
ACPContentBlock class >> audio: aBase64String mimeType: aMimeType [

	^ self buildBy: [ :b |
		b type: 'audio'.
		b data: aBase64String.
		b mimeType: aMimeType ]
]

{ #category : 'instance creation' }
ACPContentBlock class >> image: aBase64String mimeType: aMimeType [

	^ self buildBy: [ :b |
		b type: 'image'.
		b data: aBase64String.
		b mimeType: aMimeType ]
]

{ #category : 'instance creation' }
ACPContentBlock class >> resource: aUri blob: aContent [

	^ self resource: aUri blob: aContent mimeType: nil
]

{ #category : 'instance creation' }
ACPContentBlock class >> fromDictionary: aDictionary [

	| instance |
	instance := super fromDictionary: aDictionary.
	instance rawValues at: 'resource' ifPresent: [ :dict |
		instance resource: (ACPEmbeddedResource fromDictionary: dict) ].
	^ instance
]

{ #category : 'instance creation' }
ACPContentBlock class >> resource: aUri blob: aContent mimeType: aMimeType [

	^ self buildBy: [ :b |
		b type: 'resource'.
		b resource uri: aUri; blob: aContent; mimeType: aMimeType ]
]

{ #category : 'instance creation' }
ACPContentBlock class >> resource: aUri text: aContent [

	^ self resource: aUri text: aContent mimeType: nil
]

{ #category : 'instance creation' }
ACPContentBlock class >> resource: aUri text: aContent mimeType: aMimeType [

	^ self buildBy: [ :b |
		b type: 'resource'.
		b resource uri: aUri; text: aContent; mimeType: aMimeType ]
]

{ #category : 'instance creation' }
ACPContentBlock class >> resourceLink: aUri name: aName [

	^ self buildBy: [ :b |
		b type: 'resource_link'.
		b uri: aUri.
		b name: aName ]
]

{ #category : 'instance creation' }
ACPContentBlock class >> text: aString [

	^ self buildBy: [ :b |
		b type: 'text'.
		b text: aString ]
]

{ #category : 'converting' }
ACPContentBlock >> asDictionary [

	| dict |
	dict := self rawValues ifNil: [ ^ Dictionary new ].
	dict := Dictionary newFrom: dict.
	self trimNested: (self rawValues at: 'resource' ifAbsent: [ nil ]) named: 'resource' in: dict.
	^ dict
]

{ #category : 'accessing' }
ACPContentBlock >> blob [

	^ self rawValues at: 'blob' ifAbsent: []
]

{ #category : 'accessing' }
ACPContentBlock >> blob: aString [

	self rawValues at: 'blob' put: aString
]

{ #category : 'accessing' }
ACPContentBlock >> resource [

	^ self rawValues at: 'resource' ifAbsentPut: [ ACPEmbeddedResource new ]
]

{ #category : 'accessing' }
ACPContentBlock >> resource: anACPEmbeddedResource [

	self rawValues at: 'resource' put: anACPEmbeddedResource
]

{ #category : 'accessing' }
ACPContentBlock >> data [

	^ self rawValues at: 'data' ifAbsent: []
]

{ #category : 'accessing' }
ACPContentBlock >> data: aString [

	self rawValues at: 'data' put: aString
]

{ #category : 'accessing' }
ACPContentBlock >> mimeType [

	^ self rawValues at: 'mimeType' ifAbsent: []
]

{ #category : 'accessing' }
ACPContentBlock >> mimeType: aString [

	aString ifNil: [ ^ self ].
	self rawValues at: 'mimeType' put: aString
]

{ #category : 'accessing' }
ACPContentBlock >> text [

	^ self rawValues at: 'text' ifAbsent: []
]

{ #category : 'accessing' }
ACPContentBlock >> text: aString [

	self rawValues at: 'text' put: aString
]

{ #category : 'accessing' }
ACPContentBlock >> type [

	^ self rawValues at: 'type' ifAbsent: []
]

{ #category : 'accessing' }
ACPContentBlock >> type: aString [

	self rawValues at: 'type' put: aString
]

{ #category : 'accessing' }
ACPContentBlock >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACPContentBlock >> name: aString [

	self rawValues at: 'name' put: aString
]

{ #category : 'accessing' }
ACPContentBlock >> size [

	^ self rawValues at: 'size' ifAbsent: []
]

{ #category : 'accessing' }
ACPContentBlock >> size: anInteger [

	self rawValues at: 'size' put: anInteger
]

{ #category : 'accessing' }
ACPContentBlock >> title [

	^ self rawValues at: 'title' ifAbsent: []
]

{ #category : 'accessing' }
ACPContentBlock >> title: aString [

	self rawValues at: 'title' put: aString
]

{ #category : 'accessing' }
ACPContentBlock >> uri [

	^ self rawValues at: 'uri' ifAbsent: []
]

{ #category : 'accessing' }
ACPContentBlock >> uri: aString [

	self rawValues at: 'uri' put: aString
]
