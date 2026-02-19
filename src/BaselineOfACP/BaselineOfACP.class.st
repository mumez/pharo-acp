Class {
	#name : 'BaselineOfACP',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfACP'
}

{ #category : 'baselines' }
BaselineOfACP >> baseline: spec [
	<baseline>

	spec for: #common do: [
		"External dependencies"
		spec
			baseline: 'JRPC'
			with: [ spec repository: 'github://juliendelplanque/JRPC:master/src' ].
		spec
			baseline: 'OSSubprocess'
			with: [ spec
				repository: 'github://pharo-contributions/OSSubprocess:master/repository' ].

		"Packages"
		spec
			package: 'ACP-Protocol' with: [ spec requires: #('JRPC') ];
			package: 'ACP-DataTypes';
			package: 'ACP-Transport' with: [ spec requires: #('OSSubprocess') ];
			package: 'ACP-Connection' with: [ spec requires: #('ACP-Transport' 'JRPC') ];
			package: 'ACP-Client' with: [ spec requires: #('ACP-Connection' 'ACP-Protocol' 'ACP-DataTypes') ];
			package: 'ACP-Tests' with: [ spec requires: #('ACP-Client') ].

		"Groups"
		spec
			group: 'Core' with: #('ACP-Protocol' 'ACP-DataTypes' 'ACP-Transport' 'ACP-Connection' 'ACP-Client');
			group: 'Tests' with: #('ACP-Tests');
			group: 'all' with: #('Core' 'Tests');
			group: 'default' with: #('Core') ]
]
