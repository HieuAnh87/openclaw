# OpenClaw Telegram Agent

Agent AI Telegram được quản lý bằng Docker, sử dụng [OpenClaw](https://github.com/openclaw/openclaw) với API của Z.ai.

## Tính năng

- 🤖 Agent AI chạy 24/7 trong Docker container
- 💬 Giao tiếp qua Telegram bot
- 🌐 WebUI dashboard tại `http://localhost:18789`
- 🔧 Management script cho các thao tác phổ biến
- 📁 Cron jobs, flows, và persistent memory

## Yêu cầu

- Docker Desktop (macOS, Linux, Windows)
- Z.ai API Key

## Cài đặt nhanh

```bash
# Chạy script setup (1 lần duy nhất)
./setup.sh

# Sau đó khởi chạy agent
./openclaw-agent.sh start
```

## Quản lý Agent

```bash
./openclaw-agent.sh start      # Khởi chạy
./openclaw-agent.sh stop        # Dừng
./openclaw-agent.sh restart     # Khởi động lại
./openclaw-agent.sh status      # Kiểm tra trạng thái
./openclaw-agent.sh logs        # Xem log (real-time)
./openclaw-agent.sh doctor      # Chẩn đoán lỗi
./openclaw-agent.sh webui        # Mở WebUI
./openclaw-agent.sh shell       # Vào container shell
```

## Cấu trúc thư mục

```
openclaw/
├── docker-compose.yml           # OpenClaw agent + HOCAI Nginx proxy
├── setup.sh                     # Script setup ban đầu
├── openclaw-agent.sh            # Script quản lý agent
├── data/
│   ├── agents/                  # Agent configs & sessions
│   ├── channels/                # Channel configs (Telegram)
│   ├── completions/            # Shell completion scripts
│   ├── cron/                   # Cron jobs
│   ├── flows/                  # Workflow definitions
│   ├── hocai-nginx/            # Nginx configuration
│   ├── memory/                 # Persistent memory
│   ├── media/                  # Media files
│   ├── tasks/                  # Task queue
│   └── workspace/              # Agent workspace
└── README.md
```

## API Key

Lấy API key từ [z.ai](https://z.ai), sau đó cập nhật trong `docker-compose.yml`:

```yaml
environment:
  - ZAI_API_KEY=YOUR_API_KEY_HERE
```

## Telegram Bot Setup

1. Mở [@BotFather](https://t.me/BotFather) trong Telegram
2. Tạo bot mới: `/newbot`
3. Lấy token và cập nhật vào `data/channels/telegram.json`
4. Cài đặt privacy: `/setprivacy` → Disable (để bot đọc tin nhắn trong group)

## WebUI

Truy cập tại: `http://localhost:18789`

- Token xem trong `data/openclaw.json`
- Hoặc xem trong terminal sau khi khởi chạy

## Cron Jobs

Cron jobs được lưu tại `data/cron/jobs.json`.

## Lưu ý

- Volume mount sử dụng `/home/node/.openclaw` (không phải `/root/.openclaw`)
- Gateway bind ra `0.0.0.0` để truy cập từ host
- Mặc định **không commit** các file trong `data/` (sessions, logs, credentials)
