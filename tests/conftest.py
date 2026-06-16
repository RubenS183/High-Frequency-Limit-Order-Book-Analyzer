"""Root pytest conftest: shared fixtures and marker registration."""
import pytest


def pytest_configure(config: pytest.Config) -> None:
    """Register custom markers."""
    config.addinivalue_line("markers", "unit: fast isolated unit tests")
    config.addinivalue_line("markers", "integration: tests requiring external services")
    config.addinivalue_line("markers", "e2e: end-to-end system tests")
    config.addinivalue_line("markers", "slow: tests taking more than 1 second")
    config.addinivalue_line("markers", "benchmark: performance benchmark tests")


@pytest.fixture
def sample_orderbook_snapshot() -> dict:
    """Minimal valid order book snapshot fixture."""
    return {
        "symbol": "BTC-USDT",
        "exchange": "binance",
        "bids": [["50000.00", "1.5"], ["49999.00", "2.0"]],
        "asks": [["50001.00", "0.8"], ["50002.00", "1.2"]],
        "timestamp": 1700000000000,
        "sequence": 1,
    }
