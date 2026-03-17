# Multi-Agent Setup Guide

This guide shows how to create and manage multiple OpenClaw agents in ProjectX.

## 🏗️ Current Architecture

```
ProjectX/
├── .openclaw/
│   └── openclaw.json          # Central configuration
├── workspace/                 # Main agent workspace  
├── workspace-research/        # Research agent workspace
├── workspace-trading/         # Trading agent workspace
└── agents/                    # Agent templates (YAML)
    ├── research_agent.yaml
    ├── personal_assistant.yaml
    └── trading_agent.yaml
```

## 🤖 Adding New Agents

### Method 1: Using PowerShell Script

```powershell
# Run from ProjectX root
.\scripts\create-agent.ps1 -AgentId "research" -AgentName "Research Assistant" -Model "openrouter/anthropic/claude-opus-4-6"
```

### Method 2: Manual Setup

**Step 1: Create workspace directory**
```powershell
mkdir C:\ProjectX\workspace-research
```

**Step 2: Create agent files**
```powershell
# Copy base files
copy C:\ProjectX\workspace\AGENTS.md C:\ProjectX\workspace-research\
copy C:\ProjectX\workspace\USER.md C:\ProjectX\workspace-research\
copy C:\ProjectX\workspace\TOOLS.md C:\ProjectX\workspace-research\

# Create custom SOUL.md for the agent
```

**Step 3: Add to .openclaw/openclaw.json**
```json
{
  "agents": {
    "list": [
      {
        "id": "main",
        "default": true,
        "name": "ClawX Main Assistant", 
        "workspace": "C:/ProjectX/workspace"
      },
      {
        "id": "research",
        "name": "Research Assistant",
        "workspace": "C:/ProjectX/workspace-research",
        "model": {
          "primary": "openrouter/anthropic/claude-opus-4-6"
        },
        "description": "Specialized research and analysis agent"
      },
      {
        "id": "trading",
        "name": "Trading Agent",
        "workspace": "C:/ProjectX/workspace-trading",
        "model": {
          "primary": "openrouter/anthropic/claude-sonnet-4"
        },
        "description": "Market analysis and trading assistant"
      }
    ]
  }
}
```

## 🎯 Agent Specialization Examples

### Research Agent
```json
{
  "id": "research",
  "name": "Research Assistant",
  "workspace": "C:/ProjectX/workspace-research",
  "model": {
    "primary": "openrouter/anthropic/claude-opus-4-6"
  },
  "tools": {
    "allow": ["web_search", "web_fetch", "memory_search", "sessions_spawn"]
  },
  "description": "Deep research, fact-checking, and analysis"
}
```

### Trading Agent  
```json
{
  "id": "trading",
  "name": "Trading Agent",
  "workspace": "C:/ProjectX/workspace-trading", 
  "model": {
    "primary": "openrouter/anthropic/claude-sonnet-4"
  },
  "tools": {
    "allow": ["web_search", "exec", "message"]
  },
  "description": "Market analysis and trading insights"
}
```

### Code Agent
```json
{
  "id": "code",
  "name": "Code Assistant", 
  "workspace": "C:/ProjectX/workspace-code",
  "model": {
    "primary": "openrouter/anthropic/claude-opus-4-6"
  },
  "tools": {
    "allow": ["exec", "read", "write", "edit", "sessions_spawn"]
  },
  "description": "Software development and code review"
}
```

## 🔗 Channel Routing

Route different channels to different agents:

```json
{
  "bindings": [
    {
      "match": {
        "channel": "discord",
        "peer": "research-channel"
      },
      "target": {
        "agent": "research"
      }
    },
    {
      "match": {
        "channel": "telegram", 
        "peer": "trading-chat"
      },
      "target": {
        "agent": "trading"
      }
    },
    {
      "match": {
        "channel": "webchat"
      },
      "target": {
        "agent": "main"
      }
    }
  ]
}
```

## 🚀 Quick Start Commands

**Create Research Agent:**
```powershell
# Create workspace
mkdir C:\ProjectX\workspace-research

# Copy files  
copy C:\ProjectX\workspace\*.md C:\ProjectX\workspace-research\

# Edit workspace-research\SOUL.md for research personality
# Add agent config to .openclaw\openclaw.json
# Restart gateway
```

**Test Agent Switching:**
```
/agent research   # Switch to research agent
/agent main       # Switch back to main
/agents list      # List all agents
```

## 💰 Cost Optimization per Agent

- **Main Agent:** Sonnet 4 (general use)
- **Research Agent:** Opus 4.6 (complex analysis)
- **Trading Agent:** Sonnet 4 (fast decisions) 
- **Code Agent:** Opus 4.6 (complex reasoning)
- **Heartbeats:** All use Haiku 3.5 (cheap)

## 📊 VPS Deployment

Each agent gets its own workspace volume:

```yaml
# docker-compose.yml
volumes:
  - ./workspace:/app/workspace
  - ./workspace-research:/app/workspace-research  
  - ./workspace-trading:/app/workspace-trading
  - ./workspace-code:/app/workspace-code
```

## 🎯 Agent Templates

Reference the YAML files in `agents/` directory to understand intended capabilities:

- `research_agent.yaml` → Research specialization
- `trading_agent.yaml` → Trading/finance focus  
- `personal_assistant.yaml` → General assistance
- `code_agent.yaml` → Development tasks

The YAMLs are **templates** - translate their intent into the `openclaw.json` configuration.

## 🔧 Management Commands

```powershell
# Start gateway with multi-agent config
cd C:\ProjectX
npm run openclaw gateway

# Or with Docker
npm run gateway

# Check agent status
npm run openclaw agents list

# Switch between agents in chat
/agent research
/agent main
```

This setup gives you specialized agents with their own workspaces, models, and capabilities while sharing the same gateway and infrastructure!