# pharo-acp

ACP (Agent Client Protocol) client library for Pharo Smalltalk.

Enables Pharo to communicate with ACP-compatible coding agents ([Gemini CLI](https://github.com/google-gemini/gemini-cli), [OpenCode](https://opencode.ai/), etc.) over JSON-RPC 2.0 via stdio.

References the [ACP TypeScript SDK](https://github.com/agentclientprotocol/typescript-sdk).

## Requirements

- Pharo 12+ (For Windows, use WSL since OSSubprocess does not support Windows)

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

You need an ACP-compatible agent installed. Currently tested with:

- [Gemini CLI](https://github.com/google-gemini/gemini-cli) — `gemini --acp`
- [claude-agent-acp](https://github.com/agentclientprotocol/claude-agent-acp) — `claude-agent-acp`
- [OpenCode](https://github.com/anomalyco/opencode) — `opencode acp`
- [Copilot CLI](https://docs.github.com/en/copilot/reference/copilot-cli-reference/acp-server) — `copilot --acp --stdio`
- [codex-acp](https://github.com/zed-industries/codex-acp) — `codex-acp`
- [Cursor CLI](https://cursor.com/cli) - `agent acp`

> **Note:** Before connecting from Pharo, configure each agent CLI directly: log in, set your API key, default model, and any required environment variables (e.g. `GEMINI_API_KEY`, `GEMINI_MODEL` for Gemini CLI).

```smalltalk
client := ACPClient new.

"Use Gemini CLI:"
client agentCommand: '/usr/bin/env' arguments: #('gemini' '--acp').
"Or claude-agent-acp:"
"client agentCommand: '/usr/bin/env' arguments: #('claude-agent-acp')."

client connect.

[
    "Initialize"
    client initializeBy: [ :params | "uses default protocolVersion and capabilities" ].

    "Create session"
    session := client newSessionBy: [ :params |
        params cwd: FileSystem workingDirectory fullName ].

    "Send prompt (blocks until agent responds)"
    result := client promptBy: [ :params |
        params sessionId: session sessionId.
        params textPrompt: 'Hello!' ].

    Transcript show: 'Stop reason: ', result stopReason; cr.
] ensure: [ client disconnect ].
```

<details>
<summary>Example Transcript output (Gemini CLI)</summary>

```
Session update [agent_thought_chunk]: ACPSessionUpdate(a Dictionary('sessionId'->'42f04b38-b27d-4adf-b1e5-f46f1d69216e' 'update'->a Dictionary('content'->a Dictionary('text'->'**Awaiting Initial Input**

I''ve processed the initial setup details: directory structure and environment specs, which point to a Pharo Smalltalk environment. Currently, I''m simply standing by, waiting for the user''s first directive or request before moving forward.


' 'type'->'text' ) 'sessionUpdate'->'agent_thought_chunk' ) ))
Session update [agent_message_chunk]: ACPSessionUpdate(a Dictionary('sessionId'->'42f04b38-b27d-4adf-b1e5-f46f1d69216e' 'update'->a Dictionary('content'->a Dictionary('text'->'Hello! How can I help you today?' 'type'->'text' ) 'sessionUpdate'->'agent_message_chunk' ) ))
Stop reason: end_turn

```

</details>

## Example: Chat UI

[pharo-acp-chat-ui](https://github.com/mumez/pharo-acp-chat-ui) is a minimal chat interface built on top of this library.

```smalltalk
"Launch with Gemini CLI:"
ACPChatPresenter gemini open.

"Or with Claude Code:"
ACPChatPresenter claude open.
```

## Custmizing update handler

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
