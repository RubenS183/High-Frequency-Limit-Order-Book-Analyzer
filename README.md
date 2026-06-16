# High-Frequency Limit Order Book Analyzer

[![CI](https://github.com/yourname/hf-lob-analyzer/actions/workflows/ci.yml/badge.svg)](https://github.com/yourname/hf-lob-analyzer/actions/workflows/ci.yml)
[![Python 3.12](https://img.shields.io/badge/python-3.12-blue.svg)](https://www.python.org/downloads/release/python-3120/)
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)
[![Ruff](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/ruff/main/assets/badge/v2.json)](https://github.com/astral-sh/ruff)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> A production-grade, real-time market microstructure analysis platform for high-frequency limit order book data.  
> Ingests live WebSocket feeds from multiple exchanges, reconstructs order books tick-by-tick, computes microstructure features, generates signals, and surfaces everything through a REST + WebSocket API and an interactive dashboard.

---

## Table of Contents

- [Architecture](#architecture)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Repository Layout](#repository-layout)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Testing](#testing)
- [Docker](#docker)
- [API Reference](#api-reference)
- [Backtesting](#backtesting)
- [Contributing](#contributing)
- [License](#license)

---

## Architecture

```
Exchanges (Binance / Coinbase / Kraken)
         │  WebSocket / REST
         ▼
┌─────────────────────┐
│   Ingestion Layer   │  ← ws client, adapters, normaliser, validator
└─────────┬───────────┘
          │ canonical tick messages
          ▼
┌─────────────────────┐
│  Order Book Engine  │  ← snapshot init, incremental deltas, sequencer
└─────────┬───────────┘
          │ book state
          ▼
┌─────────────────────┐
│  Feature Pipeline   │  ← spread, imbalance, microprice, liquidity, flow
└──────┬──────┬───────┘
       │      │
       ▼      ▼
┌──────────┐ ┌──────────────┐ ┌─────────────────┐
│Analytics │ │   Signals    │ │   Backtesting    │
│  Engine  │ │  Generator   │ │     Engine       │
└──────────┘ └──────────────┘ └─────────────────┘
       │              │                │
       └──────────────┴────────────────┘
                      │
          ┌───────────▼──────────┐
          │    Storage Layer     │  ← TimescaleDB · Redis · Parquet
          └───────────┬──────────┘
                      │
          ┌───────────▼──────────┐
          │  FastAPI (REST + WS) │
          └───────────┬──────────┘
                      │
          ┌───────────▼──────────┐
          │   Dash Dashboard     │
          └──────────────────────┘
```

---

## Features

### Market Data Ingestion
- Async WebSocket connectors with auto-reconnect and heartbeat
- Exchange adapters for **Binance**, **Coinbase Advanced Trade**, **Kraken**
- Historical data replay engine (tick-accurate simulation)
- Message normalisation to canonical internal schema

### Order Book Reconstruction
- Full snapshot ingestion + incremental delta application
- Sequence number gap detection and recovery
- Thread-safe / async-safe in-memory book state
- Configurable depth levels (5 / 10 / 20 / 50)

### Feature Engineering
| Feature | Module |
|---------|--------|
| Bid-ask spread (raw, relative, effective) | `features/spread.py` |
| Order imbalance (1-level to N-level) | `features/imbalance.py` |
| Microprice (quantity-weighted mid) | `features/microprice.py` |
| Volume imbalance across depth | `features/imbalance.py` |
| Liquidity depth, market impact cost | `features/liquidity.py` |
| Trade flow toxicity, aggressor ratio | `features/trade_flow.py` |
| Intraday volatility proxies | `features/volatility.py` |

### Analytics
- Kyle λ, Amihud illiquidity, price impact curves
- VPIN, signed volume, flow toxicity (order flow)
- Roll / Glosten-Milgrom / Hasbrouck microstructure models
- Market regime detection (trending / mean-reverting / choppy)

### Signal Generation
- Imbalance-driven directional signals
- Spread compression / widening signals
- Short-horizon momentum and mean-reversion signals
- Composite signal blending with confidence filters

### Backtesting
- Event-driven engine (MarketEvent → SignalEvent → FillEvent)
- Latency, slippage, and commission simulation
- Metrics: Sharpe, Sortino, max drawdown, hit rate, turnover
- Equity curve and trade log export

### Storage
- **TimescaleDB** — tick data and order book snapshots as hypertables
- **Redis** — hot-path caching of latest book states
- **Parquet / PyArrow** — efficient offline feature storage

### API & Dashboard
- **FastAPI** REST + WebSocket endpoints
- Real-time **Dash** dashboard with Plotly charts
- Market depth ladder, spread time-series, imbalance heatmap

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Language | Python 3.12 |
| Data wrangling | Pandas 2, Polars, NumPy, PyArrow |
| Networking | websockets, aiohttp, httpx |
| API framework | FastAPI + Uvicorn |
| Database | PostgreSQL 16 + TimescaleDB |
| ORM / migrations | SQLAlchemy 2 (async) + Alembic |
| Caching | Redis 7 + hiredis |
| Serialisation | orjson, msgpack |
| Config | Pydantic Settings + python-dotenv |
| Logging | structlog + rich |
| Observability | Prometheus, OpenTelemetry, Grafana |
| Testing | pytest, pytest-asyncio, hypothesis |
| Linting | Ruff, Black, isort, mypy |
| CI/CD | GitHub Actions |
| Containers | Docker + Docker Compose |

---

## Repository Layout

```
hf-lob-analyzer/
│
├── src/lob_analyzer/           # Main package (PEP 517 src layout)
│   ├── ingestion/              # WebSocket connectors, exchange adapters, historical loaders
│   │   ├── websocket/          # Core WS client, manager, heartbeat, reconnect
│   │   ├── adapters/           # Binance, Coinbase, Kraken adapters
│   │   └── historical/         # Loader, replay engine, downloader
│   ├── orderbook/              # LOB reconstruction engine
│   ├── features/               # Microstructure feature computation
│   ├── analytics/              # Market impact, order flow, price prediction
│   ├── signals/                # Signal generation and filtering
│   ├── backtesting/            # Event-driven backtesting engine
│   ├── storage/                # DB models, repositories, cache, Parquet
│   │   ├── models/             # SQLAlchemy ORM models
│   │   └── repositories/       # Data access objects
│   ├── api/                    # FastAPI app, routers, schemas, WS endpoints
│   │   ├── routers/            # REST endpoints per domain
│   │   ├── schemas/            # Pydantic request/response models
│   │   └── websocket/          # WS streaming handlers
│   ├── visualization/          # Dash dashboard and Plotly charts
│   │   ├── dashboard/          # App factory, layout, callbacks
│   │   └── charts/             # Depth, spread, imbalance, feature charts
│   ├── cli/                    # Click CLI commands
│   └── utils/                  # Logging, config, time, math, decorators
│
├── tests/
│   ├── unit/                   # Fast, isolated unit tests
│   ├── integration/            # Tests requiring PostgreSQL and Redis
│   ├── e2e/                    # Full pipeline end-to-end tests
│   ├── benchmarks/             # pytest-benchmark performance tests
│   └── fixtures/               # Shared test data factories
│
├── notebooks/                  # Jupyter research notebooks (EDA, modelling)
│
├── configs/                    # YAML configuration files
│   ├── settings.yaml           # App defaults
│   ├── exchanges.yaml          # Exchange connection profiles
│   ├── logging.yaml            # Logging configuration
│   └── backtest.yaml           # Default backtest profile
│
├── alembic/                    # Database migration scripts
│
├── scripts/                    # Utility scripts (seed DB, download data)
│
├── data/
│   ├── raw/                    # Raw tick data (gitignored)
│   ├── processed/              # Cleaned data (gitignored)
│   ├── features/               # Feature Parquet files (gitignored)
│   └── samples/                # Small sample files for testing
│
├── infrastructure/
│   ├── postgres/               # DB init SQL
│   ├── prometheus/             # Prometheus scrape config
│   ├── grafana/                # Grafana dashboards and datasources
│   └── otel/                   # OpenTelemetry collector config
│
├── docs/                       # Project documentation (MkDocs)
│
├── .github/
│   ├── workflows/              # CI (lint + test), CD (build + push), benchmarks
│   └── ISSUE_TEMPLATE/         # Bug report and feature request templates
│
├── Dockerfile                  # Multi-stage production Docker image
├── docker-compose.yml          # Full stack: app + DB + Redis + observability
├── docker-compose.override.yml # Dev hot-reload overrides
├── Makefile                    # Developer task runner
├── pyproject.toml              # PEP 517/518 project metadata and tool config
├── requirements.txt            # Pinned production dependencies
├── alembic.ini                 # Alembic configuration
├── .env.example                # Environment variable template
├── .pre-commit-config.yaml     # Pre-commit hook configuration
└── .gitignore
```

---

## Quick Start

### 1. Clone & set up environment

```bash
git clone https://github.com/yourname/hf-lob-analyzer.git
cd hf-lob-analyzer

# Copy and edit environment variables
cp .env.example .env

# Install Python dependencies (dev extras)
make install-dev

# Install pre-commit hooks
make pre-commit-install
```

### 2. Start infrastructure

```bash
make docker-up       # Starts PostgreSQL, Redis, Prometheus, Grafana
make db-upgrade      # Run Alembic migrations
```

### 3. Start services

```bash
# API server (with hot-reload)
uvicorn lob_analyzer.api.main:app --reload

# Live ingestion process
python -m lob_analyzer.ingestion.runner

# Dashboard
python -m lob_analyzer.visualization.dashboard.app
```

### 4. Access services

| Service | URL |
|---------|-----|
| REST API | http://localhost:8000 |
| API Docs (Swagger) | http://localhost:8000/docs |
| Dashboard | http://localhost:8050 |
| Grafana | http://localhost:3000 |
| Prometheus | http://localhost:9091 |

---

## Configuration

All application settings are managed through a layered configuration system:

1. **`configs/settings.yaml`** — default values
2. **`.env`** — environment-specific overrides (secrets, hosts)
3. **Environment variables** — highest priority (for containers)

See `.env.example` for all available environment variables.

---

## Testing

```bash
make test-unit          # Fast unit tests (no external deps)
make test-integration   # Requires running PostgreSQL + Redis
make test-e2e           # Full system end-to-end tests
make test-coverage      # Generate HTML coverage report
make benchmark          # Run performance benchmarks
```

Test layout follows the source structure: each module in `src/` has a corresponding test directory under `tests/unit/test_<module>/`.

---

## Docker

```bash
make docker-build       # Build images
make docker-up          # Start all services
make docker-down        # Stop and remove containers
make docker-logs        # Tail all logs
```

The Docker Compose stack includes:
- **lob-api** — FastAPI REST + WebSocket server
- **lob-ingestion** — Live market data ingestion process
- **lob-dashboard** — Dash analytics dashboard
- **lob-postgres** — TimescaleDB (PostgreSQL 16)
- **lob-redis** — Redis 7 cache
- **lob-prometheus** — Metrics collection
- **lob-grafana** — Dashboards and alerting
- **lob-otel** — OpenTelemetry collector

---

## API Reference

Full interactive documentation is available at **http://localhost:8000/docs** when the API is running.

### Key Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/health` | Health check |
| `GET` | `/api/v1/orderbook/{exchange}/{symbol}` | Live order book state |
| `GET` | `/api/v1/features/{exchange}/{symbol}` | Latest computed features |
| `GET` | `/api/v1/signals` | Recent signal history |
| `POST` | `/api/v1/backtests` | Submit a new backtest |
| `GET` | `/api/v1/backtests/{id}/results` | Retrieve backtest results |
| `WS` | `/ws/orderbook/{exchange}/{symbol}` | Stream live order book updates |
| `WS` | `/ws/features/{exchange}/{symbol}` | Stream live feature updates |
| `WS` | `/ws/signals` | Stream generated signals |

---

## Backtesting

Run a backtest using the CLI:

```bash
lob-analyzer backtest run \
  --config configs/backtest.yaml \
  --signal imbalance \
  --output results/
```

Or programmatically:

```python
from lob_analyzer.backtesting.runner import BacktestRunner
from lob_analyzer.backtesting.engine import BacktestEngine

# Configuration and execution to be implemented
```

---

## Contributing

See [docs/contributing.md](docs/contributing.md) for the full guide.

**TL;DR:**

```bash
git checkout -b feature/my-feature develop
# ... make changes ...
make lint type-check test
git commit -m "feat(features): add VWAP deviation feature"
# Open a PR against develop
```

---

## License

MIT — see [LICENSE](LICENSE).
# High-Frequency-Limit-Order-Book-Analyzer
