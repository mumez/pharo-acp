"
I represent the nested resource payload inside a content block of type 'resource'.

Responsibility:
- I hold the uri, mimeType, and content (text or blob) of an embedded resource.
- I am the value of the 'resource' key in an EmbeddedResource content block.

Public API:
- uri      - resource URI
- mimeType - optional MIME type
- text     - text content (mutually exclusive with blob)
- blob     - base64 binary content (mutually exclusive with text)
"
Class {
	#name : 'ACP2EmbeddedResource',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2EmbeddedResource >> blob [

	^ self rawValues at: 'blob' ifAbsent: []
]

{ #category : 'accessing' }
ACP2EmbeddedResource >> blob: aString [

	self rawValues at: 'blob' put: aString
]

{ #category : 'accessing' }
ACP2EmbeddedResource >> mimeType [

	^ self rawValues at: 'mimeType' ifAbsent: []
]

{ #category : 'accessing' }
ACP2EmbeddedResource >> mimeType: aString [

	aString ifNil: [ ^ self ].
	self rawValues at: 'mimeType' put: aString
]

{ #category : 'accessing' }
ACP2EmbeddedResource >> text [

	^ self rawValues at: 'text' ifAbsent: []
]

{ #category : 'accessing' }
ACP2EmbeddedResource >> text: aString [

	self rawValues at: 'text' put: aString
]

{ #category : 'accessing' }
ACP2EmbeddedResource >> uri [

	^ self rawValues at: 'uri' ifAbsent: []
]

{ #category : 'accessing' }
ACP2EmbeddedResource >> uri: aString [

	self rawValues at: 'uri' put: aString
]
