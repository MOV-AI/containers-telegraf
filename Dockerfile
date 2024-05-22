ARG TELEGRAF_VERSION="1.30-alpine"
FROM telegraf:${TELEGRAF_VERSION}

ARG ENVIRONMENT="production"

# Labels
LABEL description="MOV.AI metrics collector"
LABEL maintainer="devops@mov.ai"
LABEL movai="telegraf"
LABEL environment=$ENVIRONMENT

# Copy configuration files
COPY files/telegraf_debug.conf /etc/telegraf/telegraf_debug.conf
COPY files/telegraf_production.conf /etc/telegraf/telegraf_production.conf
COPY files/entrypoint.sh /entrypoint.sh

ENV TELEGRAF_CONFIG_LEVEL $ENVIRONMENT

RUN chmod o+w /etc/telegraf/telegraf_debug.conf /etc/telegraf/telegraf_production.conf \
    && rm -f /etc/telegraf/telegraf.conf \
    && chmod +x /entrypoint.sh
