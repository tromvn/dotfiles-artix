#!/bin/sh
LOGFILE="$HOME/crash-logs/crash-$(date +%Y%m%d-%H%M%S).log"

{
    echo "=== Crash capturado: $(date) ==="
    echo ""
    echo "=== Últimas líneas de dmesg ==="
    dmesg -T | tail -50
    echo ""
    echo "=== Últimas líneas de /var/log/messages ==="
    tail -80 /var/log/messages
    echo ""
    echo "=== Xorg.0.log ==="
    tail -50 "$HOME/.local/share/xorg/Xorg.0.log" 2>/dev/null
} > "$LOGFILE"
