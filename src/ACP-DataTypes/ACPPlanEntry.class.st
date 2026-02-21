Class {
	#name : 'ACPPlanEntry',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPPlanEntry >> content [

	^ self rawValues at: 'content' ifAbsent: []
]

{ #category : 'accessing' }
ACPPlanEntry >> priority [

	^ self rawValues at: 'priority' ifAbsent: []
]

{ #category : 'accessing' }
ACPPlanEntry >> status [

	^ self rawValues at: 'status' ifAbsent: []
]
