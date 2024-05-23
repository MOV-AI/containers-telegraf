# containers-telegraf

Telegraf container for monitoring various services and applications.

This container is based on the official Telegraf Alpine image and provides 2 configuration files:
- telegraf_debug.conf: a configuration file with debug metrics collection and a 10s interval
- telegraf_production.conf: a configuration file with minimal metrics collection and a 30s interval

Dynamic detection of host comptability for the following plugins:
- [[inputs.linux_cpu]] cpufreq plugin
- [[inputs.linux_cpu]] thermal plugin

## Usage

### Build the container

```bash
docker build -t telegraf .
```

### Runtime configuration

Environment variables:
- `TELEGRAF_CONFIG_LEVEL`: the configuration level to use (default: `production`)
- `TELEGRAF_CONFIG_FILE`: the configuration file to use (default: `/etc/telegraf/telegraf_$TELEGRAF_CONFIG_LEVEL.conf`)
- `TELEGRAF_HOSTNAME`: the hostname to use in the InfluxDB output plugin (default: `telegraf`)
- `CHRONY_URL`: the URL of the Chrony server to monitor (default: disabled)
- `HA_PROXY_URL`: the URL of the HAProxy server to monitor (default: disabled)

## Future Work

### Chrony Metrics

Docs:
    https://github.com/influxdata/telegraf/tree/master/plugins/inputs/chrony


### NVIDIA GPU Metrics
Docs:

    https://github.com/influxdata/telegraf/blob/master/plugins/inputs/nvidia_smi/README.md

Binary:

    See https://github.com/influxdata/telegraf/pull/11832/files

devices:
      - /dev/nvidiactl:/dev/nvidiactl
      - /dev/nvidia0:/dev/nvidia0
    volumes:
      - ./telegraf/etc/telegraf.conf:/etc/telegraf/telegraf.conf:ro
      - /usr/bin/nvidia-smi:/usr/bin/nvidia-smi:ro
      - /usr/lib/x86_64-linux-gnu/nvidia:/usr/lib/x86_64-linux-gnu/nvidia:ro
    environment:
      - LD_PRELOAD=/usr/lib/x86_64-linux-gnu/nvidia/current/libnvidia-ml.so