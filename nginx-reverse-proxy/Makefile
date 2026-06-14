.PHONY: help up down logs restart clean build ssl-init

# Colors for output
RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[1;33m
NC=\033[0m # No Color

help:
	@echo "$(GREEN)Nginx Reverse Proxy - Docker Compose Commands$(NC)"
	@echo ""
	@echo "$(YELLOW)Available commands:$(NC)"
	@echo "  $(GREEN)make up$(NC)             - Start all containers"
	@echo "  $(GREEN)make down$(NC)           - Stop all containers"
	@echo "  $(GREEN)make logs$(NC)           - View container logs"
	@echo "  $(GREEN)make restart$(NC)        - Restart all services"
	@echo "  $(GREEN)make clean$(NC)          - Remove containers and volumes"
	@echo "  $(GREEN)make build$(NC)          - Build/rebuild containers"
	@echo "  $(GREEN)make ssl-init$(NC)       - Initialize SSL certificates"
	@echo "  $(GREEN)make status$(NC)         - Show services status"

up:
	@echo "$(GREEN)Starting containers...$(NC)"
	docker-compose up -d
	@echo "$(GREEN)✓ Containers started$(NC)"

ddown:
	@echo "$(YELLOW)Stopping containers...$(NC)"
	docker-compose down
	@echo "$(GREEN)✓ Containers stopped$(NC)"

logs:
	docker-compose logs -f

logs-nginx:
	docker-compose logs -f nginx

restart:
	@echo "$(YELLOW)Restarting containers...$(NC)"
	docker-compose restart
	@echo "$(GREEN)✓ Containers restarted$(NC)"

clean:
	@echo "$(RED)Removing containers and volumes...$(NC)"
	docker-compose down -v
	@echo "$(GREEN)✓ Cleanup complete$(NC)"

build:
	@echo "$(GREEN)Building containers...$(NC)"
	docker-compose build --no-cache
	@echo "$(GREEN)✓ Build complete$(NC)"

ssl-init:
	@echo "$(YELLOW)Initializing SSL certificates...$(NC)"
	mkdir -p ./nginx/ssl/letsencrypt/live
	@echo "$(GREEN)✓ SSL directory created$(NC)"

status:
	docker-compose ps
