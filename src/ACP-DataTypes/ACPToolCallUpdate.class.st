Class {
	#name : 'ACPToolCallUpdate',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPToolCallUpdate >> content [

	^ self valuesAt: 'content' typed: ACPToolCallContent in: self rawValues
]

{ #category : 'accessing' }
ACPToolCallUpdate >> status [

	^ self rawValues at: 'status' ifAbsent: []
]

{ #category : 'accessing' }
ACPToolCallUpdate >> toolCallId [

	^ self rawValues at: 'toolCallId' ifAbsent: []
]
