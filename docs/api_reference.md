# API Reference

Full interactive documentation: **http://localhost:8000/docs**

## Order Book Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/api/v1/orderbook/{exchange}/{symbol}` | Current order book state |
| `GET` | `/api/v1/orderbook/{exchange}/{symbol}/depth` | Aggregated depth |
| `GET` | `/api/v1/orderbook/{exchange}/{symbol}/history` | Historical snapshots |

## Feature Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/api/v1/features/{exchange}/{symbol}` | Latest feature vector |
| `GET` | `/api/v1/features/{exchange}/{symbol}/history` | Feature time series |

## Signal Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/api/v1/signals` | Recent signals |
| `GET` | `/api/v1/signals/{signal_id}` | Single signal detail |

## Backtest Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `POST` | `/api/v1/backtests` | Submit a new backtest |
| `GET` | `/api/v1/backtests/{id}` | Backtest status |
| `GET` | `/api/v1/backtests/{id}/results` | Full results |

## WebSocket Streams

| Path | Description |
|------|-------------|
| `WS /ws/orderbook/{exchange}/{symbol}` | Live order book updates |
| `WS /ws/features/{exchange}/{symbol}` | Live feature updates |
| `WS /ws/signals` | Live signal stream |

## Health

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/health` | Liveness probe |
| `GET` | `/ready` | Readiness probe |
