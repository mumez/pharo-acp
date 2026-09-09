Class {
	#name : 'ACP2RequestPermissionResponse',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'instance creation' }
ACP2RequestPermissionResponse class >> selected: anOptionId [

	^ self buildBy: [ :r | r selectOptionId: anOptionId ]
]

{ #category : 'instance creation' }
ACP2RequestPermissionResponse class >> cancelled [

	^ self buildBy: [ :r | r cancel ]
]

{ #category : 'instance creation' }
ACP2RequestPermissionResponse class >> allowOnce [

	^ self buildBy: [ :r | r allowOnce ]
]

{ #category : 'instance creation' }
ACP2RequestPermissionResponse class >> allowAlways [

	^ self buildBy: [ :r | r allowAlways ]
]

{ #category : 'instance creation' }
ACP2RequestPermissionResponse class >> rejectOnce [

	^ self buildBy: [ :r | r rejectOnce ]
]

{ #category : 'instance creation' }
ACP2RequestPermissionResponse class >> rejectAlways [

	^ self buildBy: [ :r | r rejectAlways ]
]

{ #category : 'accessing' }
ACP2RequestPermissionResponse >> outcome [

	^ self outcomeDict at: 'outcome' ifAbsent: []
]

{ #category : 'accessing' }
ACP2RequestPermissionResponse >> optionId [

	^ self outcomeDict at: 'optionId' ifAbsent: []
]

{ #category : 'testing' }
ACP2RequestPermissionResponse >> isSelected [

	^ self outcome = 'selected'
]

{ #category : 'testing' }
ACP2RequestPermissionResponse >> isCancelled [

	^ self outcome = 'cancelled'
]

{ #category : 'actions' }
ACP2RequestPermissionResponse >> selectOptionId: anOptionId [

	self rawValues at: 'outcome' put: {
		('outcome' -> 'selected').
		('optionId' -> anOptionId) } asDictionary
]

{ #category : 'actions' }
ACP2RequestPermissionResponse >> allowOnce [

	self selectOptionId: 'allow_once'
]

{ #category : 'actions' }
ACP2RequestPermissionResponse >> allowAlways [

	self selectOptionId: 'allow_always'
]

{ #category : 'actions' }
ACP2RequestPermissionResponse >> rejectOnce [

	self selectOptionId: 'reject_once'
]

{ #category : 'actions' }
ACP2RequestPermissionResponse >> rejectAlways [

	self selectOptionId: 'reject_always'
]

{ #category : 'actions' }
ACP2RequestPermissionResponse >> cancel [

	self rawValues at: 'outcome' put: { ('outcome' -> 'cancelled') } asDictionary
]

{ #category : 'private' }
ACP2RequestPermissionResponse >> outcomeDict [

	^ self rawValues at: 'outcome' ifAbsent: [ Dictionary new ]
]
