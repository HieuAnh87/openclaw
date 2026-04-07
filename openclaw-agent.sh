#!/bin/bash
# OpenClaw Telegram Agent - Management Script

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

case "$1" in
    start)
        echo "🚀 Starting OpenClaw..."
        docker compose up -d
        ;;
    stop)
        echo "🛑 Stopping OpenClaw..."
        docker compose down
        ;;
    restart)
        echo "🔄 Restarting OpenClaw..."
        docker compose restart
        ;;
    status)
        docker ps --filter "name=openclaw-agent"
        echo ""
        docker exec openclaw-agent openclaw agent status 2>/dev/null || echo "Agent status unavailable"
        ;;
    logs)
        docker compose logs -f
        ;;
    logs-no-follow)
        docker compose logs
        ;;
    doctor)
        docker exec openclaw-agent openclaw doctor --non-interactive
        ;;
    add-task)
        TASK="$2"
        if [ -z "$TASK" ]; then
            echo "Usage: $0 add-task \"mô tả task\""
            exit 1
        fi
        TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%S+07:00")
        TASK_ID="task-$(date +%s)"
        # Thêm task vào HEARTBEAT.md
        sed -i '' "s/## Pending Tasks/## Pending Tasks\n\n- id: $TASK_ID\n  status: pending\n  priority: normal\n  description: $TASK\n  created: $(date +%Y-%m-%d)/" data/tasks/HEARTBEAT.md
        sed -i '' "s/Last heartbeat:.*/Last heartbeat: $TIMESTAMP/" data/tasks/HEARTBEAT.md
        echo "✅ Task added: $TASK"
        ;;
    webui)
        echo "🌐 Opening WebUI..."
        open http://localhost:18789
        ;;
    shell)
        docker exec -it openclaw-agent sh
        ;;
    *)
        echo "OpenClaw Agent Management"
        echo "========================="
        echo ""
        echo "Usage: $0 <command>"
        echo ""
        echo "Commands:"
        echo "  start         Khởi chạy agent"
        echo "  stop          Dừng agent"
        echo "  restart       Khởi động lại agent"
        echo "  status        Kiểm tra trạng thái"
        echo "  logs          Xem log (real-time)"
        echo "  doctor        Chẩn đoán lỗi"
        echo "  add-task      Thêm task vào queue"
        echo "  webui         Mở WebUI"
        echo "  shell         Vào container shell"
        echo ""
        ;;
esac
