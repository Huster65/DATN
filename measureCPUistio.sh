#!/bin/bash

POD_NAME=hello-pod
NAMESPACE=default
CONTAINER_NAME=istio-proxy
INTERVAL=1  # Khoảng thời gian giữa mỗi lần lấy số liệu
DURATION=30  # Tổng thời gian đo

sum_cpu_usage=0
count=0

echo "Measuring CPU usage of container $CONTAINER_NAME in pod $POD_NAME for $DURATION seconds..."

while [ $count -lt $DURATION ]; do
    cpu_usage=$(kubectl top pod $POD_NAME --containers --namespace $NAMESPACE | grep $CONTAINER_NAME | awk '{print $3}' | sed >    sum_cpu_usage=$((sum_cpu_usage + cpu_usage))
    count=$((count + INTERVAL))
    sleep $INTERVAL
done

average_cpu_usage=$((sum_cpu_usage / (DURATION / INTERVAL)))

echo "Average CPU usage of container $CONTAINER_NAME in pod $POD_NAME over $DURATION seconds: $average_cpu_usage millicores"
