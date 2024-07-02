# Sử dụng hình ảnh Python chính thức
FROM python:3.9-slim

# Thiết lập thư mục làm việc
WORKDIR /app

# Sao chép file requirements.txt vào container
COPY requirements.txt .

# Cài đặt các thư viện Python cần thiết
RUN pip install -r requirements.txt

# Sao chép toàn bộ mã nguồn vào container
COPY . .

# Mở cổng 8080 để container có thể lắng nghe các yêu cầu
EXPOSE 8080

# Chạy ứng dụng
CMD ["python", "app.py"]
