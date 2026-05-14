Class {
	#name : 'ACPMcpServerStdio',
	#superclass : 'ACPMcpServer',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPMcpServerStdio >> asDictionary [

	| dict |
	dict := super asDictionary.
	dict at: 'env' put: (self env collect: [ :each | each asDictionary ]).
	^ dict
]

{ #category : 'accessing' }
ACPMcpServerStdio >> addEnvNamed: anEnvName value: anEnvValue [

	self env: (self env , {
				 (ACPEnvVariable buildBy: [ :envVar |
					  envVar
						  name: anEnvName;
						  value: anEnvValue ]) })
]

{ #category : 'accessing' }
ACPMcpServerStdio >> args [

	^ self rawValues at: 'args' ifAbsent: [ #() ]
]

{ #category : 'accessing' }
ACPMcpServerStdio >> args: anArray [
	| normalizedArgs |
	normalizedArgs := self normalizedArrayLikeDataTypeSourceFrom: anArray.
	self rawValues at: 'args' put: normalizedArgs asArray
]

{ #category : 'accessing' }
ACPMcpServerStdio >> command [

	^ self rawValues at: 'command' ifAbsent: []
]

{ #category : 'accessing' }
ACPMcpServerStdio >> command: aString [

	self rawValues at: 'command' put: aString
]

{ #category : 'private' }
ACPMcpServerStdio >> ensureRequired [

	super ensureRequired.
	self rawValues at: 'args' ifAbsentPut: [ #() ].
	self rawValues at: 'env' ifAbsentPut: [ #() ].
	^ self
]

{ #category : 'accessing' }
ACPMcpServerStdio >> env [

	^ self valuesAt: 'env' typed: ACPEnvVariable in: self rawValues
]

{ #category : 'accessing' }
ACPMcpServerStdio >> env: anArray [

	self
		rawValues
		at: 'env'
		put: (self dataTypeValuesFromRawArrayLikeValue: anArray for: ACPEnvVariable)
]
