Class {
	#name : 'ACPTestTransport',
	#superclass : 'Object',
	#instVars : [
		'inbox',
		'outbox',
		'isClosed'
	],
	#category : 'ACP-Tests'
}

{ #category : 'instance creation' }
ACPTestTransport class >> loopbackPair [
	"Create two cross-wired transports. Writing to one delivers to the other's inbox."

	| clientTransport agentTransport clientToAgent agentToClient |
	clientToAgent := SharedQueue new.
	agentToClient := SharedQueue new.
	clientTransport := self inbox: agentToClient outbox: clientToAgent.
	agentTransport := self inbox: clientToAgent outbox: agentToClient.
	^ { clientTransport. agentTransport }
]

{ #category : 'instance creation' }
ACPTestTransport class >> inbox: anInbox outbox: anOutbox [

	^ self new
		  inbox: anInbox;
		  outbox: anOutbox;
		  yourself
]

{ #category : 'operations' }
ACPTestTransport >> close [

	isClosed := true.
	inbox nextPut: nil
]

{ #category : 'initialization' }
ACPTestTransport >> initialize [

	super initialize.
	isClosed := false
]

{ #category : 'accessing' }
ACPTestTransport >> inbox: aSharedQueue [

	inbox := aSharedQueue
]

{ #category : 'testing' }
ACPTestTransport >> isClosed [

	^ isClosed
]

{ #category : 'accessing' }
ACPTestTransport >> outbox: aSharedQueue [

	outbox := aSharedQueue
]

{ #category : 'operations' }
ACPTestTransport >> readMessage [
	"Block until a message arrives. Return nil on close."

	| message |
	message := inbox next.
	^ message
]

{ #category : 'operations' }
ACPTestTransport >> writeMessage: aDictionary [

	isClosed ifTrue: [ ACPError transportIsClosed signal ].
	outbox nextPut: aDictionary
]
