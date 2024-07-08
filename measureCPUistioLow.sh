#!/bin/bash

POD_NAME=hello-pod
NAMESPACE=default
CONTAINER_NAME=istio-proxy
INTERVAL=1  # Khoảng thời gian giữa mỗi lần lấy số liệu
DURATION=30  # Tổng thời gian đo

max_cpu_usage=0

echo "Measuring CPU usage of container $CONTAINER_NAME in pod $POD_NAME for $DURATION seconds..."

for ((i=0; i<DURATION; i+=INTERVAL)); do
    cpu_usage=$(kubectl top pod $POD_NAME --containers --namespace $NAMESPACE | grep $CONTAINER_NAME | awk '{print $2}' | sed 's/m$//')
    if (( cpu_usage > max_cpu_usage )); then
        max_cpu_usage=$cpu_usage
    fi
    sleep $INTERVAL
done

echo "Maximum CPU usage of container $CONTAINER_NAME in pod $POD_NAME over $DURATION seconds: ${max_cpu_usage}m"
