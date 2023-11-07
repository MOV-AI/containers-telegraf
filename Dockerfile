ARG TELEGRAF_VERSION="1.24-alpine"
FROM telegraf:${TELEGRAF_VERSION}

# Labels
LABEL description="MOV.AI metrics collector"
LABEL maintainer="devops@mov.ai"
LABEL movai="telegraf"
LABEL environment="develop"

COPY files/telegraf.conf /etc/telegraf/telegraf.conf
COPY files/entrypoint.sh /entrypoint.sh

# Rest is upstream
