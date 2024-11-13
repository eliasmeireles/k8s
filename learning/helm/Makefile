create-namespace:
	kubectl create namespace development
	kubectl apply -f cluster-roles.yml -n development
	kubectl config set-context --current --namespace=development

app-update:
	kubectl apply -f internal-server/config-map.yaml
	./deploy --release-name internal-server
	./deploy --release-name dev-tools
	./deploy --release-name file-server
	echo "Waiting for pods to be ready..."
	sleep 10
	make show-pods

internal-server-up:
	make internal-server-down
	kubectl apply -f internal-server/config-map.yaml
	./deploy --release-name internal-server
	make show-pods

internal-server-down:
	kubectl delete -f internal-server/config-map.yaml || true
	./uninstall --release-name internal-server || true
	make show-pods

app-up:
	make app-down
	make app-update

app-down:
	./uninstall --release-name internal-server || true
	./uninstall --release-name dev-tools || true
	./uninstall --release-name file-server || true
	sleep 10
	make show-pods

show-pods:
	kubectl get pods -n development -o wide --show-labels

file-server-logs:
	kubectl logs -n development -f --since=12h --tail=1000000 --prefix=true --max-log-requests=15 -lapp.kubernetes.io/name=file-server

internal-server-logs:
	./proxy-logs

test:
	./test-filter-server-request

dev-tools-connect:
	./dev-connect

