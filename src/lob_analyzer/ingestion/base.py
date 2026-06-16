"""Abstract base classes for all ingestion components."""
from __future__ import annotations

from abc import ABC, abstractmethod
from typing import AsyncIterator


class BaseConnector(ABC):
    """Abstract base for all market data connectors."""

    @abstractmethod
    async def connect(self) -> None:
        """Establish connection to data source."""
        raise NotImplementedError

    @abstractmethod
    async def disconnect(self) -> None:
        """Gracefully close the connection."""
        raise NotImplementedError

    @abstractmethod
    async def subscribe(self, symbols: list[str]) -> None:
        """Subscribe to market data for given symbols."""
        raise NotImplementedError

    @abstractmethod
    def stream(self) -> AsyncIterator[dict]:
        """Yield raw market data messages as they arrive."""
        raise NotImplementedError
