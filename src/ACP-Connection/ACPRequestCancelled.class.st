"
I am signaled by a request handler to abandon an incoming request that the agent has cancelled.

Responsibility:
- I let a handler stop its work after noticing the cancellation (see ACPCancellationToken>>signalIfCancelled)
- I carry the JSON-RPC Request Cancelled error code (-32800) used in the response

Collaborators:
- ACPCancellationToken: signals me from #signalIfCancelled
- ACPConnection: answers the request with error code -32800 when I escape from a handler

Public API and Key Messages:
- #code (class side) - the JSON-RPC error code for cancelled requests (-32800)

Implementation Points:
- I am an Abort, not an Error, so that generic #on: Error do: handlers
  (including the one in JRPCMessageProcessor) do not swallow the cancellation
"
Class {
	#name : 'ACPRequestCancelled',
	#superclass : 'Abort',
	#category : 'ACP-Connection',
	#package : 'ACP-Connection'
}

{ #category : 'accessing' }
ACPRequestCancelled class >> code [

	^ -32800
]

{ #category : 'accessing' }
ACPRequestCancelled >> messageText [

	^ messageText ifNil: [ 'Request cancelled' ]
]
