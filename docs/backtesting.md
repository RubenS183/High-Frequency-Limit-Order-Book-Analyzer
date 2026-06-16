# Backtesting Guide

## Overview

The backtesting engine is event-driven and processes historical data
tick-by-tick through four event types:

```
MarketEvent → SignalEvent → OrderEvent → FillEvent
```

## Running a Backtest

### Via CLI

```bash
lob-analyzer backtest run \
  --config configs/backtest.yaml \
  --signal imbalance \
  --output results/
```

### Via Python API

```python
from lob_analyzer.backtesting.runner import BacktestRunner

runner = BacktestRunner.from_config("configs/backtest.yaml")
results = runner.run()
results.summary()          # Print metrics table
results.plot_equity()      # Interactive Plotly chart
results.export("results/") # Save CSV + Parquet
```

## Performance Metrics

| Metric | Description |
|---|---|
| Sharpe Ratio | Annualised risk-adjusted return |
| Sortino Ratio | Downside-risk-adjusted return |
| Max Drawdown | Peak-to-trough equity decline |
| Hit Rate | Fraction of profitable trades |
| Turnover | Average daily portfolio turnover |
| PnL | Gross and net profit/loss |
