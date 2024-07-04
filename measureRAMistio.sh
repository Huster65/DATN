#!/bin/bash

POD_NAME="my-pod"
CONTAINER_NAME="my-container"

# Số giây mẫu
SAMPLE_SECONDS=30

# Đếm số lần mẫu
SAMPLE_COUNT=0

# Tổng RAM
TOTAL_RAM=0

while [ $SAMPLE_COUNT -lt $SAMPLE_SECONDS ]; do
    TOP_OUTPUT=$(kubectl top pod $POD_NAME --containers)
    RAM_USAGE=$(echo "$TOP_OUTPUT" | grep $CONTAINER_NAME | awk '{print $3}')

    # Xử lý đơn vị RAM và chuyển đổi thành MiB
    if [[ $RAM_USAGE == *'Mi'* ]]; then
        RAM_USAGE_MB=$(echo $RAM_USAGE | sed 's/Mi//g' | bc)
    elif [[ $RAM_USAGE == *'Gi'* ]]; then
        RAM_USAGE_MB=$(echo "($RAM_USAGE) * 1024" | bc)
    else
        echo "Unknown RAM unit for $RAM_USAGE"
        exit 1
    fi

    TOTAL_RAM=$(echo "$TOTAL_RAM + $RAM_USAGE_MB" | bc)

    SAMPLE_COUNT=$((SAMPLE_COUNT + 1))
    sleep 1
done

AVG_RAM=$(echo "scale=2; $TOTAL_RAM / $SAMPLE_SECONDS" | bc)
echo "Average RAM usage of container $CONTAINER_NAME in pod $POD_NAME over $SAMPLE_SECONDS seconds: $AVG_RAM MiB"
