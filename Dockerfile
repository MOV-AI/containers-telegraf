ARG TELEGRAF_VERSION="1.17"
FROM telegraf:${TELEGRAF_VERSION}

# Labels
LABEL description="MOV.AI metrics collector"
LABEL maintainer="devops@mov.ai"
LABEL movai="telegraf"
LABEL environment="develop"

COPY files/telegraf.conf /etc/telegraf/telegraf.conf

# Rest is upstream
