.PHONY: install start stop restart status setup clean help

.DEFAULT_GOAL := help

BIN_DIR := bin
CONFIG_DIR := config

help:
	@echo "Local Fabric MCP - Available Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

install:
	@$(BIN_DIR)/install.sh

setup:
	@if [ ! -f .env ]; then cp $(CONFIG_DIR)/.env.example .env; fi

start:
	@$(BIN_DIR)/manager.sh start

stop:
	@$(BIN_DIR)/manager.sh stop

restart:
	@$(BIN_DIR)/manager.sh restart

status:
	@$(BIN_DIR)/manager.sh status

logs:
	@journalctl --user -u fabric-rest -f

clean:
	@rm -rf logs/*.log __pycache__ .pytest_cache
	@find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
