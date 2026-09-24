"
I represent one incoming request from the agent that is being handled in its own process.

Responsibility:
- I keep the request id, the Process handling it, and its ACPCancellationToken together,
  so a registered request always has both a process to clean up and a token to cancel

Collaborators:
- ACPConnection: creates me in #handleIncomingRequest: and keeps me in its incomingRequests registry
- ACPCancellationToken: cancelled through me when $/cancel_request arrives

Public API and Key Messages:
- #id / #process / #token - accessors
- #cancel - cancel the token (cooperative; the process keeps running)
- #terminate - terminate the process, unless it is the calling process
"
Class {
	#name : 'ACPIncomingRequest',
	#superclass : 'Object',
	#instVars : [
		'id',
		'process',
		'token'
	],
	#category : 'ACP-Connection',
	#package : 'ACP-Connection'
}

{ #category : 'instance creation' }
ACPIncomingRequest class >> id: aRequestId process: aProcess token: aToken [

	^ self new
		  setId: aRequestId process: aProcess token: aToken;
		  yourself
]

{ #category : 'operations' }
ACPIncomingRequest >> cancel [

	self token cancel
]

{ #category : 'accessing' }
ACPIncomingRequest >> id [

	^ id
]

{ #category : 'accessing' }
ACPIncomingRequest >> process [

	^ process
]

{ #category : 'initialization' }
ACPIncomingRequest >> setId: aRequestId process: aProcess token: aToken [

	id := aRequestId.
	process := aProcess.
	token := aToken
]

{ #category : 'operations' }
ACPIncomingRequest >> terminate [

	self process == Processor activeProcess ifFalse: [ self process terminate ]
]

{ #category : 'accessing' }
ACPIncomingRequest >> token [

	^ token
]
