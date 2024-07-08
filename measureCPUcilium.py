import re
import subprocess
import time

def get_cumulruntime():
    total_runtime = 0
    result = subprocess.run(['sudo', 'bpftool', 'prog', 'show'], capture_output=True, text=True)
    for line in result.stdout.splitlines():
        match = re.search(r'run_time_ns (\d+)', line)
        if match:
            total_runtime += int(match.group(1))
    return total_runtime

# Lấy tổng cumulruntime ban đầu
initial_runtime = get_cumulruntime()
print(f'Initial cumulruntime: {initial_runtime} nanoseconds')

# Đợi 1 giây
time.sleep(30)

# Lấy tổng cumulruntime sau 1 giây
final_runtime = get_cumulruntime()
print(f'Final cumulruntime: {final_runtime} nanoseconds')

# Tính toán sự thay đổi trong thời gian chạy tích lũy
runtime_difference = final_runtime - initial_runtime

# In ra tổng thời gian chạy tích lũy trong 1 giây
print(f'Total cumulruntime in the last 30 second: {runtime_difference} nanoseconds')
