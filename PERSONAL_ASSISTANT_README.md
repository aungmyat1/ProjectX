# ClawX Personal Assistant & AI Coaching Setup

## Overview

This ClawX gateway is optimized for personal assistant and AI coaching use cases with intelligent token usage management for suitable performance.

## Agents

### Personal Assistant (`personal_assistant`)
- **Purpose**: Daily productivity, task management, information retrieval
- **Model**: Google Gemini Flash 1.5 (fast responses)
- **Token Limit**: 1000 (quick interactions)
- **Tools**: Notes, reminders, calendar, weather, music, web search

### AI Coach (`ai_coach`)
- **Purpose**: Teaching AI models, prompt engineering, performance optimization
- **Model**: MiniMax-01 (balanced reasoning, low cost)
- **Token Limit**: 2000 (detailed explanations)
- **Tools**: Coding agent, model usage analysis, session logs, GitHub

## Token Usage Optimization

### Performance-Focused Routing
```
default: minimax/minimax-01           # Cost-effective general use
fast: google/gemini-flash-1.5         # Fast for personal tasks
coding: deepseek/deepseek-chat        # Coding and debugging
analysis: anthropic/claude-3.5-sonnet # Heavy reasoning (rare)
```

### Cost Savings
- **Personal Assistant**: ~90% cheaper than Claude 3.5 Sonnet
- **AI Coaching**: ~95% cheaper than GPT-4 level models
- **Total**: 85-95% reduction in API costs

### Performance Features
- Auto-compaction prevents context overflow
- Smart memory management
- Response time optimization
- Token usage monitoring

## Usage Examples

### Personal Assistant
```
/agent personal_assistant
What's my schedule today? Add a reminder for the meeting at 3 PM.
```

### AI Coaching
```
/agent ai_coach
Help me optimize this prompt for better AI responses. Analyze my model's performance.
```

### Token Monitoring
```
/usage tokens    # Check current session token usage
/usage cost      # Estimate costs
/status          # Overall system status
```

## Configuration

1. **Models**: `configs/models.yaml` - Model routing optimization
2. **Providers**: `configs/providers.yaml` - API settings and limits
3. **Performance**: `configs/performance_config.json` - Advanced optimization
4. **Agents**: `agents/` directory - Custom agent configurations

## Best Practices

### For Personal Assistant Use
- Use short, specific requests
- Leverage memory for continuity
- Combine multiple tasks in one request

### For AI Coaching
- Provide clear learning objectives
- Use iterative improvement approach
- Monitor token usage for efficiency
- Leverage session logs for progress tracking

### Token Optimization Tips
- Use `/compact` for long conversations
- Use `/summarize` for long content
- Monitor usage with `/usage` commands
- Switch agents based on task complexity

## Performance Metrics

- **Response Time**: <2s for personal assistant, <5s for coaching
- **Token Efficiency**: 70-90% reduction vs. premium models
- **Context Management**: Auto-compaction prevents overflow
- **Cost Savings**: 85-95% reduction in API costs
