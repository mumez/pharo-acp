Class {
	#name : 'ACPElicitationTest',
	#superclass : 'TestCase',
	#category : 'ACP-Tests',
	#package : 'ACP-Tests'
}

{ #category : 'fixtures' }
ACPElicitationTest >> formRequestDictionary [

	^ {
		  ('sessionId' -> 'sess-001').
		  ('toolCallId' -> 'call-001').
		  ('mode' -> 'form').
		  ('message' -> 'Configure the project').
		  ('requestedSchema' -> {
			   ('type' -> 'object').
			   ('title' -> 'Project').
			   ('description' -> 'Project settings').
			   ('required' -> #( 'name' 'license' )).
			   ('properties' -> {
				    ('name' -> {
					     ('type' -> 'string').
					     ('title' -> 'Name').
					     ('minLength' -> 1).
					     ('maxLength' -> 40).
					     ('pattern' -> '^[a-z-]+$') } asDictionary).
				    ('email' -> {
					     ('type' -> 'string').
					     ('format' -> 'email') } asDictionary).
				    ('ratio' -> {
					     ('type' -> 'number').
					     ('minimum' -> 0).
					     ('maximum' -> 1) } asDictionary).
				    ('retries' -> {
					     ('type' -> 'integer').
					     ('default' -> 3) } asDictionary).
				    ('private' -> {
					     ('type' -> 'boolean').
					     ('default' -> false) } asDictionary).
				    ('license' -> {
					     ('type' -> 'string').
					     ('enum' -> #( 'MIT' 'Apache-2.0' )) } asDictionary).
				    ('visibility' -> {
					     ('type' -> 'string').
					     ('oneOf' -> {
						      {
							      ('const' -> 'pub').
							      ('title' -> 'Public').
							      ('description' -> 'Anyone can see it') } asDictionary.
						      {
							      ('const' -> 'priv').
							      ('title' -> 'Private') } asDictionary }) } asDictionary).
				    ('tags' -> {
					     ('type' -> 'array').
					     ('minItems' -> 1).
					     ('maxItems' -> 2).
					     ('items' -> {
						      ('type' -> 'string').
						      ('enum' -> #( 'web' 'cli' 'lib' )) } asDictionary) } asDictionary).
				    ('targets' -> {
					     ('type' -> 'array').
					     ('items' -> { ('anyOf' -> {
							       {
								       ('const' -> 'linux').
								       ('title' -> 'Linux') } asDictionary }) } asDictionary) }
					     asDictionary) } asDictionary) } asDictionary) } asDictionary
]

{ #category : 'tests - capabilities' }
ACPElicitationTest >> testClientCapabilitiesElicitationFromDictionary [

	| caps |
	caps := ACPClientCapabilities fromDictionary:
		        { ('elicitation' -> { ('form' -> Dictionary new) } asDictionary) }
			        asDictionary.
	self assert: caps elicitation class equals: ACPElicitationCapabilities.
	self assert: caps elicitation isFormSupported.
	self deny: caps elicitation isUrlSupported.
	self deny: (ACPClientCapabilities fromDictionary:
			 { ('elicitation' -> nil) } asDictionary) elicitation isFormSupported
]

{ #category : 'tests - capabilities' }
ACPElicitationTest >> testClientCapabilitiesElicitationOmittedByDefault [

	| caps |
	caps := ACPClientCapabilities new.
	caps elicitation.
	self deny: (caps asDictionary includesKey: 'elicitation')
]

{ #category : 'tests - capabilities' }
ACPElicitationTest >> testClientCapabilitiesEnableForm [

	| params elicitation |
	params := ACPInitializeParams buildBy: [ :p | p capabilities elicitation enableForm ].
	elicitation := (params asDictionary at: 'clientCapabilities') at: 'elicitation'.
	self assert: (elicitation at: 'form') equals: Dictionary new.
	self deny: (elicitation includesKey: 'url')
]

{ #category : 'tests - capabilities' }
ACPElicitationTest >> testClientCapabilitiesEnableUrl [

	| caps |
	caps := ACPClientCapabilities new.
	caps elicitation enableUrl.
	self assert: caps elicitation isUrlSupported.
	self deny: caps elicitation isFormSupported.
	self assert: ((caps asDictionary at: 'elicitation') at: 'url') equals: Dictionary new
]

{ #category : 'tests - notification' }
ACPElicitationTest >> testCompleteElicitation [

	| notification |
	notification := ACPCompleteElicitation fromDictionary:
		                { ('elicitationId' -> 'elic-001') } asDictionary.
	self assert: notification elicitationId equals: 'elic-001'
]

{ #category : 'tests - request' }
ACPElicitationTest >> testFormRequest [

	| request |
	request := ACPCreateElicitation fromDictionary: self formRequestDictionary.
	self assert: request isForm.
	self deny: request isUrl.
	self assert: request message equals: 'Configure the project'.
	self assert: request isSessionScoped.
	self deny: request isRequestScoped.
	self assert: request sessionId equals: 'sess-001'.
	self assert: request toolCallId equals: 'call-001'.
	self assert: request elicitationId isNil.
	self assert: request url isNil
]

{ #category : 'tests - response' }
ACPElicitationTest >> testMakeResponse [

	| request |
	request := ACPCreateElicitation fromDictionary: self formRequestDictionary.
	self assert: request makeResponse class equals: ACPCreateElicitationResponse
]

{ #category : 'tests - schema' }
ACPElicitationTest >> testMultiSelectProperties [

	| schema tags targets |
	schema := (ACPCreateElicitation fromDictionary: self formRequestDictionary)
		          requestedSchema.
	tags := schema propertyNamed: 'tags'.
	self assert: tags isMultiSelect.
	self deny: tags isSingleSelect.
	self assert: tags minItems equals: 1.
	self assert: tags maxItems equals: 2.
	self
		assert: (tags choices collect: [ :each | each value ]) asArray
		equals: #( 'web' 'cli' 'lib' ).
	targets := schema propertyNamed: 'targets'.
	self assert: targets choices size equals: 1.
	self assert: targets choices first value equals: 'linux'.
	self assert: targets choices first title equals: 'Linux'
]

{ #category : 'tests - schema' }
ACPElicitationTest >> testScalarProperties [

	| schema name ratio retries private |
	schema := (ACPCreateElicitation fromDictionary: self formRequestDictionary)
		          requestedSchema.
	name := schema propertyNamed: 'name'.
	self assert: name isString.
	self deny: name isSingleSelect.
	self assert: name title equals: 'Name'.
	self assert: name minLength equals: 1.
	self assert: name maxLength equals: 40.
	self assert: name pattern equals: '^[a-z-]+$'.
	self assert: name choices isEmpty.
	self assert: (schema propertyNamed: 'email') format equals: 'email'.
	ratio := schema propertyNamed: 'ratio'.
	self assert: ratio isNumber.
	self assert: ratio minimum equals: 0.
	self assert: ratio maximum equals: 1.
	retries := schema propertyNamed: 'retries'.
	self assert: retries isInteger.
	self assert: retries default equals: 3.
	private := schema propertyNamed: 'private'.
	self assert: private isBoolean.
	self assert: private default equals: false
]

{ #category : 'tests - schema' }
ACPElicitationTest >> testSchema [

	| schema |
	schema := (ACPCreateElicitation fromDictionary: self formRequestDictionary)
		          requestedSchema.
	self assert: schema class equals: ACPElicitationSchema.
	self assert: schema title equals: 'Project'.
	self assert: schema description equals: 'Project settings'.
	self assert: schema properties size equals: 9.
	self assert: (schema properties at: 'name') class equals: ACPElicitationProperty.
	self assert: (schema isRequired: 'name').
	self deny: (schema isRequired: 'email').
	self assert: (schema propertyNamed: 'missing') isNil
]

{ #category : 'tests - schema' }
ACPElicitationTest >> testSchemaWithoutOptionalFields [

	| schema |
	schema := ACPElicitationSchema fromDictionary: { ('type' -> 'object') } asDictionary.
	self assert: schema properties isEmpty.
	self assert: schema required isEmpty.
	self assert: (ACPElicitationSchema fromDictionary: { ('required' -> nil) } asDictionary)
			required isEmpty
]

{ #category : 'tests - schema' }
ACPElicitationTest >> testSingleSelectProperties [

	| schema license visibility |
	schema := (ACPCreateElicitation fromDictionary: self formRequestDictionary)
		          requestedSchema.
	license := schema propertyNamed: 'license'.
	self assert: license isSingleSelect.
	self
		assert: (license choices collect: [ :each | each value ]) asArray
		equals: #( 'MIT' 'Apache-2.0' ).
	self assert: license choices first title equals: 'MIT'.
	self assert: license choices first description isNil.
	visibility := schema propertyNamed: 'visibility'.
	self assert: visibility isSingleSelect.
	self assert: visibility choices first value equals: 'pub'.
	self assert: visibility choices first title equals: 'Public'.
	self assert: visibility choices first description equals: 'Anyone can see it'.
	self assert: visibility choices second title equals: 'Private'
]

{ #category : 'tests - response' }
ACPElicitationTest >> testResponseAccept [

	| response dict |
	response := ACPCreateElicitationResponse accepted: {
			            ('name' -> 'pharo-acp').
			            ('tags' -> #( 'lib' )) } asDictionary.
	self assert: response isAccepted.
	dict := response asDictionary.
	self assert: (dict at: 'action') equals: 'accept'.
	self assert: ((dict at: 'content') at: 'name') equals: 'pharo-acp'.
	self assert: ((dict at: 'content') at: 'tags') equals: #( 'lib' )
]

{ #category : 'tests - response' }
ACPElicitationTest >> testResponseAcceptWithoutContent [

	| response |
	response := ACPCreateElicitationResponse new.
	response accept.
	self assert: response isAccepted.
	self deny: (response asDictionary includesKey: 'content')
]

{ #category : 'tests - response' }
ACPElicitationTest >> testResponseDeclineAndCancel [

	| declined cancelled |
	declined := ACPCreateElicitationResponse declined.
	self assert: declined isDeclined.
	self assert: declined asDictionary equals: { ('action' -> 'decline') } asDictionary.
	cancelled := ACPCreateElicitationResponse cancelled.
	self assert: cancelled isCancelled.
	self assert: cancelled asDictionary equals: { ('action' -> 'cancel') } asDictionary
]

{ #category : 'tests - response' }
ACPElicitationTest >> testResponseDeclineDropsEarlierContent [

	| response |
	response := ACPCreateElicitationResponse accepted: { ('name' -> 'x') } asDictionary.
	response decline.
	self assert: response asDictionary equals: { ('action' -> 'decline') } asDictionary
]

{ #category : 'tests - request' }
ACPElicitationTest >> testUrlRequest [

	| request |
	request := ACPCreateElicitation fromDictionary: {
			           ('requestId' -> 12).
			           ('mode' -> 'url').
			           ('message' -> 'Sign in to continue').
			           ('elicitationId' -> 'elic-001').
			           ('url' -> 'https://auth.example.com/login?state=abc') } asDictionary.
	self assert: request isUrl.
	self deny: request isForm.
	self assert: request isRequestScoped.
	self deny: request isSessionScoped.
	self assert: request requestId equals: 12.
	self assert: request elicitationId equals: 'elic-001'.
	self assert: request url equals: 'https://auth.example.com/login?state=abc'.
	self assert: request urlHost equals: 'auth.example.com'.
	self assert: request requestedSchema isNil
]

{ #category : 'tests - request' }
ACPElicitationTest >> testUnknownModeIsNeitherFormNorUrl [

	| request |
	request := ACPCreateElicitation fromDictionary: {
			           ('sessionId' -> 'sess-001').
			           ('mode' -> '_custom').
			           ('message' -> 'Custom') } asDictionary.
	self deny: request isForm.
	self deny: request isUrl.
	self assert: request mode equals: '_custom'.
	self assert: request urlHost isNil
]
