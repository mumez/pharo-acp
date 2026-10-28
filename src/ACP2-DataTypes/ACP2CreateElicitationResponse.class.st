"
I represent the client's response to an elicitation/create request.

Responsibility:
- I carry the user's action ('accept', 'decline', or 'cancel') and, for accept, the submitted content

Collaborators:
- ACP2CreateElicitation: creates me via #makeResponse
- ACP2Values: my superclass

Public API:
- accepted: / declined / cancelled (class side) - ready-made responses
- accept: - accept with content (Dictionary of property name -> value)
- accept - accept without content (e.g. the user consented to a URL-mode interaction)
- decline - the user explicitly declined
- cancel - the user dismissed the request without choosing
- action / content / isAccepted / isDeclined / isCancelled

Implementation Points:
- In URL mode, accept means the user consented to open the URL, not that the external interaction completed
- Content values are strings, numbers, booleans, or arrays of strings, matching the requested schema
"
Class {
	#name : 'ACP2CreateElicitationResponse',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}

{ #category : 'instance creation' }
ACP2CreateElicitationResponse class >> accepted: aDictionary [

	^ self buildBy: [ :r | r accept: aDictionary ]
]

{ #category : 'instance creation' }
ACP2CreateElicitationResponse class >> cancelled [

	^ self buildBy: [ :r | r cancel ]
]

{ #category : 'instance creation' }
ACP2CreateElicitationResponse class >> declined [

	^ self buildBy: [ :r | r decline ]
]

{ #category : 'actions' }
ACP2CreateElicitationResponse >> accept [

	self setAction: 'accept'
]

{ #category : 'actions' }
ACP2CreateElicitationResponse >> accept: aDictionary [

	self setAction: 'accept'.
	self rawValues at: 'content' put: aDictionary
]

{ #category : 'accessing' }
ACP2CreateElicitationResponse >> action [

	^ self rawValues at: 'action' ifAbsent: []
]

{ #category : 'actions' }
ACP2CreateElicitationResponse >> cancel [

	self setAction: 'cancel'
]

{ #category : 'accessing' }
ACP2CreateElicitationResponse >> content [

	^ self rawValues at: 'content' ifAbsent: []
]

{ #category : 'actions' }
ACP2CreateElicitationResponse >> decline [

	self setAction: 'decline'
]

{ #category : 'private' }
ACP2CreateElicitationResponse >> setAction: anActionString [
	"Set the action and drop any content from an earlier action; #accept: adds its content afterwards."

	self rawValues at: 'action' put: anActionString.
	self rawValues removeKey: 'content' ifAbsent: [  ]
]

{ #category : 'testing' }
ACP2CreateElicitationResponse >> isAccepted [

	^ self action = 'accept'
]

{ #category : 'testing' }
ACP2CreateElicitationResponse >> isCancelled [

	^ self action = 'cancel'
]

{ #category : 'testing' }
ACP2CreateElicitationResponse >> isDeclined [

	^ self action = 'decline'
]
