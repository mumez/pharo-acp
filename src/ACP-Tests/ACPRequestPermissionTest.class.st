Class {
	#name : 'ACPRequestPermissionTest',
	#superclass : 'TestCase',
	#category : 'ACP-Tests',
	#package : 'ACP-Tests'
}

{ #category : 'tests' }
ACPRequestPermissionTest >> testSessionId [

	| req |
	req := ACPRequestPermission fromDictionary: {
		       ('sessionId' -> 'sess-abc123').
		       ('toolCall' -> { ('toolCallId' -> 'call_001') } asDictionary).
		       ('options' -> #()) } asDictionary.
	self assert: req sessionId equals: 'sess-abc123'
]

{ #category : 'tests' }
ACPRequestPermissionTest >> testOptions [

	| req opts |
	req := ACPRequestPermission fromDictionary: {
		       ('sessionId' -> 'sess-abc123').
		       ('toolCall' -> { ('toolCallId' -> 'call_001') } asDictionary).
		       ('options' -> {
			        { ('optionId' -> 'allow-once'). ('name' -> 'Allow once'). ('kind' -> 'allow_once') } asDictionary.
			        { ('optionId' -> 'reject-once'). ('name' -> 'Reject'). ('kind' -> 'reject_once') } asDictionary }) }
		       asDictionary.
	opts := req options.
	self assert: opts size equals: 2.
	self assert: opts first class equals: ACPPermissionOption.
	self assert: opts first optionId equals: 'allow-once'.
	self assert: opts first name equals: 'Allow once'.
	self assert: opts first kind equals: 'allow_once'
]

{ #category : 'tests' }
ACPRequestPermissionTest >> testToolCall [

	| req toolCall |
	req := ACPRequestPermission fromDictionary: {
		       ('sessionId' -> 'sess-abc123').
		       ('toolCall' -> { ('toolCallId' -> 'call_001') } asDictionary).
		       ('options' -> #()) } asDictionary.
	toolCall := req toolCall.
	self assert: toolCall class equals: ACPToolCall.
	self assert: toolCall toolCallId equals: 'call_001'
]

{ #category : 'tests' }
ACPRequestPermissionTest >> testResponseSelected [

	| resp dict |
	resp := ACPRequestPermissionResponse selected: 'allow-once'.
	self assert: resp isSelected.
	self deny: resp isCancelled.
	self assert: resp outcome equals: 'selected'.
	self assert: resp optionId equals: 'allow-once'.
	dict := resp asDictionary.
	self assert: (dict at: 'outcome') equals: { ('outcome' -> 'selected'). ('optionId' -> 'allow-once') } asDictionary
]

{ #category : 'tests' }
ACPRequestPermissionTest >> testResponseCancelled [

	| resp dict |
	resp := ACPRequestPermissionResponse cancelled.
	self assert: resp isCancelled.
	self deny: resp isSelected.
	self assert: resp outcome equals: 'cancelled'.
	self assert: resp optionId isNil.
	dict := resp asDictionary.
	self assert: (dict at: 'outcome') equals: { ('outcome' -> 'cancelled') } asDictionary
]

{ #category : 'tests' }
ACPRequestPermissionTest >> testAllowOnce [

	| resp |
	resp := ACPRequestPermissionResponse new.
	resp allowOnce.
	self assert: resp isSelected.
	self assert: resp optionId equals: 'allow_once'
]

{ #category : 'tests' }
ACPRequestPermissionTest >> testRejectOnce [

	| resp |
	resp := ACPRequestPermissionResponse new.
	resp rejectOnce.
	self assert: resp isSelected.
	self assert: resp optionId equals: 'reject_once'
]

{ #category : 'tests' }
ACPRequestPermissionTest >> testCancel [

	| resp |
	resp := ACPRequestPermissionResponse new.
	resp cancel.
	self assert: resp isCancelled.
	self assert: resp optionId isNil
]
