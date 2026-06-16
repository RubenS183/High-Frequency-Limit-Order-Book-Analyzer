# Getting Started

## Prerequisites

- Python 3.12+
- Docker & Docker Compose
- PostgreSQL 16+ with TimescaleDB (or use the Docker setup)
- Redis 7+

## Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/yourname/hf-lob-analyzer.git
cd hf-lob-analyzer

# 2. Copy and configure environment
cp .env.example .env
# Edit .env with your credentials

# 3. Start infrastructure
make docker-up

# 4. Install Python dependencies (dev mode)
make install-dev

# 5. Run database migrations
make db-upgrade

# 6. Start the API server (hot-reload)
uvicorn lob_analyzer.api.main:app --reload

# 7. Start the ingestion process
python -m lob_analyzer.ingestion.runner

# 8. Start the dashboard
python -m lob_analyzer.visualization.dashboard.app
```

## Running Tests

```bash
make test-unit          # Fast unit tests — no external services needed
make test-integration   # Requires running PostgreSQL + Redis
make test-coverage      # Full coverage report in htmlcov/
make benchmark          # Performance benchmarks
```

## Service URLs

| Service | URL |
|---------|-----|
| REST API | http://localhost:8000 |
| Swagger UI | http://localhost:8000/docs |
| Dashboard | http://localhost:8050 |
| Grafana | http://localhost:3000 |
| Prometheus | http://localhost:9091 |
