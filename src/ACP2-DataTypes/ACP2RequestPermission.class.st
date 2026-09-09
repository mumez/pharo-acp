Class {
	#name : 'ACP2RequestPermission',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2RequestPermission >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACP2RequestPermission >> toolCall [

	^ self valueAt: 'toolCall' typed: ACP2ToolCall in: self rawValues
]

{ #category : 'accessing' }
ACP2RequestPermission >> options [

	^ self valuesAt: 'options' typed: ACP2PermissionOption in: self rawValues
]

{ #category : 'factory' }
ACP2RequestPermission >> makeResponse [

	^ ACP2RequestPermissionResponse new
]
