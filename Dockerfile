ARG TELEGRAF_VERSION="1.38-alpine"
FROM telegraf:${TELEGRAF_VERSION}

ARG ENVIRONMENT="production"

# Labels
LABEL description="MOV.AI metrics collector"
LABEL maintainer="devops@mov.ai"
LABEL movai="telegraf"
LABEL environment=$ENVIRONMENT

# Install additional packages
RUN command -v apk && apk add --no-cache \
    chrony=4.6.1-r1 \
    su-exec \
    && rm -rf /var/cache/apk/*

# Copy configuration files
COPY files/telegraf_debug.conf /etc/telegraf/telegraf_debug.conf
COPY files/telegraf_production.conf /etc/telegraf/telegraf_production.conf
COPY files/entrypoint.sh /entrypoint.sh

ENV TELEGRAF_CONFIG_LEVEL=$ENVIRONMENT

RUN chmod o+w /etc/telegraf/telegraf_debug.conf /etc/telegraf/telegraf_production.conf \
    && rm -f /etc/telegraf/telegraf.conf \
    && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD [ "telegraf", "--non-strict-env-handling" ]
