"
I represent an MCP server configuration in session params.

Transport type is determined by the 'type' field:
- absent or 'stdio': command, args, env
- 'http' or 'sse': url, headers
"
Class {
	#name : 'ACP2McpServer',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'converting' }
ACP2McpServer >> asDictionary [

	| dict |
	dict := super asDictionary.
	(self rawValues includesKey: 'env') ifTrue: [
		dict at: 'env' put: (self env collect: [ :each | each asDictionary ]) ].
	(self rawValues includesKey: 'headers') ifTrue: [
		dict at: 'headers' put: (self headers collect: [ :h | h asDictionary ]) ].
	^ dict
]

{ #category : 'accessing' }
ACP2McpServer >> addEnvNamed: anEnvName value: anEnvValue [

	self env: (self env , {
				 (ACP2EnvVariable buildBy: [ :envVar |
					  envVar
						  name: anEnvName;
						  value: anEnvValue ]) })
]

{ #category : 'accessing' }
ACP2McpServer >> addHeaderNamed: aHeaderName value: aHeaderValue [

	self headers: (self headers , {
				 (ACP2HttpHeader buildBy: [ :header |
					  header
						  name: aHeaderName;
						  value: aHeaderValue ]) })
]

{ #category : 'accessing' }
ACP2McpServer >> args [

	^ self rawValues at: 'args' ifAbsent: [ #() ]
]

{ #category : 'accessing' }
ACP2McpServer >> args: anArray [

	| normalizedArgs |
	normalizedArgs := self normalizedArrayLikeDataTypeSourceFrom: anArray.
	self rawValues at: 'args' put: normalizedArgs asArray
]

{ #category : 'accessing' }
ACP2McpServer >> command [

	^ self rawValues at: 'command' ifAbsent: []
]

{ #category : 'accessing' }
ACP2McpServer >> command: aString [

	self rawValues at: 'command' put: aString
]

{ #category : 'accessing' }
ACP2McpServer >> env [

	^ self valuesAt: 'env' typed: ACP2EnvVariable in: self rawValues
]

{ #category : 'accessing' }
ACP2McpServer >> env: anArray [

	self
		rawValues
		at: 'env'
		put: (self dataTypeValuesFromRawArrayLikeValue: anArray for: ACP2EnvVariable)
]

{ #category : 'accessing' }
ACP2McpServer >> headers [

	^ self valuesAt: 'headers' typed: ACP2HttpHeader in: self rawValues
]

{ #category : 'accessing' }
ACP2McpServer >> headers: anArray [

	self
		rawValues
		at: 'headers'
		put: (self dataTypeValuesFromRawArrayLikeValue: anArray for: ACP2HttpHeader)
]

{ #category : 'initialization' }
ACP2McpServer >> ensureRequired [

	super ensureRequired.
	self rawValues at: 'name' ifAbsentPut: [ '' ].
	(#( 'http' 'sse' ) includes: self type)
		ifTrue: [
			self rawValues at: 'url' ifAbsentPut: [ '' ].
			self rawValues at: 'headers' ifAbsentPut: [ #() ] ].
	self type ifNil: [
		self rawValues at: 'command' ifAbsentPut: [ '' ].
		self rawValues at: 'args' ifAbsentPut: [ #() ].
		self rawValues at: 'env' ifAbsentPut: [ #() ] ]
]

{ #category : 'accessing' }
ACP2McpServer >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACP2McpServer >> name: aString [

	self rawValues at: 'name' put: aString
]

{ #category : 'accessing' }
ACP2McpServer >> type [

	^ self rawValues at: 'type' ifAbsent: []
]

{ #category : 'accessing' }
ACP2McpServer >> type: aString [

	self rawValues at: 'type' put: aString
]

{ #category : 'accessing' }
ACP2McpServer >> url [

	^ self rawValues at: 'url' ifAbsent: []
]

{ #category : 'accessing' }
ACP2McpServer >> url: aString [

	self rawValues at: 'url' put: aString
]
