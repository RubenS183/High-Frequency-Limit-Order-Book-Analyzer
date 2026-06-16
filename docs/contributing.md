# Contributing

## Development Setup

```bash
git clone <repo>
cd hf-lob-analyzer
make install-dev
make pre-commit-install
```

## Branch Strategy

| Branch | Purpose |
|--------|---------|
| `main` | Stable, protected — only merge via PR |
| `develop` | Integration branch |
| `feature/<name>` | New features |
| `fix/<name>` | Bug fixes |
| `perf/<name>` | Performance improvements |
| `docs/<name>` | Documentation only |

## Commit Convention

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(orderbook): add multi-level depth export
fix(ingestion): handle Binance reconnect race condition
perf(features): vectorise imbalance with numpy
docs(api): add WebSocket streaming examples
test(backtesting): add Sharpe ratio edge cases
```

## Pull Request Process

1. Branch from `develop`
2. Write tests for new functionality
3. Ensure `make lint type-check test` all pass
4. Open a PR using the provided template
5. Request review from at least one maintainer
6. Squash-merge once approved
