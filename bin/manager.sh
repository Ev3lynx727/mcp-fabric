#!/bin/bash
# Fabric MCP Manager Script
# Manages the Fabric REST API service

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FABRIC_DIR="$(dirname "$SCRIPT_DIR")"

case "$1" in
  start)
    systemctl --user start fabric-rest
    ;;
  stop)
    systemctl --user stop fabric-rest
    ;;
  restart)
    systemctl --user restart fabric-rest
    ;;
  status)
    systemctl --user status fabric-rest
    ;;
  install)
    mkdir -p ~/.config/systemd/user
    cp "$FABRIC_DIR/systemd/fabric-rest.service" ~/.config/systemd/user/
    systemctl --user daemon-reload
    systemctl --user enable fabric-rest
    echo "Service installed."
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|status|install}"
    exit 1
    ;;
esac
