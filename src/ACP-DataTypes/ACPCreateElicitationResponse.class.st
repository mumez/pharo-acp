"
I represent the client's response to an elicitation/create request.

Responsibility:
- I carry the user's action ('accept', 'decline', or 'cancel') and, for accept, the submitted content

Collaborators:
- ACPCreateElicitation: creates me via #makeResponse
- ACPValues: my superclass

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
	#name : 'ACPCreateElicitationResponse',
	#superclass : 'ACPValues',
	#category : 'ACP-DataTypes',
	#package : 'ACP-DataTypes'
}

{ #category : 'instance creation' }
ACPCreateElicitationResponse class >> accepted: aDictionary [

	^ self buildBy: [ :r | r accept: aDictionary ]
]

{ #category : 'instance creation' }
ACPCreateElicitationResponse class >> cancelled [

	^ self buildBy: [ :r | r cancel ]
]

{ #category : 'instance creation' }
ACPCreateElicitationResponse class >> declined [

	^ self buildBy: [ :r | r decline ]
]

{ #category : 'actions' }
ACPCreateElicitationResponse >> accept [

	self rawValues at: 'action' put: 'accept'.
	self rawValues removeKey: 'content' ifAbsent: [  ]
]

{ #category : 'actions' }
ACPCreateElicitationResponse >> accept: aDictionary [

	self rawValues at: 'action' put: 'accept'.
	self rawValues at: 'content' put: aDictionary
]

{ #category : 'accessing' }
ACPCreateElicitationResponse >> action [

	^ self rawValues at: 'action' ifAbsent: []
]

{ #category : 'actions' }
ACPCreateElicitationResponse >> cancel [

	self rawValues at: 'action' put: 'cancel'.
	self rawValues removeKey: 'content' ifAbsent: [  ]
]

{ #category : 'accessing' }
ACPCreateElicitationResponse >> content [

	^ self rawValues at: 'content' ifAbsent: []
]

{ #category : 'actions' }
ACPCreateElicitationResponse >> decline [

	self rawValues at: 'action' put: 'decline'.
	self rawValues removeKey: 'content' ifAbsent: [  ]
]

{ #category : 'testing' }
ACPCreateElicitationResponse >> isAccepted [

	^ self action = 'accept'
]

{ #category : 'testing' }
ACPCreateElicitationResponse >> isCancelled [

	^ self action = 'cancel'
]

{ #category : 'testing' }
ACPCreateElicitationResponse >> isDeclined [

	^ self action = 'decline'
]
