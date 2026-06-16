# Exchange Adapters

## Supported Exchanges

| Exchange | Status | Markets | Adapter |
|---|---|---|---|
| Binance | ✅ Planned | Spot, Futures | `adapters/binance.py` |
| Coinbase Advanced Trade | ✅ Planned | Spot | `adapters/coinbase.py` |
| Kraken | ✅ Planned | Spot | `adapters/kraken.py` |

## Adding a New Exchange

1. Create `src/lob_analyzer/ingestion/adapters/<exchange>.py`
2. Subclass `BaseConnector` from `ingestion/base.py`
3. Implement `connect()`, `disconnect()`, `subscribe()`, `stream()`
4. Add normalisation logic to map raw messages to canonical schema
5. Register the adapter in `configs/exchanges.yaml`
6. Write integration tests in `tests/integration/test_ingestion/`
