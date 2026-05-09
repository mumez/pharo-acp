Class {
	#name : 'ACPBaseSessionResponse',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPBaseSessionResponse >> configOptions [

	^ self valuesAt: 'configOptions' typed: ACPConfigOption in: self rawValues
]

{ #category : 'accessing' }
ACPBaseSessionResponse >> sessionId [

	^ self rawValues at: 'sessionId' ifAbsent: []
]
