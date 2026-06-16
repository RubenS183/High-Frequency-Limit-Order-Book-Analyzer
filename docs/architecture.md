# System Architecture

## Overview

The HF-LOB Analyzer is a modular, layered real-time pipeline:

```
Exchanges (Binance / Coinbase / Kraken)
         │  WebSocket / REST
         ▼
┌─────────────────────┐
│   Ingestion Layer   │  ← WS client, adapters, normaliser, validator
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│  Order Book Engine  │  ← Snapshot init, incremental deltas, sequencer
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│  Feature Pipeline   │  ← Spread, imbalance, microprice, liquidity
└──────┬──────┬───────┘
       ▼      ▼
  Analytics  Signals  Backtesting
       └──────┴────────────┘
                  ▼
          Storage Layer   ← TimescaleDB + Redis + Parquet
                  ▼
          FastAPI (REST + WS)
                  ▼
          Dash Dashboard
```

## Component Responsibilities

| Component | Responsibility |
|---|---|
| `ingestion/` | Connect to exchanges, parse & normalise raw messages |
| `orderbook/` | Maintain accurate in-memory LOB state |
| `features/` | Compute microstructure features from LOB state |
| `analytics/` | Higher-level analysis and modelling |
| `signals/` | Generate actionable directional signals |
| `backtesting/` | Simulate strategy performance on historical data |
| `storage/` | Persist and retrieve all data efficiently |
| `api/` | Expose data and analytics via HTTP/WebSocket |
| `visualization/` | Real-time dashboards and charts |
| `utils/` | Shared logging, config, time, math, decorators |
