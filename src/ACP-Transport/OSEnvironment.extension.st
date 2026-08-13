Extension { #name : 'OSEnvironment' }

{ #category : '*ACP-Transport' }
OSEnvironment >> defaultEncoding [
	"Pharo 14 simplified OSEnvironment and removed UnixEnvironment>>#defaultEncoding.
	OSSubprocess still delegates here, so forward to the platform default."

	^ OSPlatform current defaultEncoding
]
