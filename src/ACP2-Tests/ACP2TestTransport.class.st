Class {
	#name : 'ACP2TestTransport',
	#superclass : 'Object',
	#instVars : [
		'inbox',
		'outbox',
		'isClosed'
	],
	#category : 'ACP2-Tests',
	#package : 'ACP2-Tests'
}

{ #category : 'instance creation' }
ACP2TestTransport class >> inbox: anInbox outbox: anOutbox [

	^ self new
		  inbox: anInbox;
		  outbox: anOutbox;
		  yourself
]

{ #category : 'instance creation' }
ACP2TestTransport class >> loopbackPair [
	"Create two cross-wired transports. Writing to one delivers to the other's inbox."

	| clientTransport agentTransport clientToAgent agentToClient |
	clientToAgent := SharedQueue new.
	agentToClient := SharedQueue new.
	clientTransport := self inbox: agentToClient outbox: clientToAgent.
	agentTransport := self inbox: clientToAgent outbox: agentToClient.
	^ { clientTransport. agentTransport }
]

{ #category : 'operations' }
ACP2TestTransport >> close [
	"Signal EOF to the peer by putting nil into outbox (which is the peer's inbox)."

	isClosed := true.
	outbox nextPut: nil
]

{ #category : 'accessing' }
ACP2TestTransport >> inbox: aSharedQueue [

	inbox := aSharedQueue
]

{ #category : 'initialization' }
ACP2TestTransport >> initialize [

	super initialize.
	isClosed := false
]

{ #category : 'testing' }
ACP2TestTransport >> isClosed [

	^ isClosed
]

{ #category : 'accessing' }
ACP2TestTransport >> outbox: aSharedQueue [

	outbox := aSharedQueue
]

{ #category : 'operations' }
ACP2TestTransport >> readMessage [
	"Block until a message arrives. Return nil on close."

	| message |
	message := inbox next.
	^ message
]

{ #category : 'operations' }
ACP2TestTransport >> writeMessage: aDictionary [

	isClosed ifTrue: [ ACP2Error transportIsClosed signal ].
	outbox nextPut: aDictionary
]
