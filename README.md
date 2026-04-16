# containers-telegraf

Telegraf container for monitoring various services and applications.

This container is based on the official Telegraf Alpine image and provides several configuration profiles:
- **telegraf_debug.conf**: Full metrics collection (all fields enabled) - use for performance analysis and system debugging
- **telegraf_production.conf**: Optimized with fieldinclude filters for reduced ingestion - use for production monitoring with resource optimization

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
- `TELEGRAF_CONFIG_LEVEL`: the configuration profile to use (default: `production`; options: `debug`, `production`)
- `TELEGRAF_CONFIG_FILE`: override the configuration file path (default: `/etc/telegraf/telegraf_$TELEGRAF_CONFIG_LEVEL.conf`)
- `TELEGRAF_HOSTNAME`: the hostname to use in the InfluxDB output plugin (default: `telegraf`)
- `REDIS_SERVERS`: auto-detected from available Redis instances (redis-local, redis-master, redis-slave)

## Future Work

### Chrony Metrics

Docs:
    https://github.com/influxdata/telegraf/tree/master/plugins/inputs/chrony


### NVIDIA GPU Metrics
Docs:

    https://github.com/influxdata/telegraf/blob/master/plugins/inputs/nvidia_smi/README.md

Binary:

    See https://github.com/influxdata/telegraf/pull/11832/files

```yml
devices:
      - /dev/nvidiactl:/dev/nvidiactl
      - /dev/nvidia0:/dev/nvidia0
    volumes:
      - ./telegraf/etc/telegraf.conf:/etc/telegraf/telegraf.conf:ro
      - /usr/bin/nvidia-smi:/usr/bin/nvidia-smi:ro
      - /usr/lib/x86_64-linux-gnu/nvidia:/usr/lib/x86_64-linux-gnu/nvidia:ro
    environment:
      - LD_PRELOAD=/usr/lib/x86_64-linux-gnu/nvidia/current/libnvidia-ml.so
```