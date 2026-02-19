Class {
	#name : 'ACPPromptResponse',
	#superclass : 'ACPReturnValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPPromptResponse >> stopReason [

	^ self rawValues at: 'stopReason' ifAbsent: []
]

{ #category : 'accessing' }
ACPPromptResponse >> usage [

	^ self rawValues at: 'usage' ifAbsent: []
]
