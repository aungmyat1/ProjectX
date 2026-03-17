param(
    [string]$ProjectRoot = "C:\ProjectX",
    [string]$ReportDir = "docs\ops-reports"
)

Set-Location $ProjectRoot

if (-not (Test-Path ".openclaw")) {
    Write-Host "❌ .openclaw directory not found. Run from a valid ProjectX root or adjust ProjectRoot." -ForegroundColor Red
    exit 1
}

# Ensure report directory exists
$fullReportDir = Join-Path $ProjectRoot $ReportDir
New-Item -ItemType Directory -Path $fullReportDir -Force | Out-Null

$dateStamp = Get-Date -Format "yyyy-MM-dd"
$reportPath = Join-Path $fullReportDir "$dateStamp-daily-ops.md"

Write-Host "🟢 Running ClawX Ops daily check for $dateStamp..." -ForegroundColor Green

# Use the npm openclaw wrapper to ensure OPENCLAW_STATE_DIR is set correctly.
$promptFile = "docs\CLAWX_OPS_PROMPT.txt"
if (-not (Test-Path $promptFile)) {
    Write-Host "❌ Prompt file '$promptFile' not found." -ForegroundColor Red
    exit 1
}

# Run the ops agent and capture output into the report file.
# NOTE: This assumes the OpenClaw CLI supports `sessions spawn` with:
#   --agent ops
#   --prompt-file <path>
#   --output-file <path>

$cmd = "npm run openclaw -- sessions spawn --agent ops --prompt-file `"$promptFile`" --output-file `"$reportPath`""
Write-Host "➡️  Executing: $cmd" -ForegroundColor Yellow

powershell -NoProfile -ExecutionPolicy Bypass -Command $cmd

if (Test-Path $reportPath) {
    Write-Host "✅ Daily ops report written to: $reportPath" -ForegroundColor Green
} else {
    Write-Host "⚠️ Ops routine finished but report file was not found. Check CLI output for errors." -ForegroundColor Yellow
}

