#!/bin/bash

# Đặt tên cho pod và container
POD_NAME="my-pod"
CONTAINER_NAME="my-container"

# Số giây mẫu
SAMPLE_SECONDS=30

# Đếm số lần mẫu
SAMPLE_COUNT=0

# Tổng CPU
TOTAL_CPU=0

while [ $SAMPLE_COUNT -lt $SAMPLE_SECONDS ]; do
    # Lấy thông tin sử dụng tài nguyên của container
    TOP_OUTPUT=$(kubectl top pod $POD_NAME --containers)
    
    # Lọc ra dòng chứa tên container và lấy giá trị sử dụng CPU
    CPU_USAGE=$(echo "$TOP_OUTPUT" | grep $CONTAINER_NAME | awk '{print $3}' | sed 's/m//')

    # Cộng giá trị sử dụng CPU của lần mẫu hiện tại vào tổng CPU
    TOTAL_CPU=$(echo "$TOTAL_CPU + $CPU_USAGE" | bc)

    # Tăng giá trị của SAMPLE_COUNT lên 1 và dừng 1 giây trước khi thực hiện lần mẫu tiếp theo
    SAMPLE_COUNT=$((SAMPLE_COUNT + 1))
    sleep 1
done

# Tính giá trị trung bình của sử dụng CPU
AVG_CPU=$(echo "scale=2; $TOTAL_CPU / $SAMPLE_SECONDS" | bc)

echo "Average CPU usage of container $CONTAINER_NAME in pod $POD_NAME over $SAMPLE_SECONDS seconds: $AVG_CPU mCPU"
