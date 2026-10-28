"
I represent one incoming request from the agent that is being handled in its own process.

Responsibility:
- I keep the request id, the Process handling it, and its ACP2CancellationToken together,
  so a registered request always has both a process to clean up and a token to cancel

Collaborators:
- ACP2Connection: creates me in #handleIncomingRequest: and keeps me in its incomingRequests registry
- ACP2CancellationToken: cancelled through me when $/cancel_request arrives

Public API and Key Messages:
- #id / #process / #token - accessors
- #cancel - cancel the token (cooperative; the process keeps running)
- #terminate - terminate the process, unless it is the calling process
"
Class {
	#name : 'ACP2IncomingRequest',
	#superclass : 'Object',
	#instVars : [
		'id',
		'process',
		'token'
	],
	#category : 'ACP2-Connection',
	#package : 'ACP2-Connection'
}

{ #category : 'instance creation' }
ACP2IncomingRequest class >> id: aRequestId process: aProcess token: aToken [

	^ self new
		  setId: aRequestId process: aProcess token: aToken;
		  yourself
]

{ #category : 'operations' }
ACP2IncomingRequest >> cancel [

	self token cancel
]

{ #category : 'accessing' }
ACP2IncomingRequest >> id [

	^ id
]

{ #category : 'accessing' }
ACP2IncomingRequest >> process [

	^ process
]

{ #category : 'initialization' }
ACP2IncomingRequest >> setId: aRequestId process: aProcess token: aToken [

	id := aRequestId.
	process := aProcess.
	token := aToken
]

{ #category : 'operations' }
ACP2IncomingRequest >> terminate [

	self process == Processor activeProcess ifFalse: [ self process terminate ]
]

{ #category : 'accessing' }
ACP2IncomingRequest >> token [

	^ token
]
