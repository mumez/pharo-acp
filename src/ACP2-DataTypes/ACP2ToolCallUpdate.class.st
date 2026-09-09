Class {
	#name : 'ACP2ToolCallUpdate',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2ToolCallUpdate >> content [

	^ self valuesAt: 'content' typed: ACP2ToolCallContent in: self rawValues
]

{ #category : 'accessing' }
ACP2ToolCallUpdate >> status [

	^ self rawValues at: 'status' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ToolCallUpdate >> toolCallId [

	^ self rawValues at: 'toolCallId' ifAbsent: []
]
