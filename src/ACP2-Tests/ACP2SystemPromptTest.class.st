"
I test client-provided system prompt support (ACP v2 `systemPrompt` on session/new and session/resume).

Responsibility:
- I verify ACP2SystemPrompt and ACP2SessionSystemPromptCapabilities encode and decode the wire format
- I verify ACP2AgentCapabilities reads `session.systemPrompt`
- I verify ACP2ClientConnection sends systemPrompt only when the agent advertises it, and rejects unsupported modes and invalid content before sending

Collaborators:
- ACP2ClientConnection, ACP2Connection, ACP2TestTransport, ACP2MockHandler
"
Class {
	#name : 'ACP2SystemPromptTest',
	#superclass : 'TestCase',
	#instVars : [
		'clientConnection',
		'agentTransport',
		'handler',
		'connection'
	],
	#category : 'ACP2-Tests',
	#package : 'ACP2-Tests'
}

{ #category : 'helpers' }
ACP2SystemPromptTest >> agentAdvertisesSystemPrompt: aDictionary [

	clientConnection agentInfo: (ACP2InitializeResponse fromDictionary: {
				 ('protocolVersion' -> 2).
				 ('capabilities' -> { ('session'
				   -> { ('systemPrompt' -> aDictionary) } asDictionary) } asDictionary) }
				 asDictionary)
]

{ #category : 'helpers' }
ACP2SystemPromptTest >> agentReadMessage [
	"Read the next message written by the client, failing instead of hanging if none arrives."

	| message received reader |
	received := Semaphore new.
	reader := [
	          message := agentTransport readMessage.
	          received signal ] fork.
	(received waitTimeoutSeconds: 2) ifFalse: [ ^ message ].
	reader terminate.
	self fail: 'No message from the client within 2 seconds'
]

{ #category : 'helpers' }
ACP2SystemPromptTest >> overrideModeCapability [

	^ { ('mode' -> { ('override' -> Dictionary new) } asDictionary) } asDictionary
]

{ #category : 'helpers' }
ACP2SystemPromptTest >> respondEmptyResultTo: aRequest [

	agentTransport writeMessage: {
			('jsonrpc' -> '2.0').
			('id' -> (aRequest at: 'id')).
			('result' -> { ('sessionId' -> 'sess-001') } asDictionary) } asDictionary
]

{ #category : 'helpers' }
ACP2SystemPromptTest >> sendNewSessionWith: aSystemPrompt [
	"Send session/new in a background process and return the request the agent receives."

	| request done |
	done := Semaphore new.
	connection startReadLoop.
	[
	clientConnection newSessionBy: [ :p |
		p cwd: '/tmp'.
		p systemPrompt: aSystemPrompt ].
	done signal ] forkAt: Processor userBackgroundPriority.
	request := self agentReadMessage.
	self respondEmptyResultTo: request.
	self deny: (done waitTimeoutSeconds: 2).
	^ request
]

{ #category : 'running' }
ACP2SystemPromptTest >> setUp [

	| pair |
	super setUp.
	pair := ACP2TestTransport loopbackPair.
	connection := ACP2Connection on: pair first.
	handler := ACP2MockHandler new.
	clientConnection := ACP2ClientConnection on: connection handler: handler.
	agentTransport := pair second
]

{ #category : 'running' }
ACP2SystemPromptTest >> tearDown [

	connection ifNotNil: [ :c | c close ].
	super tearDown
]

{ #category : 'tests - capabilities' }
ACP2SystemPromptTest >> testAgentCapabilitiesWithoutSystemPrompt [

	| caps |
	caps := ACP2AgentCapabilities fromDictionary:
		        { ('session' -> Dictionary new) } asDictionary.
	self deny: caps isSystemPromptSupported.
	self deny: caps isSystemPromptOverrideSupported.
	self deny: ACP2AgentCapabilities new isSystemPromptSupported
]

{ #category : 'tests - capabilities' }
ACP2SystemPromptTest >> testAgentCapabilitiesReadsAppendOnlySystemPrompt [

	| caps |
	caps := ACP2AgentCapabilities fromDictionary: { ('session'
		         -> { ('systemPrompt' -> Dictionary new) } asDictionary) }
			         asDictionary.
	self assert: caps isSystemPromptSupported.
	self deny: caps isSystemPromptOverrideSupported.
	self assert: (caps systemPromptCapabilities isModeSupported: 'append').
	self deny: (caps systemPromptCapabilities isModeSupported: 'override')
]

{ #category : 'tests - capabilities' }
ACP2SystemPromptTest >> testAgentCapabilitiesReadsOverrideSystemPrompt [

	| caps |
	caps := ACP2AgentCapabilities fromDictionary: { ('session'
		         -> { ('systemPrompt' -> self overrideModeCapability) }
				         asDictionary) } asDictionary.
	self assert: caps isSystemPromptSupported.
	self assert: caps isSystemPromptOverrideSupported.
	self deny: (caps systemPromptCapabilities isModeSupported: 'custom')
]

{ #category : 'tests - capabilities' }
ACP2SystemPromptTest >> testAgentCapabilitiesKeepsSessionOnRoundTrip [

	| raw |
	raw := { ('session'
	         -> { ('systemPrompt' -> self overrideModeCapability) } asDictionary) }
		       asDictionary.
	self
		assert: (ACP2AgentCapabilities fromDictionary: raw copy) asDictionary
		equals: raw
]

{ #category : 'tests - capabilities' }
ACP2SystemPromptTest >> testSystemPromptCapabilitiesEnableOverride [

	| caps |
	caps := ACP2SessionSystemPromptCapabilities new.
	self deny: caps isOverrideSupported.
	caps enableOverride.
	self assert: caps isOverrideSupported.
	self assert: caps asDictionary equals: self overrideModeCapability
]

{ #category : 'tests - data types' }
ACP2SystemPromptTest >> testSystemPromptAppendText [

	| prompt |
	prompt := ACP2SystemPrompt append: 'Be concise.'.
	self assert: prompt isAppend.
	self deny: prompt isOverride.
	self assert: prompt hasOnlyTextContent.
	self assert: prompt asDictionary equals: {
			('mode' -> 'append').
			('content' -> { {
				 ('type' -> 'text').
				 ('text' -> 'Be concise.') } asDictionary }) } asDictionary
]

{ #category : 'tests - data types' }
ACP2SystemPromptTest >> testSystemPromptOverrideBuilder [

	| prompt |
	prompt := ACP2SystemPrompt buildBy: [ :p |
		          p mode: 'override'.
		          p textContent: 'First.'.
		          p textContent: 'Second.' ].
	self assert: prompt isOverride.
	self
		assert: (prompt content collect: [ :each | each at: 'text' ])
		equals: #( 'First.' 'Second.' )
]

{ #category : 'tests - data types' }
ACP2SystemPromptTest >> testSystemPromptWithNonTextContent [

	| prompt |
	prompt := ACP2SystemPrompt fromDictionary: {
			          ('mode' -> 'append').
			          ('content' -> { {
				           ('type' -> 'image').
				           ('data' -> 'AAAA').
				           ('mimeType' -> 'image/png') } asDictionary }) }
			          asDictionary.
	self deny: prompt hasOnlyTextContent
]

{ #category : 'tests - data types' }
ACP2SystemPromptTest >> testSessionParamsSerializesSystemPrompt [

	| params dict |
	params := ACP2SessionParams buildBy: [ :p |
		          p cwd: '/tmp'.
		          p systemPrompt: (ACP2SystemPrompt append: 'Be concise.') ].
	dict := params asDictionary.
	self assert: ((dict at: 'systemPrompt') at: 'mode') equals: 'append'.
	self assert: ((dict at: 'systemPrompt') at: 'content') size equals: 1
]

{ #category : 'tests - data types' }
ACP2SystemPromptTest >> testSessionParamsOmitsAbsentSystemPrompt [

	self deny: ((ACP2SessionParams buildBy: [ :p | p cwd: '/tmp' ])
			 asDictionary includesKey: 'systemPrompt')
]

{ #category : 'tests - data types' }
ACP2SystemPromptTest >> testSessionParamsDecodesSystemPrompt [

	| params |
	params := ACP2SessionParams fromDictionary: {
			          ('cwd' -> '/tmp').
			          ('systemPrompt' -> (ACP2SystemPrompt override: 'Hi') asDictionary) }
			          asDictionary.
	self assert: params systemPrompt isOverride
]

{ #category : 'tests - data types' }
ACP2SystemPromptTest >> testResumeParamsSerializesSystemPrompt [

	| params |
	params := ACP2SessionResumeParams buildBy: [ :p |
		          p sessionId: 'sess-001'.
		          p cwd: '/tmp'.
		          p systemPrompt: (ACP2SystemPrompt override: 'You are a reviewer.') ].
	self
		assert: ((params asDictionary at: 'systemPrompt') at: 'mode')
		equals: 'override'
]

{ #category : 'tests - connection' }
ACP2SystemPromptTest >> testNewSessionSendsAdvertisedAppendSystemPrompt [

	| request |
	self agentAdvertisesSystemPrompt: Dictionary new.
	request := self sendNewSessionWith: (ACP2SystemPrompt append: 'Be concise.').
	self assert: (request at: 'method') equals: 'session/new'.
	self
		assert: ((request at: 'params') at: 'systemPrompt')
		equals: (ACP2SystemPrompt append: 'Be concise.') asDictionary
]

{ #category : 'tests - connection' }
ACP2SystemPromptTest >> testNewSessionSendsAdvertisedOverrideSystemPrompt [

	| request |
	self agentAdvertisesSystemPrompt: self overrideModeCapability.
	request := self sendNewSessionWith: (ACP2SystemPrompt override: 'Only Smalltalk.').
	self
		assert: (((request at: 'params') at: 'systemPrompt') at: 'mode')
		equals: 'override'
]

{ #category : 'tests - connection' }
ACP2SystemPromptTest >> testNewSessionRejectsSystemPromptWithoutCapability [

	self
		should: [
			clientConnection newSessionBy: [ :p |
				p cwd: '/tmp'.
				p systemPrompt: (ACP2SystemPrompt append: 'Be concise.') ] ]
		raise: ACP2RequestError
]

{ #category : 'tests - connection' }
ACP2SystemPromptTest >> testNewSessionRejectsUnadvertisedOverrideMode [

	self agentAdvertisesSystemPrompt: Dictionary new.
	self
		should: [
			clientConnection newSessionBy: [ :p |
				p cwd: '/tmp'.
				p systemPrompt: (ACP2SystemPrompt override: 'Only Smalltalk.') ] ]
		raise: ACP2RequestError
]

{ #category : 'tests - connection' }
ACP2SystemPromptTest >> testNewSessionRejectsEmptySystemPromptContent [

	self agentAdvertisesSystemPrompt: Dictionary new.
	self
		should: [
			clientConnection newSessionBy: [ :p |
				p cwd: '/tmp'.
				p systemPrompt: (ACP2SystemPrompt buildBy: [ :sp | sp mode: 'append' ]) ] ]
		raise: ACP2RequestError
]

{ #category : 'tests - connection' }
ACP2SystemPromptTest >> testNewSessionRejectsNonTextSystemPromptContent [

	self agentAdvertisesSystemPrompt: Dictionary new.
	self
		should: [
			clientConnection newSession: {
					('cwd' -> '/tmp').
					('systemPrompt' -> {
						 ('mode' -> 'append').
						 ('content' -> { {
							  ('type' -> 'image').
							  ('data' -> 'AAAA').
							  ('mimeType' -> 'image/png') } asDictionary }) } asDictionary) }
					asDictionary ]
		raise: ACP2RequestError
]

{ #category : 'tests - connection' }
ACP2SystemPromptTest >> testResumeSessionRejectsSystemPromptWithoutCapability [

	self
		should: [
			clientConnection resumeSessionBy: [ :p |
				p sessionId: 'sess-001'.
				p cwd: '/tmp'.
				p systemPrompt: (ACP2SystemPrompt append: 'Be concise.') ] ]
		raise: ACP2RequestError
]

{ #category : 'tests - connection' }
ACP2SystemPromptTest >> testResumeSessionSendsAdvertisedSystemPrompt [

	| request done |
	self agentAdvertisesSystemPrompt: Dictionary new.
	done := Semaphore new.
	connection startReadLoop.
	[
	clientConnection resumeSessionBy: [ :p |
		p sessionId: 'sess-001'.
		p cwd: '/tmp'.
		p systemPrompt: (ACP2SystemPrompt append: 'Be concise.') ].
	done signal ] forkAt: Processor userBackgroundPriority.
	request := self agentReadMessage.
	self respondEmptyResultTo: request.
	self deny: (done waitTimeoutSeconds: 2).
	self assert: (request at: 'method') equals: 'session/resume'.
	self
		assert: (((request at: 'params') at: 'systemPrompt') at: 'mode')
		equals: 'append'
]

{ #category : 'tests - connection' }
ACP2SystemPromptTest >> testNewSessionWithoutSystemPromptNeedsNoCapability [

	| request done |
	done := Semaphore new.
	connection startReadLoop.
	[
	clientConnection newSessionBy: [ :p | p cwd: '/tmp' ].
	done signal ] forkAt: Processor userBackgroundPriority.
	request := self agentReadMessage.
	self respondEmptyResultTo: request.
	self deny: (done waitTimeoutSeconds: 2).
	self deny: ((request at: 'params') includesKey: 'systemPrompt')
]
