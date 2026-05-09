# AGENTS.md

## Cursor Cloud instructions for this repository

This is a pure **Pharo Smalltalk** project. Build, load, and test workflows run through
`smalltalkCI` with `.smalltalk.ston`.

There is no npm/pip/Makefile/Docker workflow for normal development tasks.

## Running tests

### Preferred (preinstalled smalltalkCI)

If the environment already has smalltalkCI at `/opt/smalltalkCI`:

```bash
export PATH="/opt/smalltalkCI/bin:$PATH"
cd /workspace && smalltalkci -s Pharo64-12 .smalltalk.ston
```

### Fallback (when `/opt/smalltalkCI` is missing)

```bash
[ -d /tmp/smalltalkCI ] || git clone https://github.com/hpi-swa/smalltalkCI.git /tmp/smalltalkCI
/tmp/smalltalkCI/bin/smalltalkci -s Pharo64-12 /workspace/.smalltalk.ston
```

## CI matrix and local expectations

- GitHub Actions runs Pharo 12 and Pharo 13.
- Both Pharo 12 and Pharo 13 are expected to pass in CI.
- For local/cloud-agent verification, run Pharo 12 first as a quick baseline, then run Pharo 13
  when your change may affect runtime/process behavior.
- If a local/cloud-agent-only VM crash appears on Pharo 13 but CI is green, treat it as an
  environment-specific flake and include logs in your report.

## Useful notes for contributors/agents

- Keep data type classes aligned with ACP TypeScript schema definitions:
  `https://github.com/agentclientprotocol/typescript-sdk/blob/main/src/schema/types.gen.ts`
- Prefer updating/adding SUnit tests in `src/ACP-Tests`.
- When `smalltalkCI` fails, inspect generated artifacts like `crash.dmp` and test XML in repo root,
  then clean them before committing.
