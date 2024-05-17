#!/bin/sh
set -e

# Check if linux_cpu inputs required files exist
enable_plugin_cpufreq=false
cpu_freq_files="affected_cpus base_frequency cpuinfo_max_freq cpuinfo_min_freq cpuinfo_transition_latency energy_performance_available_preferences energy_performance_preference related_cpus scaling_available_governors scaling_cur_freq scaling_driver scaling_governor scaling_max_freq scaling_min_freq scaling_setspeed"
if [ -d "/sys/devices/system/cpu/cpu0/cpufreq/" ] ; then
    # Enable the [[inputs.linux_cpu]] cpufreq plugin
    enable_plugin_cpufreq=true
    for file in $cpu_freq_files; do
        if ! [ -f "/sys/devices/system/cpu/cpu0/cpufreq/$file" ]; then
            enable_plugin_cpufreq=false
            break
        fi
    done
fi

enable_plugin_thermalthrottle=false
thermal_throttle_files="core_throttle_count core_throttle_max_time_ms core_throttle_total_time_ms package_throttle_count package_throttle_max_time_ms package_throttle_total_time_ms"
if [ -d "/sys/devices/system/cpu/cpu0/thermal_throttle/" ]; then
    # Enable the [[inputs.linux_cpu]] thermal plugin
    enable_plugin_thermalthrottle=true
    for file in $thermal_throttle_files; do
        if ! [ -f "/sys/devices/system/cpu/cpu0/thermal_throttle/$file" ]; then
            enable_plugin_thermalthrottle=false
            break
        fi
    done
fi

metrics=""
if [ "$enable_plugin_cpufreq" = "true" ]; then
    metrics="\"cpufreq\""
fi
if [ "$enable_plugin_thermalthrottle" = "true" ]; then
    metrics="${metrics},\"thermal\""
fi

if [ -n "$metrics" ] && ! grep linux_cpu $TELEGRAF_CONFIG_PATH -q; then
    # Include the configuration for the [[inputs.linux_cpu]] plugin
    cat <<EOF >> $TELEGRAF_CONFIG_PATH

[[inputs.linux_cpu]]
  host_sys = "/hostfs/sys"
  metrics = [$metrics]
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

