# DATN
#Đây là hướng dẫn đo đạc các thông số đã nêu trong quyển đồ án tốt nghiệp

#Đầu tiên chúng ta sẽ chạy các pod curl-hey-pod và hello-pod bằng cách apply 2 file .yaml

  kubectl apply -f hello.yaml
  
  kubectl apply -f curl-hey-pod.yaml
  
#Sau khi pod được khởi tạo chúng ta sẽ đứng từ curl=hey-pod để gửi traffic sang cho hello-pod trong 2 trường hợp sử dụng cilium và istio

  hey -z 30s -c 1 http://<pod-ip>:<port>
  
#IP của pod được cấp phát sau khi tạo pod

#khi bắt đầu chạy lệnh hey thì chúng ta cũng chạy script measureCPU.sh để đo %CPU khi sử dụng cilium

#sau đó chúng ta sẽ được %CPU sử dụng của các chương trình eBPF

#chúng ta tiếp theo chạy script measureRAM để có thể thấy lượng RAM tiêu thụ của các chương trình eBPF


