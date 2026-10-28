# Feature: ACPNdJsonTransport final drain on agent exit

Kanban issue: `1793093839318-acpndjsontransport-エージェント終了直前に書かれた出力を取りこぼす可能性への対応`

## Goal

`ACPNdJsonTransport>>readLine` no longer loses output the agent wrote right before exiting: once `isAtEnd` is true (the process exited), the transport drains the pipe one last time and still delivers any remaining lines. Covered by a deterministic unit test and a subprocess integration test, all `ACP-Tests` green, lint clean.

## Orchestration Shape

sequential, one topic per `seq:`: implement (TDD) → test → lint & review, all via claude

## Working Directory

`/home/mumez/git/pharo-acp` (branch `feature/ndjson-final-drain-on-exit`, based on `develop`)

## Script

```Smalltalk
| script |
script := AgenticBrowser scriptBy: [ :builder |
	builder sharedDirectoryPath: '/home/mumez/git/pharo-acp'.
	builder seq: {
		builder topicBy: [ :t |
			t title: 'Implement final drain in ACPNdJsonTransport>>readLine (TDD)'.
			t prompt: 'You are working in the Pharo Smalltalk repository /home/mumez/git/pharo-acp (Tonel format under src/). The branch feature/ndjson-final-drain-on-exit is already checked out: do NOT switch branches, commit, or push.

Problem: since PR #50, ACPNdJsonTransport>>isAtEnd (src/ACP-Transport/ACPNdJsonTransport.class.st) also returns true when "processLauncher isRunning not". In #readLine this race can lose data:
  chunk := self readStream upToEnd   -> empty
  (the agent now writes its last line and exits)
  self isAtEnd                       -> true because the process has exited
  -> readLine returns only readBuffer or nil and never reads the final bytes left in the pipe (e.g. an error response written just before exit).

Required fix (from the issue; already checked against the current code): in #readLine, when chunk is empty and isAtEnd is true, try one final drain:
  chunk := [ self readStream upToEnd ] on: Error do: [ :e | nil ].
If the drained chunk is not empty, append it to readBuffer and continue the loop (so several lines in the drained data are split by the normal LF handling). Only when the drained chunk is empty, return the remaining readBuffer as a line (utf8Decoded, then reset readBuffer to ByteArray new), or nil when readBuffer is empty. Keep the existing Error handling on the first upToEnd and the pollDelay wait. Match the existing style of the class (and keep the method readable; extract a small private helper only if it clearly helps).

Work test-first, in src/ACP-Tests/ACPNdJsonTransportTest.class.st:
1. Deterministic unit test that reproduces the race without timing: e.g. a small test double read stream whose first #upToEnd answers an empty ByteArray and whose next #upToEnd answers a complete JSON line (UTF-8 bytes ending in LF), plus a launcher double that answers false to #isRunning (set via #processLauncher:, useAtEnd: false). Assert #readMessage answers the parsed Dictionary instead of nil. If you add a test helper class, put it in the ACP-Tests package with a CRC-style class comment.
2. Integration test modelled on the existing testReadMessageReturnsNilWhenTheProcessExits: launch ACPProcessLauncher with command /bin/sh and arguments -c and a script that printf-s the line {"jsonrpc":"2.0","id":1,"result":{}} followed by a newline and then runs exit 1. Read it with (ACPNdJsonTransport on: launcher) readMessage in a forked process, synchronize with a Semaphore (waitTimeoutSeconds: 5), assert the result is the expected Dictionary (e.g. id = 1), and terminate the launcher in an ensure: block. Also check that a following readMessage answers nil.
Confirm the unit test fails before the fix, then implement the fix and confirm both new tests and the existing ACPNdJsonTransportTest tests pass.

Update the Implementation Points in the ACPNdJsonTransport class comment to mention the final drain after the process exits.

Use the smalltalk-dev skills (smalltalk-developer for Tonel/style, st-import to load packages with absolute paths, st-test to run tests). Import order: ACP-Transport, then ACP-Tests. Out of scope: the v2 class ACP2NdJsonTransport (it is not on this branch) - do not create or touch any ACP2-* package.

Finish by reporting the changed files, the new test names, and the test results.'.
			t goal: 'the new ACPNdJsonTransport final-drain tests and all existing ACPNdJsonTransportTest tests pass in the image' ] }
		agentBy: [ :a | a claude ].
	builder seq: {
		builder topicBy: [ :t |
			t title: 'Run ACP test suites'.
			t prompt: 'In the Pharo repository /home/mumez/git/pharo-acp (branch feature/ndjson-final-drain-on-exit; do NOT switch branches, commit, or push), ACPNdJsonTransport>>readLine was just changed to drain the pipe one last time after the agent process exits, with new tests in src/ACP-Tests/ACPNdJsonTransportTest.class.st.

Verify it in the running image:
1. Re-import the packages from src/ with absolute paths, in order ACP-Transport then ACP-Tests (st-import skill / smalltalk-interop import_package), so the image matches the files on disk.
2. Run the test class ACPNdJsonTransportTest and report pass/fail counts.
3. Run the whole ACP-Tests package (st-test skill / run_package_test) and report pass/fail/error counts.
4. If anything fails, investigate. If the failure is caused by this change, fix it in the Tonel files, re-import, and re-run. If it is a pre-existing or environment-dependent failure unrelated to this change, do not change unrelated code: report it clearly as unrelated, with the reason.

Report the final numbers for both runs and any fixes you made.' ] }
		agentBy: [ :a | a claude ].
	builder seq: {
		builder topicBy: [ :t |
			t title: 'Lint and style review'.
			t prompt: 'In the Pharo repository /home/mumez/git/pharo-acp (branch feature/ndjson-final-drain-on-exit; do NOT switch branches, commit, or push), review the uncommitted changes (git diff, plus any new untracked files under src/) for the ACPNdJsonTransport final-drain fix.

1. Lint every changed or new Tonel file with the st-lint skill (or the smalltalk-validator MCP tools lint_tonel_smalltalk_from_file / validate_tonel_smalltalk_from_file) and fix the findings.
2. Check the changes against the style guide in the smalltalk-developer skill (method categories, naming, CRC class comments for any new class, readable method length) and fix problems.
3. Check that the change stays in scope: only src/ACP-Transport/ACPNdJsonTransport.class.st, src/ACP-Tests files, and nothing under ACP2-* or unrelated packages.
4. If you changed anything, re-import ACP-Transport and ACP-Tests (absolute paths) and re-run ACPNdJsonTransportTest and the ACP-Tests package to confirm they still pass.

Report the lint results, the fixes you made, and the final test results.' ] }
		agentBy: [ :a | a claude ] ].
script forkRunThen: [ :orc | Transcript crShow: 'Done: ' , orc result ]
	onTimeout: [ :timeoutStep :ex | Transcript crShow: 'Timed out: ' , timeoutStep printString ].
script register
```

## How to run

Paste the script above into a Pharo Playground, or ask the assistant to run it via st-eval. `forkRunThen:onTimeout:` runs the orchestration in the background and returns immediately — watch for the completion block's own report (e.g. via Transcript), the `onTimeout:` block's report if a step stalls, or check progress with `AbOrchestrationManager default orchestrationAt: <orchestration script id>`.
