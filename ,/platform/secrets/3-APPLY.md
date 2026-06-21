Bạn đã tạo được một `SealedSecret` cho Grafana:

```yaml
kind: SealedSecret
metadata:
  name: grafana-admin-secret
  namespace: monitoring
```

Nhưng hiện tại file `values.yaml` của Grafana vẫn đang hard-code:

```yaml
grafana:
  adminPassword: admin123
```

Khi đó Grafana **không sử dụng Sealed Secret** mà vẫn lấy password từ Helm values.

---

# Mục tiêu đúng

Thay vì:

```yaml
grafana:
  adminPassword: admin123
```

chúng ta sẽ dùng:

```yaml
grafana:
  admin:
    existingSecret: grafana-admin-secret
    userKey: admin-user
    passwordKey: admin-password
```

---

# Bước 1: Commit SealedSecret vào Git

Ví dụ:

```text
platform/
└── monitoring/
    ├── values.yaml
    └── grafana-admin-secret.yaml
```

File:

```yaml
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  name: grafana-admin-secret
  namespace: monitoring
spec:
  ...
```

Commit lên Git:

```bash
git add .
git commit -m "add grafana sealed secret"
git push
```

---

# Bước 2: ArgoCD Apply

Hoặc apply thủ công:

```bash
kubectl apply -f platform/monitoring/grafana-admin-secret.yaml
```
kubectl apply -f gitops/secrets/monitoring/grafana-admin-secret.yaml

Kiểm tra:

```bash
kubectl get sealedsecret -n monitoring
```

Kết quả:

```text
grafana-admin-secret
```

---

# Bước 3: Controller tạo Secret thật

Sealed Secrets Controller sẽ tự động giải mã:

```bash
kubectl get secret -n monitoring
```

Bạn sẽ thấy:

```text
grafana-admin-secret
```

Kiểm tra:

```bash
kubectl get secret grafana-admin-secret \
-n monitoring \
-o yaml
```

Sẽ có:

```yaml
data:
  admin-user: xxxxx
  admin-password: xxxxx
```

---

# Bước 4: Sửa values.yaml

Thay đoạn này:

```yaml
grafana:
  enabled: true

  adminPassword: admin123
```

bằng:

```yaml
grafana:
  enabled: true

  admin:
    existingSecret: grafana-admin-secret
    userKey: admin-user
    passwordKey: admin-password
```

Toàn bộ sẽ thành:

```yaml
grafana:
  enabled: true

  admin:
    existingSecret: grafana-admin-secret
    userKey: admin-user
    passwordKey: admin-password

  service:
    type: ClusterIP

  sidecar:
    dashboards:
      enabled: true
      label: grafana_dashboard

    datasources:
      enabled: true

prometheus:
  prometheusSpec:
    retention: 7d

alertmanager:
  enabled: true

kube-state-metrics:
  enabled: true

nodeExporter:
  enabled: true
```

---

# Bước 5: Redeploy Helm

```bash
helm upgrade --install monitoring \
prometheus-community/kube-prometheus-stack \
-n monitoring \
-f platform/monitoring/values.yaml
```

hoặc ArgoCD sync.

---

# Kiểm tra Grafana

Lấy username:

```bash
kubectl get secret grafana-admin-secret \
-n monitoring \
-o jsonpath="{.data.admin-user}" \
| base64 -d
```

Lấy password:

```bash
kubectl get secret grafana-admin-secret \
-n monitoring \
-o jsonpath="{.data.admin-password}" \
| base64 -d
```

---

# Trong GitOps chuẩn

Cấu trúc thường là:

```text
gitops/
├── monitoring
│   ├── values.yaml
│   ├── grafana-admin-secret.yaml
│   ├── dashboards/
│   └── alerts/

platform/
└── sealed-secrets
```

Repository chỉ chứa:

```text
✓ SealedSecret
✓ values.yaml
```

và tuyệt đối không chứa:

```text
✗ admin123
✗ webhook url
✗ database password
✗ AWS keys
```

---

Có một điểm quan trọng nữa: trong file của bạn còn có:

```yaml
receivers:
  - name: discord
    webhook_configs:
      - url: https://discord.com/api/webhooks/REPLACE_ME
```

Webhook Discord cũng nên chuyển sang `SealedSecret`, không nên để trong `values.yaml`. Trong mô hình GitOps + ArgoCD + Kyverno + Sealed Secrets, cả **Grafana password**, **Discord webhook**, **SMTP password**, **AWS credentials** đều nên được quản lý bằng `SealedSecret`.
