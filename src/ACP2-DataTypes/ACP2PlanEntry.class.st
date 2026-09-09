Class {
	#name : 'ACP2PlanEntry',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2PlanEntry >> content [

	^ self rawValues at: 'content' ifAbsent: []
]

{ #category : 'accessing' }
ACP2PlanEntry >> priority [

	^ self rawValues at: 'priority' ifAbsent: []
]

{ #category : 'accessing' }
ACP2PlanEntry >> status [

	^ self rawValues at: 'status' ifAbsent: []
]
