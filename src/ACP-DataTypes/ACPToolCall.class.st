Class {
	#name : 'ACPToolCall',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPToolCall >> kind [

	^ self rawValues at: 'kind' ifAbsent: []
]

{ #category : 'accessing' }
ACPToolCall >> status [

	^ self rawValues at: 'status' ifAbsent: []
]

{ #category : 'accessing' }
ACPToolCall >> title [

	^ self rawValues at: 'title' ifAbsent: []
]

{ #category : 'accessing' }
ACPToolCall >> toolCallId [

	^ self rawValues at: 'toolCallId' ifAbsent: []
]
