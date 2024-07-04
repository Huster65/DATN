import re

def extract_ram_usage(line):
    match = re.search(r'memlock (\d+)', line)
    if match:
        return int(match.group(1))
    return 0

def calculate_total_ram(file_path):
    total_ram = 0
    with open(file_path, 'r') as file:
        for line in file:
            total_ram += extract_ram_usage(line)
    return total_ram

if __name__ == "__main__":
    file_path = 'bpftool_output.txt'
    total_ram = calculate_total_ram(file_path)
    print(f"Tổng RAM sử dụng bởi các chương trình eBPF: {total_ram} bytes")
