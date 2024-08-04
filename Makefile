# Makefile for managing Prometheus services with Docker Compose

# Default environment variables
PROMETHEUS_WRITER_HOSTNAME ?= prometheus_writer
PROMETHEUS_READER_HOSTNAME ?= prometheus_reader
PROMETHEUS_WRITER_PORT ?= 9090
PROMETHEUS_READER_PORT ?= 9091
PROMETHEUS_REMOTE_WRITE_HANDLER ?= http://host.docker.internal:8053/write
PROMETHEUS_REMOTE_READ_HANDLER ?= http://host.docker.internal:8053/read
CLICKHOUSE_SERVER_BINARY ?= clickhouse-server

export PROMETHEUS_WRITER_HOSTNAME
export PROMETHEUS_READER_HOSTNAME
export PROMETHEUS_WRITER_PORT
export PROMETHEUS_READER_PORT
export PROMETHEUS_REMOTE_WRITE_HANDLER
export PROMETHEUS_REMOTE_READ_HANDLER
export CLICKHOUSE_BINARY

# Docker Compose file
DOCKER_COMPOSE_FILE = docker-compose.yml

# Default target
.PHONY: all
all: up

.PHONY: clickhouse
clickhouse:
	@$(CLICKHOUSE_SERVER_BINARY)

# Start services
.PHONY: up
up:
	@echo "Starting services..."
	@docker-compose -f $(DOCKER_COMPOSE_FILE) up -d

# Stop services
.PHONY: down
down:
	@echo "Stopping services..."
	@docker-compose -f $(DOCKER_COMPOSE_FILE) down

# Restart services
.PHONY: restart
restart: down up

# View logs
.PHONY: logs
logs:
	@docker-compose -f $(DOCKER_COMPOSE_FILE) logs -f

# Remove all containers, networks, and volumes
.PHONY: clean
clean:
	@echo "Cleaning up..."
	@docker-compose -f $(DOCKER_COMPOSE_FILE) down --volumes --remove-orphans

# Check the status of services
.PHONY: ps
ps:
	@docker-compose -f $(DOCKER_COMPOSE_FILE) ps

# Check the health of services
.PHONY: healthcheck
healthcheck:
	@curl -f "http://localhost:${PROMETHEUS_WRITER_PORT}/api/v1/status/runtimeinfo" || echo "Prometheus Writer is not healthy!"
	@curl -f "http://localhost:${PROMETHEUS_READER_PORT}/api/v1/status/runtimeinfo" || echo "Prometheus Reader is not healthy!"