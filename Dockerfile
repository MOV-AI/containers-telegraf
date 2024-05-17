ARG TELEGRAF_VERSION="1.30-alpine"
FROM telegraf:${TELEGRAF_VERSION}

# Labels
LABEL description="MOV.AI metrics collector"
LABEL maintainer="devops@mov.ai"
LABEL movai="telegraf"
LABEL environment="production"

# Copy configuration files
COPY files/telegraf_full.conf /etc/telegraf/telegraf_full.conf
COPY files/telegraf_light.conf /etc/telegraf/telegraf_light.conf
COPY files/entrypoint.sh /entrypoint.sh

ENV TELEGRAF_CONFIG_PATH /etc/telegraf/telegraf_full.conf

RUN chmod o+w /etc/telegraf/telegraf_full.conf /etc/telegraf/telegraf_light.conf \
    && rm -f /etc/telegraf/telegraf.conf \
    && chmod +x /entrypoint.sh
