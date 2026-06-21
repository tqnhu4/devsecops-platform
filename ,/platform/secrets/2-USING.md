Đây là bước tiếp theo sau Sealed Secrets mà nhiều người hay bỏ sót:

```text
SealedSecret
    ↓
Secret
    ↓
Deployment
    ↓
Container
```

Sealed Secrets chỉ giải quyết việc **lưu Secret an toàn trong Git**. Sau khi ArgoCD sync và Controller giải mã, Kubernetes sẽ tạo ra một `Secret` bình thường. Từ đó Pod sử dụng Secret như mọi Secret khác.

---

# Ví dụ với Grafana

Bạn có:

```yaml
kind: SealedSecret
metadata:
  name: grafana-admin-secret
  namespace: monitoring
```

ArgoCD sync xong:

```bash
kubectl get secret -n monitoring
```

Kết quả:

```text
grafana-admin-secret
```

---

## Kiểm tra Secret đã được tạo

```bash
kubectl describe secret grafana-admin-secret \
-n monitoring
```

---

# Cách 1: Inject thành Environment Variables

Ví dụ Deployment:

```yaml
apiVersion: apps/v1
kind: Deployment

metadata:
  name: web-frontend

spec:

  replicas: 1

  selector:
    matchLabels:
      app: web-frontend

  template:

    metadata:
      labels:
        app: web-frontend

    spec:

      containers:

      - name: web

        image: nginx:latest

        env:

        - name: GRAFANA_USER
          valueFrom:
            secretKeyRef:
              name: grafana-admin-secret
              key: admin-user

        - name: GRAFANA_PASSWORD
          valueFrom:
            secretKeyRef:
              name: grafana-admin-secret
              key: admin-password
```

---

Trong Pod:

```bash
echo $GRAFANA_USER
```

Kết quả:

```text
admin
```

---

# Cách 2: Mount thành File

Ví dụ:

```yaml
spec:

  containers:

  - name: web

    image: nginx

    volumeMounts:

    - name: grafana-secret

      mountPath: /etc/secrets

      readOnly: true

  volumes:

  - name: grafana-secret

    secret:

      secretName: grafana-admin-secret
```

---

Trong Container:

```bash
ls /etc/secrets
```

Kết quả:

```text
admin-user
admin-password
```

---

Đọc:

```bash
cat /etc/secrets/admin-password
```

---

# Trường hợp ArgoCD Repository Secret

Ví dụ Secret:

```yaml
metadata:
  name: gitops-repository
  namespace: argocd

labels:
  argocd.argoproj.io/secret-type: repository
```

Secret này không cần mount.

ArgoCD tự động đọc:

```text
Repository URL
Username
Password
```

để clone Git Repository.

---

# Trường hợp Grafana

Nếu dùng Helm Chart:

```yaml
grafana:

  admin:
    existingSecret: grafana-admin-secret

    userKey: admin-user

    passwordKey: admin-password
```

Grafana tự lấy password từ Secret.

Không cần mount thủ công.

---

# Trường hợp Alertmanager

Secret:

```yaml
stringData:

  webhook-url: https://hooks.slack.com/xxxx
```

Config:

```yaml
global:

route:
  receiver: slack

receivers:

- name: slack

  slack_configs:

  - api_url_file: /etc/alertmanager/webhook-url
```

Mount Secret vào Pod.

---

# Trường hợp tương lai: PostgreSQL

Giả sử bạn thêm PostgreSQL.

Secret:

```yaml
kind: SealedSecret

metadata:
  name: postgres-secret
```

Sau khi unseal:

```yaml
kind: Secret
```

Deployment PostgreSQL:

```yaml
env:

- name: POSTGRES_PASSWORD

  valueFrom:

    secretKeyRef:

      name: postgres-secret

      key: password
```

---

Application PHP:

```yaml
env:

- name: DB_PASSWORD

  valueFrom:

    secretKeyRef:

      name: postgres-secret

      key: password
```

---

# Với dự án HTML hiện tại

Thực tế:

```text
HTML
CSS
Nginx
```

gần như không cần Secret.

Những nơi hợp lý để dùng Sealed Secrets là:

| Thành phần                       | Secret            |
| -------------------------------- | ----------------- |
| ArgoCD                           | GitHub Token      |
| Grafana                          | Admin Password    |
| Alertmanager                     | Slack Webhook     |
| Nginx Basic Auth                 | Username/Password |
| TLS Certificate (nếu tự quản lý) | Private Key       |

---

# Luồng hoàn chỉnh trong dự án của bạn

```text
tmp/grafana-secret.yaml
            │
            ▼
        kubeseal
            │
            ▼
gitops/secrets/monitoring/
grafana-admin-secret.yaml
            │
            ▼
         Git Repo
            │
            ▼
          ArgoCD
            │
            ▼
 Sealed Secrets Controller
            │
            ▼
      Kubernetes Secret
            │
            ▼
         Grafana Pod
```

Tức là **ứng dụng không đọc `SealedSecret`**, ứng dụng chỉ đọc **`Secret` đã được Controller giải mã tạo ra trong cluster**. Sealed Secret chỉ là "định dạng lưu trữ an toàn trong Git".
