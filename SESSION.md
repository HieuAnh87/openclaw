# OpenClaw Setup Session - 2026-04-03

## Status: ✅ HOẠT ĐỘNG

## Credentials
- **GLM/z.ai API Key**: `82152843ff2b4b319f6a4a86a6220b1b.sUZb9fM45zvtl2Jp`
- **Telegram Bot Token**: `8523692617:AAE2HGFkl6V47upGAILqeOytM1Vnv56Ey5g`
- **Telegram User ID (owner)**: `1218178358`
- **Telegram User ID (approved)**: `7849443620`
- **Gateway Token**: `a595fa5985b1396c5674dbae5bb8c2c72bf5e9ae0d792e25`

## Working Config
- Model: `zai/glm-4.7`
- Channel: Telegram (`@hieudabot`)
- Gateway: `ws://0.0.0.0:18789`
- WebUI: `http://localhost:18789/#token=a595fa5985b1396c5674dbae5bb8c2c72bf5e9ae0d792e25`

## docker-compose.yml
```yaml
services:
  openclaw:
    image: ghcr.io/openclaw/openclaw:latest
    container_name: openclaw-agent
    restart: unless-stopped
    ports:
      - "18789:18789"
      - "18791:18791"
    volumes:
      - ./data:/home/node/.openclaw
    environment:
      - NODE_ENV=production
      - OPENCLAW_GATEWAY_HOST=0.0.0.0
      - ZAI_API_KEY=82152843ff2b4b319f6a4a86a6220b1b.sUZb9fM45zvtl2Jp
```

## Key Commands
```bash
cd /Users/hieuda/Documents/openclaw
docker compose up -d           # Start
docker compose logs -f         # View logs
docker compose restart         # Restart
docker exec openclaw-agent openclaw models list --status-plain   # List models
docker exec openclaw-agent openclaw pairing approve telegram <CODE>  # Approve user
```

## Notes
- Volume mount: `./data:/home/node/.openclaw` (NOT `/root/.openclaw`, container uses `/home/node/.openclaw`)
- Gateway bind: `lan` (required for OrbStack)
- Auth: ZAI_API_KEY via env var (auth-profiles.json not loaded properly)
- Pairing: Use `openclaw pairing approve telegram <CODE>` to approve new users
