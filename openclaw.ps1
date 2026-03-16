# ProjectX OpenClaw CLI wrapper (Windows)
# Uses OPENCLAW_STATE_DIR = <ProjectX>\.openclaw so config/state live in the repo.
# Run from ProjectX root: .\openclaw.ps1 [command] [args...]

$ErrorActionPreference = "Stop"
$ProjectXRoot = $PSScriptRoot
$StateDir = Join-Path $ProjectXRoot ".openclaw"
$env:OPENCLAW_STATE_DIR = $StateDir
$env:OPENCLAW_EMBEDDED_IN = if ($env:OPENCLAW_EMBEDDED_IN) { $env:OPENCLAW_EMBEDDED_IN } else { "ClawX" }

$ClawCliDir = Join-Path $ProjectXRoot "ClawX\resources\cli"
$ClawOpenclawDir = Join-Path $ProjectXRoot "ClawX\resources\openclaw"
$ClawExe = Join-Path $ProjectXRoot "ClawX\ClawX.exe"
$OpenclawCmd = Join-Path $ClawCliDir "openclaw.cmd"
$OpenclawMjs = Join-Path $ClawOpenclawDir "openclaw.mjs"

$argsPass = $args

# Prefer ClawX-bundled CLI when present
if ((Test-Path $OpenclawCmd) -and (Test-Path $ClawExe)) {
    $env:ELECTRON_RUN_AS_NODE = "1"
    & $OpenclawCmd @argsPass
    exit $LASTEXITCODE
}

# Fallback: run node openclaw.mjs from bundled openclaw
if (Test-Path $OpenclawMjs) {
    Push-Location $ClawOpenclawDir
    try {
        & node $OpenclawMjs @argsPass
        exit $LASTEXITCODE
    } finally {
        Pop-Location
    }
}

Write-Error "openclaw: No ClawX CLI or openclaw.mjs found. Ensure ClawX\resources\cli\openclaw.cmd and ClawX\ClawX.exe exist, or openclaw.mjs is present."
exit 1
