Class {
	#name : 'ACPMcpServerSse',
	#superclass : 'ACPMcpServer',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPMcpServerSse >> asDictionary [

	| dict |
	dict := super asDictionary.
	dict at: 'headers' put: (self headers collect: [ :header | header asDictionary ]).
	^ dict
]

{ #category : 'accessing' }
ACPMcpServerSse >> addHeaderNamed: aHeaderName value: aHeaderValue [

	self headers: (self headers , {
				 (ACPHttpHeader buildBy: [ :header |
					  header
						  name: aHeaderName;
						  value: aHeaderValue ]) })
]

{ #category : 'private' }
ACPMcpServerSse >> ensureRequired [

	super ensureRequired.
	self rawValues at: 'type' put: 'sse'.
	self rawValues at: 'headers' ifAbsentPut: [ #() ].
	^ self
]

{ #category : 'accessing' }
ACPMcpServerSse >> headers [

	^ self valuesAt: 'headers' typed: ACPHttpHeader in: self rawValues
]

{ #category : 'accessing' }
ACPMcpServerSse >> headers: anArray [

	self
		rawValues
		at: 'headers'
		put: (self dataTypeValuesFromRawArrayLikeValue: anArray for: ACPHttpHeader)
]

{ #category : 'accessing' }
ACPMcpServerSse >> type [

	^ self rawValues at: 'type' ifAbsent: [ 'sse' ]
]

{ #category : 'accessing' }
ACPMcpServerSse >> url [

	^ self rawValues at: 'url' ifAbsent: []
]

{ #category : 'accessing' }
ACPMcpServerSse >> url: aString [

	self rawValues at: 'url' put: aString
]
