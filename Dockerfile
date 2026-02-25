FROM debian:bookworm
LABEL maintainer="Yasset Perez-Riverol <ypriverol@gmail.com>" \
      software="pypgatk" \
      software.version="0.0.26" \
      version="1"

# Combine updates and installs to minimize layers
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-setuptools \
    git \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Set up working directories
WORKDIR /tool/source

# Clone and install
# Note: Added --break-system-packages for Debian Bookworm compatibility with global pip
RUN git config --global http.sslVerify false && \
    git clone --depth 1 https://github.com/ggrimes/pypgatk_ar . && \
    pip3 install --no-cache-dir --break-system-packages -r requirements.txt && \
    pip3 install --no-cache-dir --break-system-packages -e . && \
    rm -rf .git

# Environment setup
ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    PATH=$PATH:/tool/source/pypgatk/

RUN chmod +x /tool/source/pypgatk/pypgatkc.py

WORKDIR /data
