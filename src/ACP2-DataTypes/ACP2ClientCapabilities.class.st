Class {
	#name : 'ACP2ClientCapabilities',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'converting' }
ACP2ClientCapabilities >> asDictionary [

	| dict |
	dict := super asDictionary.
	dict at: 'fs' put: self fs asDictionary.
	^ dict
]

{ #category : 'accessing' }
ACP2ClientCapabilities >> fs [

	^ self rawValues at: 'fs' ifAbsentPut: [ ACP2FileSystemCapability new ]
]

{ #category : 'accessing' }
ACP2ClientCapabilities >> fs: anObject [

	^ self rawValues at: 'fs' put: anObject
]

{ #category : 'accessing' }
ACP2ClientCapabilities >> terminal [

	^ self rawValues at: 'terminal' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACP2ClientCapabilities >> terminal: aBoolean [

	^ self rawValues at: 'terminal' put: aBoolean
]

{ #category : 'instance creation' }
ACP2ClientCapabilities class >> fromDictionary: aDictionary [

	| instance |
	instance := super fromDictionary: aDictionary.
	instance rawValues at: 'fs' ifPresent: [ :dict | instance fs: ACP2FileSystemCapability fromDictionary: dict ].
	^ instance
]