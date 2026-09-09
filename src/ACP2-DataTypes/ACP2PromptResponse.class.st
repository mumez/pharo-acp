Class {
	#name : 'ACP2PromptResponse',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2PromptResponse >> stopReason [

	^ self rawValues at: 'stopReason' ifAbsent: []
]

{ #category : 'accessing' }
ACP2PromptResponse >> usage [

	^ self rawValues at: 'usage' ifAbsent: []
]
