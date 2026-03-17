# Create VPS Management Agent
cd C:\ProjectX
.\scripts\create-agent.ps1 -AgentId "vps" -AgentName "VPS Manager" -Model "openrouter/anthropic/claude-sonnet-4" -Description "VPS infrastructure management and DevOps specialist" -Personality "technical, efficient, security-focused"

Write-Host "🖥️ VPS Agent created!" -ForegroundColor Green
Write-Host "Specializes in:" -ForegroundColor Yellow
Write-Host "- Server management and monitoring" -ForegroundColor White
Write-Host "- Docker container orchestration" -ForegroundColor White  
Write-Host "- Security hardening and updates" -ForegroundColor White
Write-Host "- OpenClaw gateway management" -ForegroundColor White
Write-Host "- Log analysis and troubleshooting" -ForegroundColor White