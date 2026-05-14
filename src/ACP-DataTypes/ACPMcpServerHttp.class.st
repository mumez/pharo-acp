Class {
	#name : 'ACPMcpServerHttp',
	#superclass : 'ACPMcpServer',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPMcpServerHttp >> asDictionary [

	| dict |
	dict := super asDictionary.
	dict at: 'headers' put: (self headers collect: [ :header | header asDictionary ]).
	^ dict
]

{ #category : 'accessing' }
ACPMcpServerHttp >> addHeaderNamed: aHeaderName value: aHeaderValue [

	self headers: (self headers , {
				 (ACPHttpHeader buildBy: [ :header |
					  header
						  name: aHeaderName;
						  value: aHeaderValue ]) })
]

{ #category : 'private' }
ACPMcpServerHttp >> ensureRequired [

	super ensureRequired.
	self rawValues at: 'type' put: 'http'.
	self rawValues at: 'headers' ifAbsentPut: [ #() ].
	^ self
]

{ #category : 'accessing' }
ACPMcpServerHttp >> headers [

	^ self valuesAt: 'headers' typed: ACPHttpHeader in: self rawValues
]

{ #category : 'accessing' }
ACPMcpServerHttp >> headers: anArray [

	self
		rawValues
		at: 'headers'
		put: (self dataTypeValuesFromRawArrayLikeValue: anArray for: ACPHttpHeader)
]

{ #category : 'accessing' }
ACPMcpServerHttp >> type [

	^ self rawValues at: 'type' ifAbsent: [ 'http' ]
]

{ #category : 'accessing' }
ACPMcpServerHttp >> url [

	^ self rawValues at: 'url' ifAbsent: []
]

{ #category : 'accessing' }
ACPMcpServerHttp >> url: aString [

	self rawValues at: 'url' put: aString
]
