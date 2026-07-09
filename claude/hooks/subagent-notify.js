#!/usr/bin/env node
// subagent-notify: fires one "done" notification only after the main loop
// is idle AND every dispatched sub-agent (SubagentStart/SubagentStop) has finished.
// Modes (argv[2]): start | stop | check-stop | cleanup

const fs = require('fs');
const { execFileSync } = require('child_process');

function readStdin() {
  try {
    const data = fs.readFileSync(0, 'utf8');
    return data ? JSON.parse(data) : {};
  } catch {
    return {};
  }
}

function sleep(ms) {
  Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, ms);
}

const input = readStdin();
const sessionId = input.session_id || 'unknown';
const mode = process.argv[2];

const counterFile = `/tmp/claude-subagents-${sessionId}.count`;
const pendingFile = `/tmp/claude-subagents-${sessionId}.pending`;
const lockDir = `/tmp/claude-subagents-${sessionId}.lock`;

function withLock(fn) {
  const deadline = Date.now() + 2000;
  while (true) {
    try {
      fs.mkdirSync(lockDir);
      break;
    } catch (err) {
      if (err.code !== 'EEXIST') throw err;
      if (Date.now() > deadline) break;
      sleep(15);
    }
  }
  try {
    return fn();
  } finally {
    try { fs.rmdirSync(lockDir); } catch {}
  }
}

function readCount() {
  try {
    return parseInt(fs.readFileSync(counterFile, 'utf8'), 10) || 0;
  } catch {
    return 0;
  }
}

function writeCount(n) {
  fs.writeFileSync(counterFile, String(Math.max(0, n)));
}

function notify() {
  try {
    execFileSync('osascript', [
      '-e',
      'display notification "Finished — waiting for input" with title "Claude Code" sound name "Glass"',
    ]);
  } catch {}
}

withLock(() => {
  if (mode === 'start') {
    writeCount(readCount() + 1);
  } else if (mode === 'stop') {
    const n = Math.max(0, readCount() - 1);
    writeCount(n);
    if (n === 0 && fs.existsSync(pendingFile)) {
      fs.unlinkSync(pendingFile);
      notify();
    }
  } else if (mode === 'check-stop') {
    const n = readCount();
    if (n > 0) {
      fs.writeFileSync(pendingFile, '1');
    } else {
      notify();
    }
  } else if (mode === 'cleanup') {
    for (const f of [counterFile, pendingFile]) {
      try { fs.unlinkSync(f); } catch {}
    }
  }
});
