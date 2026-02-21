#!/usr/bin/env bash
#
# Fabric MCP Installation Script
# Elegant. Modern. Professional.
#

set -euo pipefail

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly MAGENTA='\033[0;35m'
readonly NC='\033[0m'
readonly BOLD='\033[1m'

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[✓]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[⚠]${NC} $*"; }
log_error() { echo -e "${RED}[✗]${NC} $*" 1>&2; }

print_banner() {
    cat << 'EOF'

  ╔═══════════════════════════════════════════════════════════╗
  ║                                                           ║
  ║      🧵 Fabric MCP Installer                             ║
  ║      AI Pattern Processing for Modern Workflows          ║
  ║                                                           ║
  ╚═══════════════════════════════════════════════════════════╝

EOF
}

FABRIC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FABRIC_PORT="${FABRIC_PORT:-8080}"

check_dependencies() {
    local deps=("curl" "python3" "pip")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            log_error "Missing dependency: $dep"
            exit 1
        fi
    done
    log_success "All prerequisites met"
}

install_fabric_ai() {
    if command -v fabric &> /dev/null; then
        log_warn "Fabric AI already installed"
        return 0
    fi
    log_info "Downloading Fabric AI from GitHub..."
    if curl -fsSL https://raw.githubusercontent.com/danielmiessler/fabric/main/scripts/installer/install.sh | bash; then
        log_success "Fabric AI installed"
    else
        log_error "Fabric AI installation failed"
        exit 1
    fi
}

install_fabric_mcp() {
    local python_bin=""
    if command -v python3.13 &> /dev/null; then
        python_bin="python3.13"
    elif command -v python3 &> /dev/null; then
        python_bin="python3"
    else
        log_error "Python 3 not found"
        exit 1
    fi
    
    log_info "Installing FastMCP and fabric-mcp..."
    "$python_bin" -m pip install --upgrade fastmcp fabric-mcp -q
    log_success "fabric-mcp installed"
}

main() {
    print_banner
    check_dependencies
    install_fabric_ai
    install_fabric_mcp
    echo
    echo -e "${GREEN}✨ Installation Complete!${NC}"
    echo
    echo -e "${CYAN}Next Steps:${NC}"
    echo -e "  1. Run ${BOLD}make setup${NC} to create .env file"
    echo -e "  2. Edit ${BOLD}.env${NC} with your API keys"
    echo -e "  3. Run ${BOLD}./bin/manager.sh start${NC} to start the service"
    echo
}

main "$@"
