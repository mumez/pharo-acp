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

{ #category : 'converting' }
ACPContentBlock >> asDictionary [

	^ self rawValues ifNil: [ Dictionary new ]
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
ACPContentBlock >> uri [

	^ self rawValues at: 'uri' ifAbsent: []
]

{ #category : 'accessing' }
ACPContentBlock >> uri: aString [

	self rawValues at: 'uri' put: aString
]
