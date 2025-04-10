# Makefile for KIND cluster management
CLUSTER_NAME := k8s-development
KIND_CONFIG := kind.yaml

.PHONY: help create delete clean deploy-ingress check context

help:
	@echo "Available targets:"
	@echo "  create       - Create the KIND cluster"
	@echo "  delete       - Delete the cluster"
	@echo "  clean        - Delete cluster and clean resources"
	@echo "  deploy-ingress - Deploy NGINX Ingress Controller"
	@echo "  check        - Verify cluster status"
	@echo "  context      - Set kubectl context"
	@echo "  info         - Show cluster info"

create:
	@echo "Creating KIND cluster '$(CLUSTER_NAME)'..."
	#kind create cluster --name $(CLUSTER_NAME) --retain --config $(KIND_CONFIG)
	kind create cluster --name $(CLUSTER_NAME) --config $(KIND_CONFIG)
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
	kubectl config use-context kind-$(CLUSTER_NAME)
	kubectl get nodes -o wide
	@echo "\nCluster created. Use 'make context' to set kubectl context"

delete:
	@echo "Deleting KIND cluster '$(CLUSTER_NAME)'..."
	kind delete cluster --name $(CLUSTER_NAME)

clean: delete
	@echo "Cleaning Docker resources..."
	docker system prune -f

deploy-ingress:
	@echo "Deploying NGINX Ingress Controller..."
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
	@echo "Waiting for ingress controller to be ready..."
	kubectl wait --namespace ingress-nginx \
		--for=condition=ready pod \
		--selector=app.kubernetes.io/component=controller \
		--timeout=300s
	@echo "\nIngress controller ready"

check:
	@echo "Cluster nodes:"
	kubectl get nodes -o wide
	@echo "\nCluster pods:"
	kubectl get pods -A

context:
	kubectl cluster-info --context kind-$(CLUSTER_NAME)
	@echo "\nTo make this your default context:"
	@echo "kubectl config use-context kind-$(CLUSTER_NAME)"

info:
	@echo "Cluster information:"
	kind get clusters
	@echo "\nNodes:"
	kind get nodes --name $(CLUSTER_NAME)
	@echo "\nKubeconfig:"
	kind get kubeconfig --name $(CLUSTER_NAME)

# Add hosts entry for ingress (requires sudo)
add-hosts:
	@echo "Adding hosts entry for ingress..."
	sudo sh -c 'echo "127.0.0.1 v1.k8s.local" >> /etc/hosts'

# Test ingress connectivity
test-ingress:
	@echo "Testing ingress connectivity..."
	curl -v -H "Host: v1.k8s.local" http://localhost/api/file-server/v1/health

join-command:
	@docker exec $(CLUSTER_NAME)-control-plane kubeadm token create --print-join-command

nodes:
	@docker exec $(CLUSTER_NAME)-control-plane kubectl get nodes -o wide
