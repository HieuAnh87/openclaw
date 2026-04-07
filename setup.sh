#!/bin/bash
# OpenClaw Telegram Agent - Setup Script
# Chạy script này 1 lần duy nhất để khởi tạo

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "🚀 OpenClaw Telegram Agent Setup"
echo "================================"

# 1. Check Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker chưa được cài đặt."
    echo "   Cài Docker Desktop: https://docs.docker.com/desktop/install/mac-install/"
    exit 1
fi

if ! docker info &> /dev/null; then
    echo "❌ Docker chưa chạy. Mở Docker Desktop trước."
    exit 1
fi

echo "✅ Docker đã sẵn sàng"

# 2. Check docker-compose
if ! command -v docker &> /dev/null; then
    echo "⚠️  Sử dụng 'docker compose' (v2)"
fi

# 3. Tạo thư mục nếu chưa có
mkdir -p data/{channels,agents,skills,tasks,workspace}

# 4. Kiểm tra config
echo ""
echo "📋 Kiểm tra config files..."
if [ -f data/openclaw.json ]; then
    echo "   ✅ openclaw.json"
fi
if [ -f data/channels/telegram.json ]; then
    echo "   ✅ telegram.json"
fi

# 5. Khởi chạy
echo ""
echo "▶️  Khởi chạy OpenClaw..."
docker compose up -d

echo ""
echo "✅ Setup hoàn tất!"
echo ""
echo "📝 Tiếp theo:"
echo "   1. Mở @BotFather → /setprivacy → Disable (để bot đọc tin nhắn trong group)"
echo "   2. Thêm bot vào group Telegram"
echo "   3. Xem log: ./openclaw-agent.sh logs"
echo "   4. Test: @mention bot trong group"
echo ""
echo "🌐 WebUI: http://localhost:18789"
