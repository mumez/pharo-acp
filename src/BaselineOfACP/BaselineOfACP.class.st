Class {
	#name : 'BaselineOfACP',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfACP',
	#package : 'BaselineOfACP'
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
			package: 'ACP-DataTypes';
			package: 'ACP-Protocol' with: [ spec requires: #('JRPC' 'ACP-DataTypes') ];
			package: 'ACP-Transport' with: [ spec requires: #('OSSubprocess') ];
			package: 'ACP-Connection' with: [ spec requires: #('ACP-Transport' 'JRPC') ];
			package: 'ACP-Client' with: [ spec requires: #('ACP-Connection' 'ACP-Protocol' 'ACP-DataTypes') ];
			package: 'ACP-Tests' with: [ spec requires: #('ACP-Client') ].

		"Packages (v2, draft)"
		spec
			package: 'ACP2-DataTypes';
			package: 'ACP2-Protocol' with: [ spec requires: #('JRPC' 'ACP2-DataTypes') ];
			package: 'ACP2-Transport' with: [ spec requires: #('OSSubprocess') ];
			package: 'ACP2-Connection' with: [ spec requires: #('ACP2-Transport' 'JRPC') ];
			package: 'ACP2-Client' with: [ spec requires: #('ACP2-Connection' 'ACP2-Protocol' 'ACP2-DataTypes') ];
			package: 'ACP2-Tests' with: [ spec requires: #('ACP2-Client') ].

		"Groups"
		spec
			group: 'Core' with: #('ACP-Protocol' 'ACP-DataTypes' 'ACP-Transport' 'ACP-Connection' 'ACP-Client');
			group: 'Tests' with: #('ACP-Tests');
			group: 'Core2' with: #('ACP2-Protocol' 'ACP2-DataTypes' 'ACP2-Transport' 'ACP2-Connection' 'ACP2-Client');
			group: 'Tests2' with: #('ACP2-Tests');
			group: 'all' with: #('Core' 'Tests');
			group: 'all2' with: #('Core2' 'Tests2');
			group: 'default' with: #('Core') ]
]
