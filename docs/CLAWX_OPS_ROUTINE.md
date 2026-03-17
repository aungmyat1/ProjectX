## ClawX Ops Monitor – Daily Routine

This document defines the **daily routine** for the `ops` agent (`id: "ops"`, name: `Ops Monitor`) to check overall **health, performance, token usage, security posture**, and to produce a brief **ops report**.

### 1. Scope and assumptions

- **Agent id**: `ops`
- **Workspace**: `C:/ProjectX/workspace` (shared with `main`)
- **Primary model**: `openrouter/google/gemini-flash-1.5` (cheap, fast)
- **Invocation**: you (or an external scheduler) start a session with the `ops` agent and give it the prompt in section 2.

### 2. Standard daily-ops prompt

Use this prompt when you want the `ops` agent to run the full daily routine:

```text
You are the Ops Monitor for this ProjectX / ClawX deployment.

Run a DAILY HEALTH AND COST CHECK with the following steps. Use only information and tools you have; if something is not available, say so explicitly.

1) HEALTH & STABILITY
- Check recent errors, warnings, or abnormal behavior you can see (sessions, logs, or summaries if available).
- Identify any patterns: frequent restarts, repeated tool failures, long-running tasks, or channel disconnects.
- Output: short bullet list of notable health findings; "None observed" if nothing clear.

2) PERFORMANCE
- From the information you have, reason about latency and performance:
  - Are there signs of slow responses (e.g. long-running tasks, repeated timeouts, heavy context sizes)?
  - Are expensive models being used more than necessary (e.g. analysis agent for trivial tasks)?
- Suggest 3–5 concrete, low-risk optimizations (e.g. prefer cheaper models for specific workloads, tighten maxTokens, adjust concurrency or context usage).

3) TOKEN & COST USAGE
- Using whatever metrics or history you can access (or qualitative reasoning if metrics are not visible), estimate:
  - Which agents and models are likely consuming the most tokens.
  - Whether the current model assignments (main, analysis, vps, ops) look cost‑efficient.
- Output a compact "Cost Focus" summary:
  - TOP COST DRIVERS (likely)
  - QUICK SAVINGS (easy changes)

4) SECURITY & ACCESS POSTURE
- Inspect or reason about:
  - Which channels are enabled (e.g. Discord) and any obvious risks in their settings.
  - Tool access patterns that might be high‑risk (e.g. exec, write, edit, web_search on broad scopes).
  - Token / auth configuration that is visible (but DO NOT print secrets).
- Output:
  - Potential security concerns (if any)
  - Concrete, practical hardening suggestions (3–5 bullets).

5) SUMMARY REPORT (FINAL OUTPUT)
Produce a FINAL REPORT with these sections:
- STATUS: one of [GREEN, YELLOW, RED] with 1–2 sentences.
- HEALTH: 3–5 bullets.
- PERFORMANCE: 3–5 bullets, including any model-usage tuning suggestions.
- TOKEN & COST: 3–5 bullets, focusing on where to optimize.
- SECURITY: 3–5 bullets, including any config or access changes to consider.
- TOP 3 ACTIONS FOR OWNER: numbered list of the most important things to do next.

Be concise and practical. Prefer specific suggestions over generic advice.
```

### 3. How to run this daily

- **Manual run** (recommended to start):
  - Start a new session with agent `ops`.
  - Paste the prompt from section 2.
  - Save or pin the resulting report in your preferred place (e.g., copy into a `docs/ops-reports/` markdown file).

- **Automated run (Windows Task Scheduler, fully wired)**:
  - This repo includes a helper script: `scripts/run-ops-daily.ps1`.
  - What it does:
    - Runs from `C:\ProjectX` (by default).
    - Ensures a `docs/ops-reports/` directory exists.
    - Uses `docs/CLAWX_OPS_PROMPT.txt` as the prompt.
    - Calls `npm run openclaw -- sessions spawn --agent ops --prompt-file docs\CLAWX_OPS_PROMPT.txt --output-file docs\ops-reports\<YYYY-MM-DD>-daily-ops.md`.
  - How to schedule it (high level):
    1. Open **Task Scheduler** → **Create Task…**.
    2. **Triggers** → *New…* → set **Daily** and your preferred time.
    3. **Actions** → *New…*:
       - **Program/script**: `powershell.exe`
       - **Add arguments**: `-NoProfile -ExecutionPolicy Bypass -File "C:\ProjectX\scripts\run-ops-daily.ps1"`
       - **Start in**: `C:\ProjectX`
    4. Save the task.
  - After that, a dated report file like `docs/ops-reports/2026-03-17-daily-ops.md` will be generated every day (assuming the gateway/CLI is available).

### 4. Suggested follow-up structure for reports

If you decide to persist reports, you can store them as markdown files like:

- `docs/ops-reports/2026-03-17-daily-ops.md`
- `docs/ops-reports/2026-03-18-daily-ops.md`

Each file simply contains the "FINAL REPORT" that the `ops` agent produces using the prompt above.

