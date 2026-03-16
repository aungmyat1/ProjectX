# ProjectX – ClawX / OpenClaw layout

Recommended folder structure for **AI trading system** and **AI product factory** so config and agents stay in one place.

## Layout

```
ProjectX/
  configs/
    models.yaml     # OpenRouter + multi-model routing (default, fast, coding, analysis)
    providers.yaml  # OpenRouter provider (base_url, model)
  agents/
    research_agent.yaml
    trading_agent.yaml
    dev_agent.yaml
    market_agent.yaml
    sentiment_agent.yaml
    strategy_agent.yaml
    execution_agent.yaml
    product_agent.yaml
    marketing_agent.yaml
  logs/             # Optional local logs
  memory/           # Agent long-term store
```

## Model routing (cost ~70–90% lower)

| Task            | Model                        |
|-----------------|------------------------------|
| General         | minimax/minimax-01           |
| Fast            | google/gemini-flash-1.5      |
| Coding          | deepseek/deepseek-chat       |
| Complex analysis| anthropic/claude-3.5-sonnet  |

Edit `configs/models.yaml` to change routing. In ClawX, set **Settings → Providers** to OpenRouter with Base URL `https://openrouter.ai/api/v1` and your API key.

## Agents

Use these YAMLs as templates. Point ClawX/OpenClaw at `agents/` if it supports loading from a directory. Each agent has a model and tools (web_search, news_scraper, python, etc.) and memory settings.

## ClawX / OpenClaw CLI

ProjectX includes wrappers so the OpenClaw CLI uses **state under this repo** (`OPENCLAW_STATE_DIR=.openclaw`), keeping config and sessions in one place.

### Run from ProjectX root

| Method | Command |
|--------|--------|
| **npm** | `npm run openclaw -- [args]` (e.g. `npm run openclaw -- --version`, `npm run openclaw -- gateway`) |
| **Windows PowerShell** | `.\openclaw.ps1 [args]` |
| **Git Bash / WSL** | `./openclaw [args]` |

Examples:

```bash
npm run openclaw -- --version
npm run openclaw -- setup
npm run openclaw -- gateway
.\openclaw.ps1 channels list
```

Config and state are stored in **`.openclaw/`** (e.g. `.openclaw/openclaw.json`). You can point OpenClaw at `configs/` and `agents/` via that config or via ClawX Settings when using the desktop app.

**Connecting and working with the ClawX agent:** see **[Connect and work with ClawX agent](docs/CLAWX_AGENT.md)** for workspace setup, mapping `agents/*.yaml` to OpenClaw config, and running the gateway together with ProjectX.

### Gateway via Docker

```bash
npm run gateway        # start openclaw-gateway in background
npm run gateway:logs   # follow logs
npm run gateway:down   # stop
```

The Compose service mounts `configs/`, `agents/`, `logs/`, and `memory/` from ProjectX.
