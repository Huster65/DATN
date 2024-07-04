#!/bin/bash

# Function to get the total run_time_ns of all eBPF programs
get_total_runtime_ns() {
    sudo bpftool prog show | awk '/run_time_ns/ {sum += $2} END {print sum}'
}

# Get initial total runtime
initial_runtime=$(get_total_runtime_ns)

# Sleep for 30 seconds
sleep 30

# Get total runtime after 30 seconds
final_runtime=$(get_total_runtime_ns)

# Calculate the difference in runtime
runtime_diff=$((final_runtime - initial_runtime))

# Convert 30 seconds to nanoseconds
interval_ns=$((30 * 1000000000))

# Calculate CPU usage percentage
cpu_usage=$(echo "scale=2; ($runtime_diff / $interval_ns) * 100" | bc)

# Print the CPU usage percentage
echo "CPU usage by eBPF programs: $cpu_usage%"
