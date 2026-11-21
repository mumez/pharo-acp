Class {
	#name : 'ACP2ToolCallContent',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2ToolCallContent >> content [

	^ self valueAt: 'content' typed: ACP2ContentBlock in: self rawValues
]

{ #category : 'accessing' }
ACP2ToolCallContent >> type [

	^ self rawValues at: 'type' ifAbsent: []
]

{ #category : 'testing' }
ACP2ToolCallContent >> isSession [

	^ self type = 'session'
]

{ #category : 'accessing' }
ACP2ToolCallContent >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: [ nil ]
]
