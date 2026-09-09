Class {
	#name : 'ACP2RequestPermissionTest',
	#superclass : 'TestCase',
	#category : 'ACP2-Tests',
	#package : 'ACP2-Tests'
}

{ #category : 'tests' }
ACP2RequestPermissionTest >> testSessionId [

	| req |
	req := ACP2RequestPermission fromDictionary: {
		       ('sessionId' -> 'sess-abc123').
		       ('toolCall' -> { ('toolCallId' -> 'call_001') } asDictionary).
		       ('options' -> #()) } asDictionary.
	self assert: req sessionId equals: 'sess-abc123'
]

{ #category : 'tests' }
ACP2RequestPermissionTest >> testOptions [

	| req opts |
	req := ACP2RequestPermission fromDictionary: {
		       ('sessionId' -> 'sess-abc123').
		       ('toolCall' -> { ('toolCallId' -> 'call_001') } asDictionary).
		       ('options' -> {
			        { ('optionId' -> 'allow-once'). ('name' -> 'Allow once'). ('kind' -> 'allow_once') } asDictionary.
			        { ('optionId' -> 'reject-once'). ('name' -> 'Reject'). ('kind' -> 'reject_once') } asDictionary }) }
		       asDictionary.
	opts := req options.
	self assert: opts size equals: 2.
	self assert: opts first class equals: ACP2PermissionOption.
	self assert: opts first optionId equals: 'allow-once'.
	self assert: opts first name equals: 'Allow once'.
	self assert: opts first kind equals: 'allow_once'
]

{ #category : 'tests' }
ACP2RequestPermissionTest >> testToolCall [

	| req toolCall |
	req := ACP2RequestPermission fromDictionary: {
		       ('sessionId' -> 'sess-abc123').
		       ('toolCall' -> { ('toolCallId' -> 'call_001') } asDictionary).
		       ('options' -> #()) } asDictionary.
	toolCall := req toolCall.
	self assert: toolCall class equals: ACP2ToolCall.
	self assert: toolCall toolCallId equals: 'call_001'
]

{ #category : 'tests' }
ACP2RequestPermissionTest >> testResponseSelected [

	| resp dict |
	resp := ACP2RequestPermissionResponse selected: 'allow-once'.
	self assert: resp isSelected.
	self deny: resp isCancelled.
	self assert: resp outcome equals: 'selected'.
	self assert: resp optionId equals: 'allow-once'.
	dict := resp asDictionary.
	self assert: (dict at: 'outcome') equals: { ('outcome' -> 'selected'). ('optionId' -> 'allow-once') } asDictionary
]

{ #category : 'tests' }
ACP2RequestPermissionTest >> testResponseCancelled [

	| resp dict |
	resp := ACP2RequestPermissionResponse cancelled.
	self assert: resp isCancelled.
	self deny: resp isSelected.
	self assert: resp outcome equals: 'cancelled'.
	self assert: resp optionId isNil.
	dict := resp asDictionary.
	self assert: (dict at: 'outcome') equals: { ('outcome' -> 'cancelled') } asDictionary
]

{ #category : 'tests' }
ACP2RequestPermissionTest >> testAllowOnce [

	| resp |
	resp := ACP2RequestPermissionResponse new.
	resp allowOnce.
	self assert: resp isSelected.
	self assert: resp optionId equals: 'allow_once'
]

{ #category : 'tests' }
ACP2RequestPermissionTest >> testRejectOnce [

	| resp |
	resp := ACP2RequestPermissionResponse new.
	resp rejectOnce.
	self assert: resp isSelected.
	self assert: resp optionId equals: 'reject_once'
]

{ #category : 'tests' }
ACP2RequestPermissionTest >> testCancel [

	| resp |
	resp := ACP2RequestPermissionResponse new.
	resp cancel.
	self assert: resp isCancelled.
	self assert: resp optionId isNil
]
