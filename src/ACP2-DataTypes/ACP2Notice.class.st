"
I represent a v2 notice session update: fire-and-forget information for the user.

Responsibility:
- I expose the severity, title, and optional description of the notice

Collaborators:
- ACP2SessionUpdate: creates me via #notice

Public API:
- severity - the raw severity string (info, warning, error, or an extension value)
- isInfo / isWarning / isError - severity tests
- title / description - the text to show

Implementation Points:
- Notices are live events, not session history; a client may ignore them
"
Class {
	#name : 'ACP2Notice',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2Notice >> description [

	^ self rawValues at: 'description' ifAbsent: [ nil ]
]

{ #category : 'testing' }
ACP2Notice >> isError [

	^ self severity = 'error'
]

{ #category : 'testing' }
ACP2Notice >> isInfo [

	^ self severity = 'info'
]

{ #category : 'testing' }
ACP2Notice >> isWarning [

	^ self severity = 'warning'
]

{ #category : 'accessing' }
ACP2Notice >> severity [

	^ self rawValues at: 'severity' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACP2Notice >> title [

	^ self rawValues at: 'title' ifAbsent: [ nil ]
]
