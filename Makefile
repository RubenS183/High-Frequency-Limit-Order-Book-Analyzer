# ============================================================
# High-Frequency Limit Order Book Analyzer — Makefile
# ============================================================

.PHONY: help install install-dev install-all lint format type-check test test-unit \
        test-integration test-e2e test-coverage benchmark clean docker-build \
        docker-up docker-down docker-logs db-migrate db-upgrade db-downgrade \
        docs serve-docs

PYTHON := python3.12
PIP    := $(PYTHON) -m pip
PROJECT_NAME := hf-lob-analyzer
DOCKER_COMPOSE := docker compose

# ── Help ──────────────────────────────────────────────────
help:  ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'

# ── Installation ──────────────────────────────────────────
install:  ## Install core dependencies
	$(PIP) install -e .

install-dev:  ## Install core + dev dependencies
	$(PIP) install -e .[dev]

install-all:  ## Install all optional dependencies
	$(PIP) install -e .[all]

# ── Code Quality ──────────────────────────────────────────
lint:  ## Run ruff linter
	ruff check src/ tests/ scripts/

format:  ## Auto-format with black and isort
	black src/ tests/ scripts/
	isort src/ tests/ scripts/

format-check:  ## Check formatting without applying changes
	black --check src/ tests/ scripts/
	isort --check-only src/ tests/ scripts/

type-check:  ## Run mypy type checker
	mypy src/

# ── Testing ───────────────────────────────────────────────
test:  ## Run all tests
	pytest tests/

test-unit:  ## Run unit tests only
	pytest tests/unit/ -m unit

test-integration:  ## Run integration tests (requires services)
	pytest tests/integration/ -m integration

test-e2e:  ## Run end-to-end tests
	pytest tests/e2e/ -m e2e

test-coverage:  ## Run tests with coverage report
	pytest tests/ --cov=src/lob_analyzer --cov-report=html --cov-report=term-missing

benchmark:  ## Run benchmark tests
	pytest tests/benchmarks/ -m benchmark --benchmark-autosave

# ── Cleaning ──────────────────────────────────────────────
clean:  ## Remove build artifacts and caches
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name '*.pyc' -delete
	find . -type f -name '*.pyo' -delete
	rm -rf .mypy_cache .ruff_cache .pytest_cache htmlcov dist build *.egg-info

# ── Docker ────────────────────────────────────────────────
docker-build:  ## Build Docker images
	$(DOCKER_COMPOSE) build

docker-up:  ## Start all services in detached mode
	$(DOCKER_COMPOSE) up -d

docker-down:  ## Stop and remove containers
	$(DOCKER_COMPOSE) down

docker-logs:  ## Tail logs for all services
	$(DOCKER_COMPOSE) logs -f

docker-restart:  ## Restart a specific service (usage: make docker-restart SERVICE=api)
	$(DOCKER_COMPOSE) restart $(SERVICE)

# ── Database ──────────────────────────────────────────────
db-migrate:  ## Create a new Alembic migration
	alembic revision --autogenerate -m "$(MSG)"

db-upgrade:  ## Apply all pending migrations
	alembic upgrade head

db-downgrade:  ## Rollback one migration
	alembic downgrade -1

db-history:  ## Show migration history
	alembic history --verbose

# ── Pre-commit ────────────────────────────────────────────
pre-commit-install:  ## Install pre-commit hooks
	pre-commit install

pre-commit-run:  ## Run pre-commit on all files
	pre-commit run --all-files

# ── Docs ─────────────────────────────────────────────────
docs:  ## Build documentation (requires mkdocs)
	mkdocs build

serve-docs:  ## Serve documentation locally
	mkdocs serve
