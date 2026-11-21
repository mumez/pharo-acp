"
I represent a v2 session_message session update: an upsert for a message exchanged between sessions (e.g. a parent and its subagent).

Responsibility:
- I identify the message, its sender and recipient sessions, and their message ids
- I expose the message content

Collaborators:
- ACP2SessionUpdate: creates me via #sessionMessage
- ACP2ContentBlock: the typed element of content

Public API:
- messageId - the message this update belongs to
- senderSessionId / recipientSessionId - the sessions on each side, or nil
- senderMessageId / recipientMessageId - the related message in each session, or nil
- content - the content blocks (empty when absent or null)

Implementation Points:
- Streaming text for the same message arrives as session_message_chunk, read with ACP2SessionUpdate #messageId / #content
"
Class {
	#name : 'ACP2SessionMessage',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'accessing' }
ACP2SessionMessage >> content [

	^ self valuesAt: 'content' typed: ACP2ContentBlock in: self rawValues
]

{ #category : 'accessing' }
ACP2SessionMessage >> messageId [

	^ self rawValues at: 'messageId' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACP2SessionMessage >> recipientMessageId [

	^ self rawValues at: 'recipientMessageId' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACP2SessionMessage >> recipientSessionId [

	^ self rawValues at: 'recipientSessionId' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACP2SessionMessage >> senderMessageId [

	^ self rawValues at: 'senderMessageId' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ACP2SessionMessage >> senderSessionId [

	^ self rawValues at: 'senderSessionId' ifAbsent: [ nil ]
]
