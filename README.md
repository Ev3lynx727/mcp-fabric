# Local Fabric MCP

[![Version](https://img.shields.io/badge/version-0.1.1-blue.svg)](CHANGELOG.md)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A dedicated local installation directory for Fabric MCP Server - providing AI-powered pattern processing tools for software engineering workflows.

## Version

**Current: v0.1.1** (see [CHANGELOG.md](CHANGELOG.md) for details)

## Architecture

This project implements a **dual-process architecture**:

```
┌─────────────┐      stdio       ┌──────────────┐
│  opencode   │ ◄──────────────► │  fabric-mcp  │
│   (MCP)    │                  │  (Python)    │
└─────────────┘                  └──────┬───────┝
                                          │ HTTP
                                   ┌──────▼───────┐
                                   │ fabric --serve│
                                   │   (Go CLI)    │
                                   │   port 8080   │
                                   └──────────────┘
```

- **fabric --serve**: REST API server (Go CLI) on port 8080 (default)
- **fabric-mcp**: MCP server (Python) that connects to Fabric REST API and exposes patterns as MCP tools

Both processes must be running for MCP functionality to work. The `fabric-start.sh` script manages both.

## Directory Structure

```
.
├── bin/                    # Executable scripts
│   ├── install.sh         # Installation script
│   ├── manager.sh         # Service management script
│   └── fabric-start.sh    # Dual-process starter wrapper
├── config/                 # Configuration files
│   ├── .env.example       # Environment template
│   └── systemd/           # Systemd service files
├── docs/                   # Documentation
├── logs/                   # Log files directory
├── scripts/                # Utility scripts
├── systemd/                # Systemd service files
├── Makefile               # Build automation
├── requirements.txt        # Python dependencies
└── .gitignore             # Git ignore rules
```

## Quick Start

```bash
# 1. Setup environment
make setup

# 2. Install dependencies
make install

# 3. Install and start service
./bin/manager.sh install
./bin/manager.sh start

# 4. Check status
./bin/manager.sh status
```

## Available Commands

Use the Makefile for common operations:

| Command | Description |
|---------|-------------|
| `make install` | Run the installation script |
| `make setup` | Copy environment template to .env |
| `make start` | Start the Fabric MCP service |
| `make stop` | Stop the Fabric MCP service |
| `make restart` | Restart the Fabric MCP service |
| `make status` | Check service status |
| `make clean` | Clean up temporary files |

## Requirements

- curl
- python3 (>= 3.10)
- pip
- systemd (for service management)

## Configuration

### Environment Setup

1. Copy the example environment file:
   ```bash
   make setup
   ```

2. Edit `.env` with your settings

3. The `.env` file will be automatically loaded by the wrapper script.

### OpenCode Integration

After installation, add this to your OpenCode config:

```json
"fabric": {
  "type": "local",
  "command": ["fabric-mcp", "--transport", "stdio"],
  "environment": {"FABRIC_BASE_URL": "http://127.0.0.1:8080"},
  "enabled": true
}
```

## License

See [Fabric](https://github.com/danielmiessler/fabric) and [fabric-mcp](https://github.com/ksylvan/fabric-mcp) repositories.
