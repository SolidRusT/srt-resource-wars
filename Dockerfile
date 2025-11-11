# Resource Wars - Godot Headless Server Dockerfile
# Multi-stage build: Export Godot project → Run headless server

# Stage 1: Export Godot project for Linux server
FROM barichello/godot-ci:4.2.2 AS exporter

WORKDIR /build

# Copy Godot project files
COPY godot-project/ ./

# Create export directory
RUN mkdir -p /export

# Export for Linux/X11 (headless server)
# Note: Requires export templates installed and export preset configured
RUN godot --headless --export-release "Linux/X11" /export/resource-wars-server.x86_64 || \
    godot --headless --export "Linux/X11" /export/resource-wars-server.x86_64

# Stage 2: Minimal runtime with Godot headless
FROM ubuntu:22.04

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    libgl1 \
    libglu1-mesa \
    libx11-6 \
    libxcursor1 \
    libxinerama1 \
    libxrandr2 \
    libxi6 \
    libasound2 \
    libpulse0 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy exported game server from builder
COPY --from=exporter /export/resource-wars-server.x86_64 /app/
COPY --from=exporter /build/godot-project/assets /app/assets/

# Make executable
RUN chmod +x /app/resource-wars-server.x86_64

# Expose game server ports
# 9999: Game traffic (ENet/UDP)
# 9998: Server query/status (TCP)
EXPOSE 9999/udp 9998/tcp

# Health check via TCP status port (if implemented)
# HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
#   CMD nc -z localhost 9998 || exit 1

# Run Godot server in headless mode
CMD ["/app/resource-wars-server.x86_64", "--headless", "--server"]
