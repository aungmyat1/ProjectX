# Create New OpenClaw Agent Script
param(
    [Parameter(Mandatory=$true)]
    [string]$AgentId,
    
    [Parameter(Mandatory=$true)]
    [string]$AgentName,
    
    [Parameter(Mandatory=$false)]
    [string]$Model = "openrouter/anthropic/claude-sonnet-4",
    
    [Parameter(Mandatory=$false)]
    [string]$Description = "Specialized AI assistant",
    
    [Parameter(Mandatory=$false)]
    [string]$Personality = "helpful, professional, and knowledgeable"
)

Write-Host "🤖 Creating new agent: $AgentName ($AgentId)" -ForegroundColor Green

# Ensure we're in ProjectX root
if (-not (Test-Path ".openclaw")) {
    Write-Host "❌ Please run this from ProjectX root directory" -ForegroundColor Red
    exit 1
}

# Create workspace directory
$workspaceDir = ".\workspace-$AgentId"
New-Item -ItemType Directory -Path $workspaceDir -Force | Out-Null
Write-Host "✅ Created workspace: $workspaceDir" -ForegroundColor Green

# Create SOUL.md
$soulContent = @"
# $AgentName Soul

## Core Identity
You are $AgentName, a $Description.

## Personality
$Personality

## Specialization
- Focus area defined by your role as $AgentName
- Maintain expertise in your domain
- Collaborate with other agents when needed

## Guidelines
- Stay in character as $AgentName
- Provide value in your specialization
- Be concise but thorough
- Ask for clarification when needed

## Integration
- You are part of a multi-agent system
- Use /agent to delegate to other specialists
- Share context efficiently with other agents
"@

Set-Content -Path "$workspaceDir\SOUL.md" -Value $soulContent
Write-Host "✅ Created SOUL.md" -ForegroundColor Green

# Copy base files
if (Test-Path "workspace\AGENTS.md") {
    Copy-Item "workspace\AGENTS.md" "$workspaceDir\" -Force
    Copy-Item "workspace\USER.md" "$workspaceDir\" -Force  
    Copy-Item "workspace\TOOLS.md" "$workspaceDir\" -Force
    Copy-Item "workspace\HEARTBEAT.md" "$workspaceDir\" -Force
    Write-Host "✅ Copied base configuration files" -ForegroundColor Green
}

# Create IDENTITY.md
$identityContent = @"
# IDENTITY.md - $AgentName

- **Name:** $AgentName
- **ID:** $AgentId
- **Role:** $Description
- **Creature:** AI Assistant Specialist
- **Vibe:** $Personality
- **Emoji:** 🤖 (customize this)
- **Model:** $Model

## Specialization
This agent is optimized for specific tasks within the multi-agent system.

## Workspace
Located at: workspace-$AgentId/
"@

Set-Content -Path "$workspaceDir\IDENTITY.md" -Value $identityContent
Write-Host "✅ Created IDENTITY.md" -ForegroundColor Green

# Generate agent config snippet
$configSnippet = @"
{
  "id": "$AgentId",
  "name": "$AgentName", 
  "workspace": "C:/ProjectX/workspace-$AgentId",
  "model": {
    "primary": "$Model"
  },
  "description": "$Description"
}
"@

Write-Host "`n📋 Add this to your .openclaw/openclaw.json agents.list array:" -ForegroundColor Yellow
Write-Host $configSnippet -ForegroundColor Cyan

Write-Host "`n🚀 Agent '$AgentName' created successfully!" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Add the config snippet to .openclaw/openclaw.json agents.list" -ForegroundColor White
Write-Host "2. Customize $workspaceDir\SOUL.md for personality" -ForegroundColor White  
Write-Host "3. Restart gateway: npm run openclaw gateway" -ForegroundColor White
Write-Host "4. Test with: /agent $AgentId" -ForegroundColor White

Write-Host "`n💡 Example usage commands:" -ForegroundColor Cyan
Write-Host "/agent $AgentId        # Switch to this agent" -ForegroundColor Gray
Write-Host "/agents list         # List all agents" -ForegroundColor Gray
Write-Host "/agent main          # Switch back to main" -ForegroundColor Gray