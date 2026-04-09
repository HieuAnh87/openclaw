# HOCAI LiteLLM Proxy

## Tổng quan

Hệ thống sử dụng **LiteLLM** làm proxy để gọi các model AI từ **danglamgiau.com**, với **Nginx** đóng vai trò reverse proxy để bypass Cloudflare WAF.

```
OpenClaw → LiteLLM API → Nginx Proxy (hocai-proxy) → danglamgiau.com → OpenAI API
```

## Container

| Container | Image | Port | Trạng thái |
|-----------|-------|------|-------------|
| `hocai-proxy` | nginx:alpine | 9099 | Running |

## Models khả dụng (qua LiteLLM)

| Model | Context | Max Output |
|-------|---------|------------|
| Claude Haiku 4.5 | 200K | 8K |
| Claude Opus 4.6 | 200K | 8K |
| GPT-5.4 Mini | 400K | 128K |
| GPT-5.4 | 1.05M | 128K |
| GPT-5 | 1.05M | 128K |

## Cấu hình

### LiteLLM Provider (`data/agents/main/agent/models.json`)

```json
{
  "providers": {
    "litellm": {
      "baseUrl": "http://172.19.0.3:9099/v1",
      "apiKey": "hocai-c08c4e8f8a3a61a47c813bfdca394ab377c1f4d410d1b9a76364f93e9b2c41e0",
      "api": "openai-completions",
      "models": [...]
    }
  }
}
```

### Nginx Proxy Config (`data/hocai-nginx/nginx.conf`)

- Listen: `127.0.0.1:9099`
- Upstream: `danglamgiau.com`
- DNS Resolver: `8.8.8.8` (ipv6=off để bypass IPv6 issue)
- Header overrides để bypass Cloudflare bot detection

## Sử dụng model HOCAI

Trong agent, gọi model qua prefix `litellm/`:

```
@agent /sử dụng model litellm/claude-haiku-4-5
```

Hoặc cập nhật `data/openclaw.json` để đặt làm model mặc định.

## Docker Compose

### Khởi chạy HOCAI Proxy

```bash
# Chạy riêng
docker compose -f hocai-proxy.docker-compose.yaml up -d

# Xem log
docker logs -f hocai-proxy

# Kiểm tra health
curl http://localhost:9099/health
```

### Kiểm tra models

```bash
# Vào shell openclaw
docker exec -it openclaw-agent sh

# List models
openclaw models list --status-plain
```

## Khắc phục lỗi

### Proxy không healthy

```bash
# Restart proxy
docker restart hocai-proxy

# Kiểm tra config
docker exec hocai-proxy cat /etc/nginx/conf.d/default.conf
```

### Lỗi 403/429 từ API

- Kiểm tra API key còn hạn trong `data/agents/main/agent/models.json`
- Restart proxy để clear connection pool

### Container không start

```bash
# Xem log chi tiết
docker logs --tail 50 hocai-proxy

# Kiểm tra port đã dùng chưa
lsof -i :9099
```

## Mạng Docker

LiteLLM và OpenClaw cùng network `172.19.0.0/16`:

```
172.19.0.3  → LiteLLM
172.19.0.x  → OpenClaw
```

Kiểm tra network:
```bash
docker network inspect bridge | grep -A5 "172.19.0"
```
