Class {
	#name : 'ACPFileSystemCapability',
	#superclass : 'ACPParams',
	#instVars : [
		'readTextFile',
		'writeTextFile'
	],
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'converting' }
ACPFileSystemCapability >> asDictionary [

	| dict |
	dict := Dictionary new.
	self readTextFile ifNotNil: [ :v | dict at: 'readTextFile' put: v ].
	self writeTextFile ifNotNil: [ :v | dict at: 'writeTextFile' put: v ].
	self extraPropertiesOn: dict.
	^ dict
]

{ #category : 'accessing' }
ACPFileSystemCapability >> readTextFile [

	^ readTextFile
]

{ #category : 'accessing' }
ACPFileSystemCapability >> readTextFile: aBoolean [

	readTextFile := aBoolean
]

{ #category : 'accessing' }
ACPFileSystemCapability >> writeTextFile [

	^ writeTextFile
]

{ #category : 'accessing' }
ACPFileSystemCapability >> writeTextFile: aBoolean [

	writeTextFile := aBoolean
]
