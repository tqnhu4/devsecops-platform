Đây thường **không phải do cache trình duyệt**, mà do cách Grafana xử lý tài khoản admin lần đầu.

## Điều quan trọng cần biết

Biến:

```text
GF_SECURITY_ADMIN_USER
GF_SECURITY_ADMIN_PASSWORD
```

chỉ được Grafana sử dụng khi **khởi tạo tài khoản admin lần đầu tiên**.

Sau khi Grafana đã tạo user admin trong database của nó, việc thay đổi Secret Kubernetes sẽ **không tự động đổi password admin trong Grafana**.

---

## Kiểm tra giả thuyết này

Xem pod Grafana đang đọc Secret mới hay không:

```bash
kubectl exec -n monitoring deploy/monitoring-grafana -- env | grep GF_SECURITY
```

Nếu thấy:

```text
GF_SECURITY_ADMIN_USER=admin
GF_SECURITY_ADMIN_PASSWORD=<password mới>
```

thì Deployment đã nhận Secret mới.

Nhưng nếu vẫn đăng nhập bằng password cũ ⇒ password đã được lưu trong database Grafana.

---

## Kiểm tra pod đã restart chưa

Sau khi đổi Secret:

```bash
kubectl rollout restart deployment monitoring-grafana -n monitoring
```

Kiểm tra:

```bash
kubectl rollout status deployment monitoring-grafana -n monitoring
```

Sau đó thử login lại.

---

## Trường hợp phổ biến nhất: Grafana dùng Persistent Volume

Kiểm tra:

```bash
kubectl get pvc -n monitoring
```

Nếu có PVC cho Grafana, ví dụ:

```text
monitoring-grafana
```

thì database Grafana được lưu trên volume.

Khi đó:

```text
Password admin đã được lưu trong DB Grafana
↓
Secret thay đổi
↓
Grafana KHÔNG đổi password hiện có
```

Đây là hành vi bình thường.

---

## Xác nhận bằng log

```bash
kubectl logs -n monitoring deploy/monitoring-grafana
```

Thường sẽ thấy các dòng kiểu:

```text
Admin user already exists
```

hoặc

```text
Skipping creation of admin user
```

---

## Cách đổi password đúng

### Cách 1: Dùng Grafana CLI trong pod

```bash
kubectl exec -it -n monitoring deploy/monitoring-grafana -- bash
```

Trong pod:

```bash
grafana cli admin reset-admin-password 'PasswordMoi123!'
```

---

### Cách 2: Xóa dữ liệu Grafana (chỉ môi trường lab/dev)

Nếu không cần giữ dashboard:

```bash
kubectl delete pvc -n monitoring <grafana-pvc-name>
kubectl rollout restart deployment monitoring-grafana -n monitoring
```

Khi Grafana khởi tạo lại từ đầu, nó sẽ đọc password từ Secret mới.

⚠️ Cách này làm mất dashboard, datasource, alert rule được lưu trong DB.

---

## Kiểm tra nhanh nhất

Cho tôi kết quả:

```bash
kubectl get pvc -n monitoring

kubectl exec -n monitoring deploy/monitoring-grafana -- env | grep GF_SECURITY
```

Nếu:

```text
GF_SECURITY_ADMIN_PASSWORD=<mật khẩu mới>
```

nhưng login chỉ được bằng mật khẩu cũ, thì tôi có thể khẳng định gần như chắc chắn Grafana đã lưu password trong database và không còn dùng giá trị từ Secret để cập nhật tài khoản admin hiện có nữa.
