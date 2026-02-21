Class {
	#name : 'ACPRequestPermissionResponse',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'instance creation' }
ACPRequestPermissionResponse class >> selected: anOptionId [

	^ self buildBy: [ :r | r selectOptionId: anOptionId ]
]

{ #category : 'instance creation' }
ACPRequestPermissionResponse class >> cancelled [

	^ self buildBy: [ :r | r cancel ]
]

{ #category : 'instance creation' }
ACPRequestPermissionResponse class >> allowOnce [

	^ self buildBy: [ :r | r allowOnce ]
]

{ #category : 'instance creation' }
ACPRequestPermissionResponse class >> allowAlways [

	^ self buildBy: [ :r | r allowAlways ]
]

{ #category : 'instance creation' }
ACPRequestPermissionResponse class >> rejectOnce [

	^ self buildBy: [ :r | r rejectOnce ]
]

{ #category : 'instance creation' }
ACPRequestPermissionResponse class >> rejectAlways [

	^ self buildBy: [ :r | r rejectAlways ]
]

{ #category : 'accessing' }
ACPRequestPermissionResponse >> outcome [

	^ self outcomeDict at: 'outcome' ifAbsent: []
]

{ #category : 'accessing' }
ACPRequestPermissionResponse >> optionId [

	^ self outcomeDict at: 'optionId' ifAbsent: []
]

{ #category : 'testing' }
ACPRequestPermissionResponse >> isSelected [

	^ self outcome = 'selected'
]

{ #category : 'testing' }
ACPRequestPermissionResponse >> isCancelled [

	^ self outcome = 'cancelled'
]

{ #category : 'actions' }
ACPRequestPermissionResponse >> selectOptionId: anOptionId [

	self rawValues at: 'outcome' put: {
		('outcome' -> 'selected').
		('optionId' -> anOptionId) } asDictionary
]

{ #category : 'actions' }
ACPRequestPermissionResponse >> allowOnce [

	self selectOptionId: 'allow_once'
]

{ #category : 'actions' }
ACPRequestPermissionResponse >> allowAlways [

	self selectOptionId: 'allow_always'
]

{ #category : 'actions' }
ACPRequestPermissionResponse >> rejectOnce [

	self selectOptionId: 'reject_once'
]

{ #category : 'actions' }
ACPRequestPermissionResponse >> rejectAlways [

	self selectOptionId: 'reject_always'
]

{ #category : 'actions' }
ACPRequestPermissionResponse >> cancel [

	self rawValues at: 'outcome' put: { ('outcome' -> 'cancelled') } asDictionary
]

{ #category : 'private' }
ACPRequestPermissionResponse >> outcomeDict [

	^ self rawValues at: 'outcome' ifAbsent: [ Dictionary new ]
]
