"
I represent a v2 compaction_update session update: an upsert for one context compaction.

Responsibility:
- I identify the compaction and report its status, summary, and error

Collaborators:
- ACP2SessionUpdate: creates me via #compactionUpdate
- ACP2ContentBlock: the typed element of summary

Public API:
- compactionId - the compaction this update belongs to
- status - the raw status string
- isInProgress / isCompleted / isFailed / isCancelled - status tests
- summary - the summary content blocks (empty when absent, null, or [])
- error - the failure description, or nil

Implementation Points:
- summary and error follow patch semantics on the wire (absent leaves the stored value unchanged);
  use rawValues includesKey: to tell an absent field from a cleared one
"
Class {
	#name : 'ACP2CompactionUpdate',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2CompactionUpdate >> compactionId [

	^ self rawValues at: 'compactionId' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACP2CompactionUpdate >> error [

	^ self rawValues at: 'error' ifAbsent: [ nil ]
]

{ #category : 'testing' }
ACP2CompactionUpdate >> isCancelled [

	^ self status = 'cancelled'
]

{ #category : 'testing' }
ACP2CompactionUpdate >> isCompleted [

	^ self status = 'completed'
]

{ #category : 'testing' }
ACP2CompactionUpdate >> isFailed [

	^ self status = 'failed'
]

{ #category : 'testing' }
ACP2CompactionUpdate >> isInProgress [

	^ self status = 'in_progress'
]

{ #category : 'accessing' }
ACP2CompactionUpdate >> status [

	^ self rawValues at: 'status' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACP2CompactionUpdate >> summary [

	^ self valuesAt: 'summary' typed: ACP2ContentBlock in: self rawValues
]
