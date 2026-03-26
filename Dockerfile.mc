FROM itzg/minecraft-server:java21

USER root

# Install needed tools
RUN apt-get update \
    && apt-get install -y tzdata rsync jq cron \
    && rm -rf /var/lib/apt/lists/*

# Set timezone (important for cron + countdown)
ENV TZ=America/Toronto

# Copy cron jobs
COPY crontabs /etc/cron.d/
RUN chmod 644 /etc/cron.d/*

# Copy your scripts
COPY scripts/server /server-scripts
RUN mkdir -p /server-scripts \
    && chmod +x /server-scripts

WORKDIR /data