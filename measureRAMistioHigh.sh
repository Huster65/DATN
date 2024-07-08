#!/bin/bash

# Tên của pod và container sidecar
POD_NAME=hello-pod
CONTAINER_NAME=istio-proxy
NAMESPACE=default

# Thời gian theo dõi (30 giây)
DURATION=30

# Thời gian giữa các lần lấy mẫu (1 giây)
INTERVAL=1

# Biến để theo dõi tổng lượng RAM tiêu thụ và số lần lấy mẫu
total_memory_usage=0
sample_count=0

# Hàm để lấy lượng RAM tiêu thụ của container sidecar
get_memory_usage() {
  kubectl top pod $POD_NAME -n $NAMESPACE --containers | grep $CONTAINER_NAME | awk '{print $3}'
}

# Bắt đầu theo dõi
end=$((SECONDS + DURATION))
while [ $SECONDS -lt $end ]; do
  memory_usage=$(get_memory_usage)

  # Loại bỏ các ký tự không phải số (Mi hoặc m)
  memory_usage=$(echo $memory_usage | tr -d '[:alpha:]')

  # Chuyển đổi sang số nguyên
  memory_usage=$(echo $memory_usage | awk '{print int($1)}')

  # Cộng lượng RAM tiêu thụ vào tổng và tăng số lần lấy mẫu
  total_memory_usage=$((total_memory_usage + memory_usage))
  sample_count=$((sample_count + 1))

  sleep $INTERVAL
done

# Tính lượng RAM tiêu thụ trung bình
if [ $sample_count -ne 0 ]; then
  average_memory_usage=$((total_memory_usage / sample_count))
else
  average_memory_usage=0
fi

echo "Lượng RAM tiêu thụ trung bình của container sidecar $CONTAINER_NAME trong pod $POD_NAME trong $DURATION giây là: ${average_memory_usage}Mi"
