"
I represent an MCP server configuration in session params.

Transport type is determined by the 'type' field:
- absent or 'stdio': command, args, env
- 'http' or 'sse': url, headers
"
Class {
	#name : 'ACPMcpServer',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPMcpServer >> asDictionary [

	| dict |
	dict := super asDictionary.
	(self rawValues includesKey: 'env') ifTrue: [
		dict at: 'env' put: (self env collect: [ :each | each asDictionary ]) ].
	(self rawValues includesKey: 'headers') ifTrue: [
		dict at: 'headers' put: (self headers collect: [ :h | h asDictionary ]) ].
	^ dict
]

{ #category : 'accessing' }
ACPMcpServer >> addEnvNamed: anEnvName value: anEnvValue [

	self env: (self env , {
				 (ACPEnvVariable buildBy: [ :envVar |
					  envVar
						  name: anEnvName;
						  value: anEnvValue ]) })
]

{ #category : 'accessing' }
ACPMcpServer >> addHeaderNamed: aHeaderName value: aHeaderValue [

	self headers: (self headers , {
				 (ACPHttpHeader buildBy: [ :header |
					  header
						  name: aHeaderName;
						  value: aHeaderValue ]) })
]

{ #category : 'accessing' }
ACPMcpServer >> args [

	^ self rawValues at: 'args' ifAbsent: [ #() ]
]

{ #category : 'accessing' }
ACPMcpServer >> args: anArray [

	| normalizedArgs |
	normalizedArgs := self normalizedArrayLikeDataTypeSourceFrom: anArray.
	self rawValues at: 'args' put: normalizedArgs asArray
]

{ #category : 'accessing' }
ACPMcpServer >> command [

	^ self rawValues at: 'command' ifAbsent: []
]

{ #category : 'accessing' }
ACPMcpServer >> command: aString [

	self rawValues at: 'command' put: aString
]

{ #category : 'accessing' }
ACPMcpServer >> env [

	^ self valuesAt: 'env' typed: ACPEnvVariable in: self rawValues
]

{ #category : 'accessing' }
ACPMcpServer >> env: anArray [

	self
		rawValues
		at: 'env'
		put: (self dataTypeValuesFromRawArrayLikeValue: anArray for: ACPEnvVariable)
]

{ #category : 'accessing' }
ACPMcpServer >> headers [

	^ self valuesAt: 'headers' typed: ACPHttpHeader in: self rawValues
]

{ #category : 'accessing' }
ACPMcpServer >> headers: anArray [

	self
		rawValues
		at: 'headers'
		put: (self dataTypeValuesFromRawArrayLikeValue: anArray for: ACPHttpHeader)
]

{ #category : 'accessing' }
ACPMcpServer >> name [

	^ self rawValues at: 'name' ifAbsent: []
]

{ #category : 'accessing' }
ACPMcpServer >> name: aString [

	self rawValues at: 'name' put: aString
]

{ #category : 'accessing' }
ACPMcpServer >> type [

	^ self rawValues at: 'type' ifAbsent: []
]

{ #category : 'accessing' }
ACPMcpServer >> type: aString [

	self rawValues at: 'type' put: aString
]

{ #category : 'accessing' }
ACPMcpServer >> url [

	^ self rawValues at: 'url' ifAbsent: []
]

{ #category : 'accessing' }
ACPMcpServer >> url: aString [

	self rawValues at: 'url' put: aString
]
