#!/bin/bash

# Thời gian theo dõi (30 giây)
DURATION=30

# Thời gian giữa các lần lấy mẫu (1 giây)
INTERVAL=1

# Biến để theo dõi lượng RAM tiêu thụ lớn nhất
max_memlock=0

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

    # Kiểm tra và cập nhật giá trị memlock lớn nhất
    if (( memlock > max_memlock )); then
        max_memlock=$memlock
    fi

    sleep $INTERVAL
done

echo "Maximum RAM used by eBPF programs over $DURATION seconds: $max_memlock bytes"
