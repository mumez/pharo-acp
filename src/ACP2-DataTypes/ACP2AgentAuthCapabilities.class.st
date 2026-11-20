"
I represent the authentication-related extension capabilities of an ACP v2 agent (capabilities.auth).

Responsibility:
- I keep the raw 'auth' object. ACP v2 defines no fields in it yet, so I only preserve unknown keys.
- I do NOT advertise auth/login or auth/logout: those are advertised by a non-empty authMethods
  list in the initialize response (see ACP2InitializeResponse >> isLoginSupported).

Collaborators:
- ACP2AgentCapabilities: holds me under 'auth'
- ACP2Values: my superclass
"
Class {
	#name : 'ACP2AgentAuthCapabilities',
	#superclass : 'ACP2Values',
	#category : 'ACP2-DataTypes',
	#package : 'ACP2-DataTypes'
}
