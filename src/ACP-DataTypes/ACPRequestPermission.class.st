Class {
	#name : 'ACPRequestPermission',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPRequestPermission >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]

{ #category : 'accessing' }
ACPRequestPermission >> toolCall [

	^ self valueAt: 'toolCall' typed: ACPToolCall in: self rawValues
]

{ #category : 'accessing' }
ACPRequestPermission >> options [

	^ self valuesAt: 'options' typed: ACPPermissionOption in: self rawValues
]

{ #category : 'factory' }
ACPRequestPermission >> makeResponse [

	^ ACPRequestPermissionResponse new
]
