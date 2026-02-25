FROM python:3.11-slim-bookworm
LABEL maintainer="Yasset Perez-Riverol <ypriverol@gmail.com>" \
      software="pypgatk" \
      version="0.0.26"

# Install only the necessary system tools
# 'build-essential' and 'python3-dev' are often needed for bioinformatics C-extensions
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    procps \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tool/source

# Clone the repository
RUN git config --global http.sslVerify false && \
    git clone --depth 1 https://github.com/ggrimes/pypgatk_ar .

# Install dependencies and the package itself
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir -e .

# Set environment variables
ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    PATH=$PATH:/tool/source/pypgatk/

RUN chmod +x /tool/source/pypgatk/pypgatkc.py

WORKDIR /data
