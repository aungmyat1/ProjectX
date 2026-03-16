# Connect and work with the ClawX agent

This guide explains how to use **ClawX / OpenClaw** with ProjectX so your agents, config, and workspace live in the repo and you can run the gateway from the CLI or Docker.

## 1. One config, one state

When you run the OpenClaw CLI from ProjectX (e.g. `npm run openclaw -- ...` or `.\openclaw.ps1 ...`), state is stored under **ProjectX**:

- **State dir:** `<ProjectX>/.openclaw/`
- **Config file:** `<ProjectX>/.openclaw/openclaw.json`
- **Sessions, credentials, agent dirs:** under `.openclaw/agents/`, `.openclaw/credentials/`, etc.

So all config and runtime state for the “ProjectX agent” stays in the repo (and `.openclaw/` is gitignored so secrets are not committed).

## 2. First-time setup

From **ProjectX root**:

```powershell
# Create .openclaw/openclaw.json and seed workspace (if missing)
npm run openclaw -- setup
```

Or with the PowerShell wrapper:

```powershell
.\openclaw.ps1 setup
```

Then either:

- **Use the example config:** copy `docs/openclaw.json.example` to `.openclaw/openclaw.json`, replace `<PROJECTX_ROOT>` with your actual ProjectX path (e.g. `C:/ProjectX` or `/home/you/ProjectX`), then create the workspace folder (e.g. `mkdir workspace`).  
- **Or edit** `.openclaw/openclaw.json` by hand and set `agents.defaults.workspace` and (optionally) `agents.list` as in the next sections.

## 3. Point the agent at ProjectX

So that the ClawX agent uses files inside ProjectX (AGENTS.md, SOUL.md, skills, etc.):

1. **Workspace**  
   Set the agent’s workspace to a folder inside ProjectX, e.g. `<ProjectX>/workspace`.  
   In `.openclaw/openclaw.json`:

   ```json
   {
     "agents": {
       "defaults": {
         "workspace": "C:/ProjectX/workspace"
       }
     }
   }
   ```

   Use your real path (e.g. `C:/ProjectX/workspace` on Windows, `/home/you/ProjectX/workspace` on Linux/macOS). Create the folder if it doesn’t exist:

   ```powershell
   mkdir workspace
   ```

2. **Bootstrap files**  
   OpenClaw expects (and can create) these inside that workspace:

   - `AGENTS.md` – how the agent should behave, rules, memory usage  
   - `SOUL.md` – persona, tone, boundaries  
   - `USER.md` – who you are, how to address you  
   - `IDENTITY.md` – agent name, emoji, vibe  
   - `TOOLS.md` – your notes on tools (does not enable/disable tools)  
   - `workspace/skills/` – optional extra skills

   You can copy or adapt `ClawX/resources/resources/context/AGENTS.clawx.md` into `workspace/AGENTS.md` and edit it. After the first run, OpenClaw may create the other files if they’re missing (unless you set `skipBootstrap: true`).

## 4. Agents in OpenClaw vs ProjectX YAMLs

- **OpenClaw** defines agents in **`openclaw.json`** under **`agents.list`** (id, workspace, model, identity, tools, etc.).
- **ProjectX** has **`agents/*.yaml`** as **templates** (research_agent, personal_assistant, trading_agent, etc.) with high-level fields like `agent`, `model`, `tools`, `memory`.

To “connect” them:

1. **Single agent (simplest)**  
   Use one agent in `openclaw.json` and point its `workspace` to ProjectX (as above). Model and tools are configured in `openclaw.json` (e.g. `agents.defaults.models`, `agents.defaults.tools` or per-agent in `agents.list[].model` / `agents.list[].tools`). The YAMLs then serve as **reference** for which model/tools to configure for that agent.

2. **Multiple agents**  
   Add one entry per agent in `agents.list`, each with its own `id`, `workspace`, and optionally `agentDir`. Map each entry to a ProjectX YAML by hand (e.g. `research_agent.yaml` → agent id `research_agent`, workspace `.../workspace-research`, model/tools from the YAML). OpenClaw does **not** load `agents/*.yaml` automatically; you translate the YAML intent into `openclaw.json`.

Example minimal `agents.list` for two agents (paths are placeholders; use your real ProjectX path):

```json
{
  "agents": {
    "defaults": {
      "workspace": "C:/ProjectX/workspace"
    },
    "list": [
      {
        "id": "main",
        "default": true,
        "name": "ProjectX Main",
        "workspace": "C:/ProjectX/workspace"
      },
      {
        "id": "research_agent",
        "name": "Research Agent",
        "workspace": "C:/ProjectX/workspace-research"
      }
    ]
  }
}
```

Create the workspace folders (e.g. `workspace`, `workspace-research`) and put AGENTS.md / SOUL.md in each as needed.

## 5. Run the gateway and talk to the agent

**Option A – Gateway from CLI (same machine as ProjectX)**

```powershell
npm run openclaw -- gateway
```

Or:

```powershell
.\openclaw.ps1 gateway
```

This starts the OpenClaw gateway using **`.openclaw/openclaw.json`** and the state in `.openclaw/`. The ClawX **desktop app** (if installed) can run the gateway internally; to use the **ProjectX** config with the app you’d need the app to use `OPENCLAW_STATE_DIR=<ProjectX>\.openclaw` when it starts (if your ClawX build supports that). Otherwise, use the CLI gateway as above and connect any client (e.g. Control UI, channels) to that gateway.

**Option B – Gateway in Docker**

```powershell
npm run gateway
```

The Compose service mounts `configs/`, `agents/`, `logs/`, and `memory/` from ProjectX. The gateway inside the container still needs its own config (e.g. via a bind-mounted `openclaw.json` or env); see the Dockerfile and `docker-compose.yml` for how config is provided. The agent **inside** the container will use whatever workspace path is set in that config (often a path inside the container that maps to ProjectX via volumes).

## 6. Channels and bindings (optional)

To route chats (e.g. WhatsApp, Telegram, Discord) to your agent:

1. Add and log in to a channel, e.g.  
   `npm run openclaw -- channels login --channel telegram`
2. In `openclaw.json`, add **bindings** so that channel/account (and optionally peer) map to an agent id from `agents.list`. See OpenClaw docs: [Multi-Agent Routing](https://github.com/openclaw/openclaw/blob/main/docs/concepts/multi-agent.md) and [configuration reference](https://github.com/openclaw/openclaw/blob/main/docs/gateway/configuration-reference.md) (`bindings`, `match.channel`, `match.accountId`).

Then start the gateway (CLI or Docker); the channel will connect to it and route to the correct agent.

## 7. Quick checklist

| Step | Action |
|------|--------|
| 1 | From ProjectX root: `npm run openclaw -- setup` (or `.\openclaw.ps1 setup`) |
| 2 | Set `agents.defaults.workspace` in `.openclaw/openclaw.json` to your ProjectX workspace path (e.g. `C:/ProjectX/workspace`) |
| 3 | Create that folder; add or let OpenClaw create `AGENTS.md`, `SOUL.md`, etc. |
| 4 | (Optional) Add more agents in `agents.list` and bind channels in `bindings` |
| 5 | Run the gateway: `npm run openclaw -- gateway` or `npm run gateway` (Docker) |
| 6 | Use the ClawX app or Control UI / channels to talk to the agent |

Once this is done, the ClawX agent is **using ProjectX**: config and state under `.openclaw/`, workspace under `workspace/` (or per-agent folders), and you can keep improving behavior by editing `AGENTS.md`, `SOUL.md`, and the YAMLs as reference for `openclaw.json`.
