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
	#name : 'ACPEmbeddedResource',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPEmbeddedResource >> blob [

	^ self rawValues at: 'blob' ifAbsent: []
]

{ #category : 'accessing' }
ACPEmbeddedResource >> blob: aString [

	self rawValues at: 'blob' put: aString
]

{ #category : 'accessing' }
ACPEmbeddedResource >> mimeType [

	^ self rawValues at: 'mimeType' ifAbsent: []
]

{ #category : 'accessing' }
ACPEmbeddedResource >> mimeType: aString [

	aString ifNil: [ ^ self ].
	self rawValues at: 'mimeType' put: aString
]

{ #category : 'accessing' }
ACPEmbeddedResource >> text [

	^ self rawValues at: 'text' ifAbsent: []
]

{ #category : 'accessing' }
ACPEmbeddedResource >> text: aString [

	self rawValues at: 'text' put: aString
]

{ #category : 'accessing' }
ACPEmbeddedResource >> uri [

	^ self rawValues at: 'uri' ifAbsent: []
]

{ #category : 'accessing' }
ACPEmbeddedResource >> uri: aString [

	self rawValues at: 'uri' put: aString
]
