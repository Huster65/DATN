#!/bin/bash

POD_NAME="my-pod"
CONTAINER_NAME="my-container"

# Số giây mẫu
SAMPLE_SECONDS=30

# Đếm số lần mẫu
SAMPLE_COUNT=0

# Tổng CPU
TOTAL_CPU=0

while [ $SAMPLE_COUNT -lt $SAMPLE_SECONDS ]; do
    TOP_OUTPUT=$(kubectl top pod $POD_NAME --containers)
    CPU_USAGE=$(echo "$TOP_OUTPUT" | grep $CONTAINER_NAME | awk '{print $2}')

    TOTAL_CPU=$(echo "$TOTAL_CPU + $CPU_USAGE" | bc)

    SAMPLE_COUNT=$((SAMPLE_COUNT + 1))
    sleep 1
done

AVG_CPU=$(echo "scale=2; $TOTAL_CPU / $SAMPLE_SECONDS" | bc)
CPU_PERCENT=$(echo "scale=2; $AVG_CPU * 100 / 1" | bc)

echo "Average CPU usage of container $CONTAINER_NAME in pod $POD_NAME over $SAMPLE_SECONDS seconds: $CPU_PERCENT %"
