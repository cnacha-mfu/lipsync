# Use Ubuntu 22.04 with Python 3.10 for optimal compatibility
FROM ubuntu:22.04

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    DEBIAN_FRONTEND=noninteractive \
    TZ=UTC

# Set work directory
WORKDIR /app

# Install Python 3.10 and system dependencies with clock sync fix
RUN apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false && \
    apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    build-essential \
    curl \
    ffmpeg \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    libgl1-mesa-glx \
    libglib2.0-dev \
    libgtk-3-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Set python3 as default python and pip (Ubuntu 22.04 uses Python 3.10 by default)
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

# Upgrade pip to latest version
RUN python -m pip install --upgrade pip

# Copy requirements first for better caching
COPY requirements.txt .

# Create directories for model storage
RUN mkdir -p /app/models /app/data /app/output

# Copy application code first
COPY . .

# Then move any .pth files to models directory using shell commands
RUN find . -name "*.pth" -type f -exec cp {} /app/models/ \; 2>/dev/null || true

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Fix OpenCV installation issues - uninstall any existing opencv packages
RUN pip uninstall -y opencv-python opencv-contrib-python opencv-python-headless || true

# Install opencv-python-headless (best for server environments)
RUN pip install opencv-python-headless  
#==4.8.1.78

# Copy application code
COPY . .

# Create non-root user for security
RUN adduser --disabled-password --gecos '' appuser && \
    chown -R appuser:appuser /app
USER appuser

# Expose port if needed (adjust as necessary)
# EXPOSE 8000

# Default command (adjust as needed)
CMD ["python", "test.py"]
