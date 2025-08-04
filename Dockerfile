# Use Python 3.12 slim image as base (latest stable version)
FROM python:3.12-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .
# Create directories for model storage
RUN mkdir -p /app/models /app/data /app/output

# Copy all .pth model files to the models directory
COPY *.pth /app/models/

# Copy .pth files from subdirectories (if any)
COPY **/*.pth /app/models/ 2>/dev/null || true
COPY models/*.pth /app/models/ 2>/dev/null || true
# COPY checkpoints/*.pth /app/models/ 2>/dev/null || true



# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create non-root user for security
RUN adduser --disabled-password --gecos '' appuser && \
    chown -R appuser:appuser /app
USER appuser

