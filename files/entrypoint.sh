#!/bin/sh
set -e

# Check if linux_cpu inputs required files exist
if [ -d "/sys/devices/system/cpu/cpu0/cpufreq/" ] && [ -d "/sys/devices/system/cpu/cpu0/thermal_throttle/" ]; then
    # Enable the [[inputs.linux_cpu]] plugin
    enable_plugin=true
else
    # Disable the [[inputs.linux_cpu]] plugin
    enable_plugin=false
fi

if [ "$enable_plugin" == "true" ] && ! grep linux_cpu /etc/telegraf/telegraf.conf -q; then
    # Include the configuration for the [[inputs.linux_cpu]] plugin
    cat <<EOF > /etc/telegraf/telegraf.conf

[[inputs.linux_cpu]]
  host_sys = "/hostfs/sys"
  metrics = ["cpufreq", "thermal"]
EOF
fi

if [ "${1:0:1}" = '-' ]; then
    set -- telegraf "$@"
fi

if [ "$(id -u)" -ne 0 ]; then
    exec "$@"
else
    # Allow telegraf to send ICMP packets and bind to privliged ports
    setcap cap_net_raw,cap_net_bind_service+ep /usr/bin/telegraf || echo "Failed to set additional capabilities on /usr/bin/telegraf"

    exec su-exec telegraf "$@"
fi

