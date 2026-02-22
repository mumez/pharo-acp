Class {
	#name : 'ACPToolCallContent',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPToolCallContent >> content [

	^ self valueAt: 'content' typed: ACPContentBlock in: self rawValues
]

{ #category : 'accessing' }
ACPToolCallContent >> type [

	^ self rawValues at: 'type' ifAbsent: []
]
