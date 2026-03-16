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
