Class {
	#name : 'ACP2ToolCall',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2ToolCall >> kind [

	^ self rawValues at: 'kind' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ToolCall >> status [

	^ self rawValues at: 'status' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ToolCall >> title [

	^ self rawValues at: 'title' ifAbsent: []
]

{ #category : 'accessing' }
ACP2ToolCall >> toolCallId [

	^ self rawValues at: 'toolCallId' ifAbsent: []
]
