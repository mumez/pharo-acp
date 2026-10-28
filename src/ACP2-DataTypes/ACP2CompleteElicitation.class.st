"
I represent an elicitation/complete notification: the agent reports that a URL-mode elicitation has finished.

Responsibility:
- I expose the ID of the completed elicitation

Collaborators:
- ACP2CreateElicitation: the URL-mode request whose #elicitationId I refer to
- ACP2Values: my superclass

Public API:
- elicitationId - opaque ID of the completed elicitation

Implementation Points:
- Clients MUST ignore unknown or already-completed IDs
"
Class {
	#name : 'ACP2CompleteElicitation',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2CompleteElicitation >> elicitationId [

	^ self rawValues at: 'elicitationId' ifAbsent: []
]
