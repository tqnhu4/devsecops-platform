Đây chính là phần quan trọng nhất của Sealed Secrets mà nhiều người mới học GitOps thường chưa hình dung được.

# Luồng đầy đủ

Giả sử bạn muốn tạo password cho Grafana.

## Bước 1: Tạo Secret tạm thời

File này KHÔNG được commit Git.

```text
tmp/
└── grafana-secret.yaml
```

```yaml
apiVersion: v1
kind: Secret

metadata:
  name: grafana-admin-secret
  namespace: monitoring

type: Opaque

stringData:
  admin-user: admin
  admin-password: MyVeryStrongPassword123
```

---

## Bước 2: Cluster phải có Sealed Secrets Controller

Cài:

```bash
cd platform/secrets/sealed-secrets

./install.sh
```

Kiểm tra:

```bash
kubectl get pods -n sealed-secrets
```

Ví dụ:

```text
sealed-secrets-controller-xxxxx Running
```

---

## Bước 3: Lấy Public Certificate

Controller tạo:

```text
Private Key
Public Key
```

Private Key:

```text
Nằm trong cluster
Không bao giờ lấy ra
```

Public Key:

```text
Developer dùng để encrypt
```

Lấy cert:

```bash
cd platform/secrets/sealed-secrets

./scripts/fetch-cert.sh
```

Sinh ra:

```text
certs/
└── sealed-secrets.crt
```

---

## Bước 4: Encrypt Secret

Chạy:

```bash
./scripts/seal-secret.sh \
tmp/grafana-secret.yaml \
gitops/secrets/monitoring/grafana-admin-secret.yaml
```

Script thực chất chạy:

```bash
kubeseal \
  --format yaml \
  --cert certs/sealed-secrets.crt \
  < tmp/grafana-secret.yaml \
  > gitops/secrets/monitoring/grafana-admin-secret.yaml
```

---

## Bước 5: Kết quả sau khi encrypt

File output:

```text
gitops/secrets/monitoring/grafana-admin-secret.yaml
```

sẽ thành:

```yaml
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret

metadata:
  name: grafana-admin-secret
  namespace: monitoring

spec:

  encryptedData:

    admin-user: AgB3W...
    admin-password: AgC8X...

  template:

    metadata:
      name: grafana-admin-secret
      namespace: monitoring

    type: Opaque
```

Lúc này:

```text
Không ai đọc được password
```

---

# Bước 6: Commit Git

Commit:

```text
gitops/secrets/monitoring/grafana-admin-secret.yaml
```

KHÔNG commit:

```text
tmp/grafana-secret.yaml
```

---

# Bước 7: ArgoCD Sync

ArgoCD thấy:

```yaml
kind: SealedSecret
```

và apply xuống cluster.

---

# Bước 8: Controller giải mã

Controller dùng:

```text
Private Key
```

để tạo:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: grafana-admin-secret
```

---

Kiểm tra:

```bash
kubectl get secret -n monitoring
```

Kết quả:

```text
grafana-admin-secret
```

---

Xem secret thật:

```bash
kubectl get secret grafana-admin-secret \
-n monitoring \
-o yaml
```

---

# Hình dung đơn giản

Trước đây:

```text
Git
 └── Secret
      └── password=123456
```

Ai đọc Git cũng thấy.

---

Sau khi dùng Sealed Secrets:

```text
Git
 └── SealedSecret
      └── AgB8fJd93Kx...
```

Không ai đọc được.

---

Cluster:

```text
SealedSecret
      ↓
Controller
      ↓
Secret
      ↓
Pod
```

---

# Với dự án hiện tại

Bạn sẽ có khoảng:

```text
tmp/
├── grafana-secret.yaml
├── argocd-repository-secret.yaml
├── alertmanager-secret.yaml
└── basic-auth-secret.yaml
```

Các file này:

```text
KHÔNG COMMIT
```

Thêm vào `.gitignore`:

```gitignore
tmp/
```

---

Sau khi seal:

```text
gitops/
└── secrets/
    ├── monitoring/
    │   ├── grafana-admin-secret.yaml
    │   └── alertmanager-secret.yaml
    │
    ├── argocd/
    │   └── repository-secret.yaml
    │
    └── web/
        └── basic-auth-secret.yaml
```

Các file này:

```text
COMMIT GIT
```

---

# Trong CI/CD có dùng kubeseal không?

Thông thường:

```text
Developer
    ↓
kubeseal
    ↓
Commit SealedSecret
```

CI/CD KHÔNG encrypt.

CI/CD chỉ:

```text
Build
Scan
Sign
SBOM
Attestation
Update GitOps
```

Vì vậy trong dự án của bạn:

```text
GitHub Actions
```

gần như **không cần sửa workflow `cicd.yml` hiện tại**.

Sealed Secrets là một phần của:

```text
GitOps Workflow
```

chứ không phải:

```text
CI/CD Build Workflow
```

Nói cách khác, việc encrypt xảy ra **trước khi commit Git**, còn GitHub Actions chỉ xử lý code và image sau khi đã commit.
