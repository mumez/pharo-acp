Class {
	#name : 'ACPPromptResponse',
	#superclass : 'ACPResult',
	#category : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPPromptResponse >> stopReason [

	^ self rawDictionary at: 'stopReason' ifAbsent: []
]

{ #category : 'accessing' }
ACPPromptResponse >> usage [

	^ self rawDictionary at: 'usage' ifAbsent: []
]
