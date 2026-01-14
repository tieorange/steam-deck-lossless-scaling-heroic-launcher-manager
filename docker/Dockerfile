# Use Ubuntu as the base image
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    file \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    liblzma-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter
# We clone the stable branch specifically
ENV FLUTTER_HOME=/usr/local/flutter
RUN git clone -b stable https://github.com/flutter/flutter.git $FLUTTER_HOME

# Add flutter to path
ENV PATH="$FLUTTER_HOME/bin:$PATH"

# Enable linux desktop support
RUN flutter config --enable-linux-desktop

# Pre-download dependencies
RUN flutter doctor

# Create a user to avoid permission issues
# We match the uid/gid to the host user roughly (1000:1000 is common)
# But for simplicity, we'll build as root in the container and fix permissions later
WORKDIR /app

# The command to run when the container starts
CMD ["flutter", "build", "linux", "--release"]
