"""Benchmark: orjson vs msgpack serialisation speed."""
import pytest


@pytest.mark.benchmark
def test_bench_serialization(benchmark) -> None:  # type: ignore[no-untyped-def]
    """Placeholder benchmark for serialisation performance."""
    assert True
