"
I hold the ACP2CancellationToken of the incoming request handled by the current process.

Responsibility:
- I make the token available to request handlers without changing their signatures

Collaborators:
- ACP2Connection: binds the token with #value:during: around each incoming request
- ACP2CancellationToken: reads me in #current
"
Class {
	#name : 'ACP2CurrentCancellationToken',
	#superclass : 'DynamicVariable',
	#category : 'ACP2-Connection',
	#package : 'ACP2-Connection'
}
