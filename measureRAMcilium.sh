#!/bin/bash

# Thời gian theo dõi (30 giây)
DURATION=30

# Thời gian giữa các lần lấy mẫu (1 giây)
INTERVAL=1

# Biến để theo dõi tổng lượng RAM tiêu thụ và số lần lấy mẫu
total_memlock=0
sample_count=0

# Hàm để lấy tổng lượng RAM (memlock) của các chương trình eBPF
get_total_memlock() {
    total_memlock_local=0
    prog_list=$(sudo bpftool prog show)

    while read -r line; do
        if [[ $line =~ memlock ]]; then
            memlock=$(echo "$line" | grep -oP 'memlock \K[0-9]+')
            total_memlock_local=$((total_memlock_local + memlock))
        fi
    done <<< "$prog_list"

    echo $total_memlock_local
}

# Bắt đầu theo dõi
end=$((SECONDS + DURATION))
while [ $SECONDS -lt $end ]; do
    memlock=$(get_total_memlock)

    # Cộng dồn vào tổng lượng memlock
    total_memlock=$((total_memlock + memlock))
    sample_count=$((sample_count + 1))

    sleep $INTERVAL
done

# Tính tổng lượng RAM tiêu thụ trung bình
if [ $sample_count -ne 0 ]; then
    average_memlock=$((total_memlock / sample_count))
else
    average_memlock=0
fi

echo "Average total RAM used by eBPF programs over $DURATION seconds: $average_memlock bytes"
