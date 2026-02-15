# pharo-acp

ACP (Agent Client Protocol) client library for Pharo Smalltalk.

Enables Pharo to communicate with ACP-compatible coding agents (Gemini CLI, Open Code, etc.) over JSON-RPC 2.0 via stdio.

References the [ACP TypeScript SDK](https://github.com/agentclientprotocol/typescript-sdk).

## Requirements

- Pharo 12+ (Unix/macOS — OSSubprocess does not support Windows)

## Installation

```smalltalk
Metacello new
    baseline: 'ACP';
    repository: 'github://mumez/pharo-acp:main/src';
    load.
```

To include tests:

```smalltalk
Metacello new
    baseline: 'ACP';
    repository: 'github://mumez/pharo-acp:main/src';
    load: 'Tests'.
```

## Quick Start

```smalltalk
client := ACPClient new.
client agentCommand: '/usr/bin/env' arguments: #('gemini' '--mode' 'acp').
client connect.

[
    "Initialize"
    client initializeWithCapabilities: Dictionary new.

    "Create session"
    session := client clientConnection newSession: {
        'cwd' -> FileSystem workingDirectory fullName.
        'mcpServers' -> #() } asDictionary.

    "Send prompt (blocks until agent responds)"
    result := client prompt: {
        'sessionId' -> (session at: 'sessionId').
        'prompt' -> {
            { 'type' -> 'text'. 'text' -> 'Hello!' } asDictionary
        } } asDictionary.

    Transcript show: 'Stop reason: ', (result at: 'stopReason'); cr.
] ensure: [ client disconnect ].
```

By default, `ACPClient` uses `ACPTranscriptHandler` which logs session updates to the Transcript and auto-approves permission requests. Provide a custom handler by subclassing `ACPClientHandler`:

```smalltalk
client := ACPClient new.
client handler: MyCustomHandler new.
```

## Smoke Test

Run the smoke test against the TypeScript SDK example agent.

### Prerequisites

- Node.js and npm installed
- Clone the [TypeScript SDK](https://github.com/agentclientprotocol/typescript-sdk):
  ```bash
  git clone https://github.com/agentclientprotocol/typescript-sdk.git
  cd typescript-sdk
  npm install
  ```
- Verify the example agent works:
  ```bash
  npx tsx src/examples/agent.ts
  ```
  Paste `{"jsonrpc":"2.0","id":0,"method":"initialize","params":{"protocolVersion":1}}` and press Enter — you should get a response.

### Run from Pharo

```smalltalk
"Set the path to the TypeScript example agent (once per image)"
ACPSmokeTest agentPath: '/path/to/typescript-sdk/src/examples/agent.ts'.

"Run the test"
ACPSmokeTest suite run.
```

## Architecture

Five-layer stack, each layer depending only on layers below:

```
ACPClient                    — User-facing facade (connect/prompt/cancel)
ACPClientConnection          — ACP protocol methods + handler registration
ACPConnection                — Bidirectional JSON-RPC engine (readLoop + pending requests)
ACPNdJsonTransport           — ndjson line framing + mutex-protected writes
ACPProcessLauncher           — OSSUnixSubprocess wrapper (non-blocking pipes)
```

## License

MIT
