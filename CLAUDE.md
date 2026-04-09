# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an **OpenClaw AI Agent** deployment that runs as a Docker container and exposes a Telegram bot interface. The agent uses AI models from two providers:
- **ZAI** (`zai/`) — GLM family models via `api.z.ai`
- **LiteLLM** (`litellm/`) — Claude/GPT models via a local Nginx reverse proxy (HOCAI) that routes to `danglamgiau.com`

## Common Commands

```bash
# Agent management (openclaw-agent.sh)
./openclaw-agent.sh start       # Start all containers (openclaw + hocai-proxy)
./openclaw-agent.sh stop        # Stop all containers
./openclaw-agent.sh restart     # Restart
./openclaw-agent.sh status      # Check health
./openclaw-agent.sh logs        # Real-time logs
./openclaw-agent.sh doctor      # Diagnostic check
./openclaw-agent.sh shell       # Container shell
./openclaw-agent.sh webui       # Open http://localhost:18789

# Direct docker compose (both services in docker-compose.yml)
docker compose up -d            # Start all
docker compose up -d hocai-proxy # Restart proxy only
docker logs hocai-proxy
curl http://localhost:9099/health

# Inside container
docker exec openclaw-agent openclaw models list --status-plain
```

## Architecture

```
Telegram message → OpenClaw (port 18789) → ZAI API (glm-*) OR HOCAI Proxy (port 9099) → danglamgiau.com
```

**Docker network**: OpenClaw and HOCAI Proxy share the same bridge network (`172.19.0.0/16`). LiteLLM typically at `172.19.0.3:9099`.

## Key Config Files

| File | Purpose |
|------|---------|
| `data/openclaw.json` | Main config: gateway, channels, agents defaults, model registry |
| `data/openclaw.json.bak` | Last backup (note: `openclaw.json.bak.4` is oldest) |
| `data/agents/main/agent/models.json` | Agent-specific model overrides (e.g. `reasoning: false`) |
| `data/hocai-nginx/nginx.conf` | Nginx reverse proxy config for HOCAI/LiteLLM |
| `docker-compose.yml` | OpenClaw container definition |

**Default model**: `litellm/gpt-5.4-mini` (set in `data/openclaw.json` under `agents.defaults.model`).

## Workspace Files (Agent Memory)

The agent's identity and behavior live in `data/workspace/`:
- `SOUL.md` — Personality and core principles
- `AGENTS.md` — Operating rules, heartbeat strategy, memory conventions
- `MEMORY.md` — Long-term curated memory (main session only)
- `memory/` — Daily raw logs
- `HEARTBEAT.md` — Periodic checklist (empty = no heartbeat tasks)

Session startup sequence: `SOUL.md` → `AGENTS.md` → memory files → `MEMORY.md` (main only).

## HOCAI Proxy (Nginx)

The `hocai-proxy` container uses Nginx to bypass Cloudflare WAF on `danglamgiau.com`:
- Resolves DNS via `8.8.8.8` with `ipv6=off` to force IPv4
- Spoofs `User-Agent: PostmanRuntime/7.36.0` to bypass bot detection
- Routes `/v1` calls to the upstream API

If the proxy goes unhealthy (`docker ps` shows `(unhealthy)`), restart it:
```bash
docker restart hocai-proxy
```

## Telegram Channel Config

- Bot token in `data/openclaw.json` (`channels.telegram.botToken`)
- User allow list: `1218178358`
- Group policy: `open`, all groups allowed, require mention (`@bot`)

## Plugins

Two plugins enabled: `zai` and `litellm`. Both must be enabled for all models to function.
