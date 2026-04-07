# AGENTS.md

## Cursor Cloud specific instructions

### Project overview

pharo-acp is an ACP (Agent Client Protocol) client library for Pharo Smalltalk. It is a pure Smalltalk library with no web servers, databases, or Docker services. See `README.md` for architecture and usage.

### Running tests

**Unit tests (122 tests, all in-memory mocks — no external dependencies):**
```bash
smalltalkci -s Pharo64-13 .smalltalk.ston
```
- Pharo64-12 may segfault in this VM environment; prefer **Pharo64-13**.
- smalltalkCI downloads and caches the Pharo image/VM on first run, then loads the baseline and executes all tests.
- Tests are defined in `src/ACP-Tests/`. The `.smalltalk.ston` config loads the `Tests` group.

**Smoke test (requires Node.js + TypeScript SDK):**
```bash
# One-time setup
git clone --depth 1 https://github.com/agentclientprotocol/typescript-sdk.git ~/typescript-sdk
cd ~/typescript-sdk && npm install

# Run via Pharo eval against a smalltalkCI-built image
PHARO_VM="/opt/smalltalkCI/_cache/vms/Pharo64-13/pharo"
PHARO_BUILD=$(ls -td /opt/smalltalkCI/_builds/*/ | head -1)
$PHARO_VM --headless ${PHARO_BUILD}TravisCI.image eval "
ACPSmokeTest agentPath: '$HOME/typescript-sdk/src/examples/agent.ts'.
ACPSmokeTest suite run printString
"
```

### Gotchas

- The Pharo `eval` command-line handler does not support local variable declarations (`| x |`). Use expression chaining or message sends instead.
- A `DeprecationPerformedNotification` about `Semaphore>>#waitTimeoutMSecs:` is normal and not a test failure.
- smalltalkCI requires write access to `/opt/smalltalkCI/_cache` and `/opt/smalltalkCI/_builds`. The update script ensures correct ownership.
- There is no lint or build step — this is a Smalltalk library loaded directly from source via Metacello baselines.
