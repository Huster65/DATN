#!/bin/bash

total_memlock=0

# Lấy thông tin các chương trình eBPF đang chạy
prog_list=$(sudo bpftool prog show)

# Duyệt qua từng dòng trong danh sách chương trình eBPF
while read -r line; do
    if [[ $line =~ memlock ]]; then
        # Lấy giá trị memlock từ dòng hiện tại
        memlock=$(echo "$line" | grep -oP 'memlock \K[0-9]+B')

        # Bỏ "B" và chuyển thành giá trị số
        memlock=${memlock::-1}

        # Cộng dồn vào tổng lượng memlock
        total_memlock=$((total_memlock + memlock))
    fi
done <<< "$prog_list"

echo "Total RAM used by eBPF programs: $total_memlock bytes"
