cluster:
	bash scripts/install-cluster.sh

bootstrap:
	bash scripts/bootstrap.sh

destroy:
	bash scripts/destroy-cluster.sh

health:
	bash scripts/healthcheck.sh

port-forward:
	bash scripts/port-forward.sh

ingress:
	bash scripts/install-ingress.sh

argocd:
	bash scripts/install-argocd.sh

kyverno:
	bash scripts/install-kyverno.sh

monitoring:
	bash scripts/install-monitoring.sh

falco:
	bash scripts/install-falco.sh

deploy:
	kubectl apply -f gitops/argocd/

policies:
	kubectl apply -f platform/kyverno/policies/

logs:
	kubectl logs -n web deployment/web-frontend

pods:
	kubectl get pods -A

services:
	kubectl get svc -A

ingresses:
	kubectl get ingress -A