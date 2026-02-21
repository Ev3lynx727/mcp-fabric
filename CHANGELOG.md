# Changelog

All notable changes to this project will be documented in this file.

## [0.1.1] - 2026-02-21

### Added
- Dual-process architecture for Fabric MCP integration
- REST API server (`fabric --serve`) on port 8080
- MCP server bridge (`fabric-mcp`) for OpenCode integration
- Systemd service support for automatic startup
- Fashionable installation script with colored output
- Makefile for common operations
- Environment configuration with .env support
- 160+ Fabric patterns available
- 44+ AI models supported

### Configuration
- FABRIC_PORT: 8080 (default)
- FABRIC_BASE_URL: http://127.0.0.1:8080
- OpenCode integration via fabric-mcp --transport stdio

### Dependencies
- fabric CLI (Go)
- fabric-mcp 1.0.3 (Python)
- FastMCP 3.x (Python)
- Python 3.11+

### Known Issues
- fabric-mcp requires Python 3.11+ for FastMCP 3.x support

---

## [0.1.0] - 2026-02-20

### Added
- Initial project setup
- Basic installation scripts
- Configuration templates
