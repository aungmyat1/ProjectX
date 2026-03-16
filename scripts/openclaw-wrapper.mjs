#!/usr/bin/env node
/**
 * ProjectX OpenClaw CLI wrapper.
 * Uses OPENCLAW_STATE_DIR = <ProjectX>/.openclaw so config and state live in the repo.
 * Prefers ClawX-bundled CLI (openclaw.cmd / openclaw) when available; else runs node openclaw.mjs.
 */

import { spawn } from "node:child_process";
import path from "node:path";
import fs from "node:fs";

const projectXRoot = process.cwd();
const stateDir = path.join(projectXRoot, ".openclaw");
const env = {
  ...process.env,
  OPENCLAW_STATE_DIR: stateDir,
  OPENCLAW_EMBEDDED_IN: process.env.OPENCLAW_EMBEDDED_IN || "ClawX",
};

const isWindows = process.platform === "win32";
const clawCliDir = path.join(projectXRoot, "ClawX", "resources", "cli");
const clawOpenclawDir = path.join(projectXRoot, "ClawX", "resources", "openclaw");
const clawExe = path.join(projectXRoot, "ClawX", "ClawX.exe");

function run(executable, args, opts = {}) {
  const child = spawn(executable, args, {
    stdio: "inherit",
    shell: opts.shell ?? isWindows,
    cwd: opts.cwd || projectXRoot,
    env: opts.env || env,
  });
  child.on("exit", (code) => process.exit(code ?? 0));
}

const args = process.argv.slice(2);

// Prefer ClawX-bundled CLI when present
if (isWindows) {
  const cmdPath = path.join(clawCliDir, "openclaw.cmd");
  if (fs.existsSync(cmdPath) && fs.existsSync(clawExe)) {
    run("cmd", ["/c", cmdPath, ...args], { env: { ...env, ELECTRON_RUN_AS_NODE: "1" } });
    return;
  }
} else {
  const shPath = path.join(clawCliDir, "openclaw");
  if (fs.existsSync(shPath) && fs.existsSync(path.join(projectXRoot, "ClawX", "ClawX"))) {
    run(shPath, args, { shell: false });
    return;
  }
}

// Fallback: run node openclaw.mjs from bundled openclaw (must be built)
const openclawMjs = path.join(clawOpenclawDir, "openclaw.mjs");
if (fs.existsSync(openclawMjs)) {
  run(process.execPath, [openclawMjs, ...args], { cwd: clawOpenclawDir });
  return;
}

console.error("openclaw: No ClawX CLI or openclaw.mjs found.");
console.error("  - Install ClawX and run from ProjectX root, or");
console.error("  - Ensure ClawX/resources/cli/openclaw.cmd (Windows) or openclaw (Unix) exists and ClawX.exe is present.");
process.exit(1);
