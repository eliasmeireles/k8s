# Default values
BASE_NAME ?= k8s
CLUSTER_VERSION ?= v1
NUM_MASTERS ?= 3
NUM_WORKERS ?= 6

new-cluster:
	./setup \
		--base-name $(BASE_NAME) \
		--cluster-version $(CLUSTER_VERSION) \
		--num-masters $(NUM_MASTERS) \
		--num-workers $(NUM_WORKERS)

delete-cluster:
	./delete-instances.sh $(CLUSTER_VERSION)

