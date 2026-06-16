"""E2E smoke test: bring up the API and hit all key endpoints."""
import pytest


@pytest.mark.e2e
class TestApiSmoke:
    def test_placeholder(self) -> None:
        assert True
