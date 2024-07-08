#!/bin/bash

# Tên của pod và container sidecar
POD_NAME=hello-pod
CONTAINER_NAME=istio-proxy
NAMESPACE=default

# Thời gian theo dõi (5 giây)
DURATION=5

# Thời gian giữa các lần lấy mẫu (1 giây)
INTERVAL=1

# Biến để theo dõi lượng RAM tiêu thụ cao nhất
max_memory_usage=0

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

  if (( memory_usage > max_memory_usage )); then
    max_memory_usage=$memory_usage
  fi
  sleep $INTERVAL
done

echo "Lượng RAM tiêu thụ nhiều nhất của container sidecar $CONTAINER_NAME trong pod $POD_NAME trong $DURATION giây là: ${max_memory_usage}Mi"
