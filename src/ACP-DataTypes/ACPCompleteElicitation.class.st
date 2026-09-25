"
I represent an elicitation/complete notification: the agent reports that a URL-mode elicitation has finished.

Responsibility:
- I expose the ID of the completed elicitation

Collaborators:
- ACPCreateElicitation: the URL-mode request whose #elicitationId I refer to
- ACPValues: my superclass

Public API:
- elicitationId - opaque ID of the completed elicitation

Implementation Points:
- Clients MUST ignore unknown or already-completed IDs
"
Class {
	#name : 'ACPCompleteElicitation',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPCompleteElicitation >> elicitationId [

	^ self rawValues at: 'elicitationId' ifAbsent: []
]
