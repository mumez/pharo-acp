"
I represent a single streamed content chunk in a session/update notification.

Responsibility:
- I decode a chunk dictionary received during a streaming prompt response,
  wrapping the nested 'content' dictionary as an ACPContentBlock.
- Each instance is passed to the client handler for incremental display.

Collaborators:
- ACPContentBlock: I instantiate it on demand from the 'content' sub-dictionary
- ACPValues: my superclass

Public API:
- content - returns ACPContentBlock wrapping 'content', or nil if absent
"
Class {
	#name : 'ACPContentChunk',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'accessing' }
ACPContentChunk >> content [

	^ (self rawValues at: 'content' ifAbsent: [ ^ nil ])
		  ifNotNil: [ :dict | ACPContentBlock fromDictionary: dict ]
]
