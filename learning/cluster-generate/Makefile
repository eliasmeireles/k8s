# Default values
BASE_NAME ?= k8s
CLUSTER_VERSION ?= v1
AMOUNT_REQUEST_FILE_SERVER_TEST ?= 10000
NUM_MASTERS ?= 1
NUM_WORKERS ?= 2
NAMESPACE ?= default

kube-config:
	mkdir "./.temp" || true
	multipass exec $(BASE_NAME)-master-1-$(CLUSTER_VERSION) -- sudo cat /root/.kube/config > ./.temp/$(BASE_NAME)-master-1-$(CLUSTER_VERSION)-kube-config.yaml

get-pods:
	multipass exec $(BASE_NAME)-master-1-$(CLUSTER_VERSION) -- sudo bash -c "kubectl get pods -n $(NAMESPACE)"

get-pods-ks:
	make get-pods NAMESPACE=kube-system

exec:
	multipass exec $(BASE_NAME)-master-1-$(CLUSTER_VERSION) bash

new-cluster:
	./scripts/setup \
		--base-name $(BASE_NAME) \
		--cluster-version $(CLUSTER_VERSION) \
		--num-masters $(NUM_MASTERS) \
		--num-workers $(NUM_WORKERS)

delete-cluster:
	./scripts/delete-instances.sh $(CLUSTER_VERSION)

deploy-file-server:
	kubectl apply -f ./file-server/file-server.yaml

delete-file-server:
	kubectl delete -f ./file-server/file-server.yaml

deploy-proxy:
	kubectl  apply -f proxy/internal-server.yaml

delete-proxy:
	kubectl delete -f proxy/internal-server.yaml

add-nginx-ingress:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

remove-nginx-ingress:
	kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

check-ingress:
	echo "Pods:"
	kubectl get pods -n ingress-nginx
	echo "Services:"
	kubectl get svc -n ingress-nginx
	echo "Endpoints:"
	kubectl get endpoints ingress-nginx-controller-admission -n ingress-nginx

debug-up:
	kubectl delete pod debug-pod || true
	kubectl run debug-pod --image=busybox --restart=Never -- sleep 36000 || true
	sleep 15
	kubectl exec -it debug-pod -- sh

internal-server-logs:
	kubectl logs -f -l app=internal-server --prefix=true --max-log-requests=20

file-server-logs:
	kubectl logs -f -l app=file-server --prefix=true --max-log-requests=20

file-server-test:
	CLUSTER_VERSION=$(CLUSTER_VERSION) ./scripts/file-server-test $(AMOUNT_REQUEST_FILE_SERVER_TEST)

apply-kube-prometheus:
	./scripts/kube-prometheus \
		--base-name $(BASE_NAME) \
		--cluster-version $(CLUSTER_VERSION) \
		--num-masters $(NUM_MASTERS) \
		--num-workers $(NUM_WORKERS)




