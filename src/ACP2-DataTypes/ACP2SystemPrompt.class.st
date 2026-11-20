"
I represent a client-provided system prompt sent on session/new or session/resume (ACP v2 `SystemPrompt`).

Responsibility:
- I hold the delivery mode ('append' or 'override'; unknown modes are preserved) and the prompt content blocks
- I build text content blocks and tell whether my content is text-only, as the protocol currently requires

Collaborators:
- ACP2SessionParams / ACP2SessionResumeParams: hold me under 'systemPrompt'
- ACP2ContentBlock: builds my content entries
- ACP2ClientConnection: validates me against the agent's advertised capabilities before sending
- ACP2Values: my superclass

Public API:
- append: / override: - class-side constructors with a single text block
- mode / mode:, content / content: - raw field access
- textContent: - add a text content block
- isAppend / isOverride / hasOnlyTextContent - queries

Implementation Points:
- Content entries are stored as plain dictionaries (like ACP2PromptParams prompt)
- Clients must only send me when the agent advertises session.systemPrompt, and must not send empty content
"
Class {
	#name : 'ACP2SystemPrompt',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'instance creation' }
ACP2SystemPrompt class >> append: aString [

	^ self mode: 'append' text: aString
]

{ #category : 'instance creation' }
ACP2SystemPrompt class >> mode: aModeString text: aString [

	^ self buildBy: [ :p |
		  p mode: aModeString.
		  p textContent: aString ]
]

{ #category : 'instance creation' }
ACP2SystemPrompt class >> override: aString [

	^ self mode: 'override' text: aString
]

{ #category : 'accessing' }
ACP2SystemPrompt >> content [

	^ self rawValues at: 'content' ifAbsent: [ #() ]
]

{ #category : 'accessing' }
ACP2SystemPrompt >> content: anArray [

	self rawValues at: 'content' put: anArray
]

{ #category : 'factory' }
ACP2SystemPrompt >> contentBlockClass [

	^ ACP2ContentBlock
]

{ #category : 'testing' }
ACP2SystemPrompt >> hasOnlyTextContent [

	^ self content allSatisfy: [ :each |
		  each isDictionary and: [ (each at: 'type' ifAbsent: [ nil ]) = 'text' ] ]
]

{ #category : 'testing' }
ACP2SystemPrompt >> isAppend [

	^ self mode = 'append'
]

{ #category : 'testing' }
ACP2SystemPrompt >> isOverride [

	^ self mode = 'override'
]

{ #category : 'accessing' }
ACP2SystemPrompt >> mode [

	^ self rawValues at: 'mode' ifAbsent: []
]

{ #category : 'accessing' }
ACP2SystemPrompt >> mode: aString [

	self rawValues at: 'mode' put: aString
]

{ #category : 'builder' }
ACP2SystemPrompt >> textContent: aString [

	self content: self content , { (self contentBlockClass text: aString) asDictionary }
]
