"
I represent a single streamed content chunk in a session/update notification.

Responsibility:
- I decode a chunk dictionary received during a streaming prompt response,
  wrapping the nested 'content' dictionary as an ACP2ContentBlock.
- Each instance is passed to the client handler for incremental display.

Collaborators:
- ACP2ContentBlock: I instantiate it on demand from the 'content' sub-dictionary
- ACP2Values: my superclass

Public API:
- content - returns ACP2ContentBlock wrapping 'content', or nil if absent
"
Class {
	#name : 'ACP2ContentChunk',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2ContentChunk >> content [

	^ (self rawValues at: 'content' ifAbsent: [ ^ nil ])
		  ifNotNil: [ :dict | ACP2ContentBlock fromDictionary: dict ]
]
