 #!/bin/bash

# Function to get the total memlock of all eBPF programs
get_total_memlock() {
    sudo bpftool prog show | awk '/memlock/ {sum += $2} END {print sum}'
}

# Number of samples
SAMPLE_SECONDS=30

# Count of samples
SAMPLE_COUNT=0

# Total memlock usage
TOTAL_MEMLOCK=0

while [ $SAMPLE_COUNT -lt $SAMPLE_SECONDS ]; do
    # Get the current total memlock usage
    current_memlock=$(get_total_memlock)
    
    # Add the current memlock usage to the total memlock usage
    TOTAL_MEMLOCK=$((TOTAL_MEMLOCK + current_memlock))
    
    # Increment the sample count
    SAMPLE_COUNT=$((SAMPLE_COUNT + 1))
    
    # Sleep for 1 second
    sleep 1
done

# Calculate the average memlock usage
AVG_MEMLOCK=$((TOTAL_MEMLOCK / SAMPLE_SECONDS))

echo "Average memlock usage by eBPF programs over $SAMPLE_SECONDS seconds: $AVG_MEMLOCK bytes"

