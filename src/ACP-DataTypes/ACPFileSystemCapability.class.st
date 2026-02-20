Class {
	#name : 'ACPFileSystemCapability',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPFileSystemCapability >> readTextFile [

	^ self rawValues at: 'readTextFile' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACPFileSystemCapability >> readTextFile: aBoolean [

	self rawValues at: 'readTextFile' put: aBoolean
]

{ #category : 'accessing' }
ACPFileSystemCapability >> writeTextFile [

	^ self rawValues at: 'writeTextFile' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACPFileSystemCapability >> writeTextFile: aBoolean [

	self rawValues at: 'writeTextFile' put: aBoolean
]
