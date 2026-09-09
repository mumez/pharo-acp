Class {
	#name : 'ACP2FileSystemCapability',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2FileSystemCapability >> readTextFile [

	^ self rawValues at: 'readTextFile' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACP2FileSystemCapability >> readTextFile: aBoolean [

	self rawValues at: 'readTextFile' put: aBoolean
]

{ #category : 'accessing' }
ACP2FileSystemCapability >> writeTextFile [

	^ self rawValues at: 'writeTextFile' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACP2FileSystemCapability >> writeTextFile: aBoolean [

	self rawValues at: 'writeTextFile' put: aBoolean
]
