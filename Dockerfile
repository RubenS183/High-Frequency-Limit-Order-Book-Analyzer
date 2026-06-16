# ============================================================
# High-Frequency Limit Order Book Analyzer — Dockerfile
# Multi-stage build for lean production image
# ============================================================

# ───────────────────────────────
# Stage 1: Build / dependency resolution
# ───────────────────────────────
FROM python:3.12-slim AS builder

WORKDIR /build

# Install system build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install pip and hatch
RUN pip install --upgrade pip hatch

# Copy only dependency files first (cache-friendly)
COPY pyproject.toml requirements.txt ./

# Install project dependencies into a virtual environment
RUN python -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install -r requirements.txt

# ───────────────────────────────
# Stage 2: Production runtime
# ───────────────────────────────
FROM python:3.12-slim AS runtime

LABEL org.opencontainers.image.title="HF-LOB-Analyzer"
LABEL org.opencontainers.image.description="High-Frequency Limit Order Book Analyzer"
LABEL org.opencontainers.image.version="0.1.0"

WORKDIR /app

# Install only runtime system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy virtual environment from builder
COPY --from=builder /opt/venv /opt/venv

# Copy application source
COPY src/ ./src/
COPY alembic/ ./alembic/
COPY alembic.ini ./

# Create non-root user for security
RUN groupadd -r lob && useradd -r -g lob -d /app -s /sbin/nologin lob && \
    chown -R lob:lob /app

# Ensure venv is on PATH
ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONPATH="/app/src"

USER lob

# Health check for the API service
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

EXPOSE 8000 9090

# Default command (override per service in docker-compose)
CMD ["uvicorn", "lob_analyzer.api.main:app", "--host", "0.0.0.0", "--port", "8000"]
