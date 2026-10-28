"
I hold the ACPCancellationToken of the incoming request handled by the current process.

Responsibility:
- I make the token available to request handlers without changing their signatures

Collaborators:
- ACPConnection: binds the token with #value:during: around each incoming request
- ACPCancellationToken: reads me in #current
"
Class {
	#name : 'ACPCurrentCancellationToken',
	#superclass : 'DynamicVariable',
	#category : 'ACP-Connection',
	#package : 'ACP-Connection'
}
