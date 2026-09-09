Class {
	#name : 'ACP2BaseSessionResponse',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2BaseSessionResponse >> configOptions [

	^ self valuesAt: 'configOptions' typed: ACP2ConfigOption in: self rawValues
]

{ #category : 'accessing' }
ACP2BaseSessionResponse >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]
