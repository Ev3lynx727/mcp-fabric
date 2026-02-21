#!/usr/bin/env bash
#
# Fabric MCP Starter
# Starts both fabric --serve and fabric-mcp
#

set -euo pipefail

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly MAGENTA='\033[0;35m'
readonly NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[✓]${NC} $*"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FABRIC_DIR="$(dirname "$SCRIPT_DIR")"

FABRIC_PORT="${FABRIC_PORT:-8080}"
FABRIC_BASE_URL="${FABRIC_BASE_URL:-http://127.0.0.1:8080}"

export FABRIC_BASE_URL

load_env() {
    if [ -f "$FABRIC_DIR/.env" ]; then
        set -a
        source "$FABRIC_DIR/.env"
        set +a
    fi
}

cleanup() {
    if [ -n "${FABRIC_PID:-}" ]; then
        kill "$FABRIC_PID" 2>/dev/null || true
    fi
    exit 0
}

trap cleanup SIGINT SIGTERM

wait_for_fabric() {
    log_info "Waiting for Fabric REST API..."
    local max_retries=30
    local retry_count=0
    
    while [ $retry_count -lt $max_retries ]; do
        if curl -sf "$FABRIC_BASE_URL/patterns/names" >/dev/null 2>&1; then
            log_success "Fabric REST API is ready!"
            return 0
        fi
        retry_count=$((retry_count + 1))
        sleep 1
    done
    return 1
}

main() {
    echo -e "${MAGENTA}🧵 Fabric MCP Starter${NC}"
    echo
    
    load_env
    
    log_info "Starting Fabric REST API on port $FABRIC_PORT..."
    fabric --serve --address ":$FABRIC_PORT" &
    FABRIC_PID=$!
    
    log_success "Fabric REST API started (PID: $FABRIC_PID)"
    
    if ! wait_for_fabric; then
        kill "$FABRIC_PID" 2>/dev/null || true
        exit 1
    fi
    
    echo
    log_info "Starting fabric-mcp..."
    exec fabric-mcp --stdio
}

main "$@"
