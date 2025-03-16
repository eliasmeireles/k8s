# Kubernetes Cluster Setup Script

This script automates the setup of a Kubernetes cluster using **Multipass** for virtual machines and **HAProxy** for
load balancing. It allows you to create a highly available Kubernetes cluster with customizable resources for master and
worker nodes.

---

## Prerequisites

- **Multipass**: Ensure Multipass is installed on your machine. See [Multipass Install](https://multipass.run/install).
- **kubectl**: Install `kubectl` to interact with your Kubernetes cluster.
  See [kubectl installation guide](https://kubernetes.io/docs/tasks/tools/).
- **jq**: Install `jq` for JSON parsing. Run `sudo apt-get install jq` or follow
  the [official guide](https://stedolan.github.io/jq/download/).

---

## References

- [Multipass](https://multipass.run/)
- [Docker Install](https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script)
- [Creating Highly Available Clusters with kubeadm](https://v1-27.docs.kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/)
- [Installing kubeadm](https://v1-27.docs.kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
- [CRI-O](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#cri-o)
- [Weaveworks](https://github.com/weaveworks/weave/blob/master/site/kubernetes/kube-addon.md#-installation)
- [LUNXXtips YouTube Tutorials](https://www.youtube.com/watch?v=-wbtj11Mqvk&list=PLf-O3X2-mxDnw1xBcTpy4pGkIj_CyvI7B&index=1)

---

## Usage

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/eliasmeireles/k8s.git
   cd k8s/learning/cluster-generate
   ```

2. **Run the Script:**

   ```bash
   ./setup
   ```

---

## Options

| Option              | Description                                | Default Value |
|---------------------|--------------------------------------------|---------------|
| `--base-name`       | Base name for the cluster (required)       | -             |
| `--cluster-version` | Kubernetes cluster version (e.g., `v1.27`) | -             |
| `--num-masters`     | Number of master nodes (required)          | -             |
| `--num-workers`     | Number of worker nodes (required)          | -             |
| `--master-mem`      | Memory for master nodes                    | `2G`          |
| `--master-cpus`     | CPUs for master nodes                      | `2`           |
| `--master-disk`     | Disk size for master nodes                 | `22G`         |
| `--worker-mem`      | Memory for worker nodes                    | `4G`          |
| `--worker-cpus`     | CPUs for worker nodes                      | `2`           |
| `--worker-disk`     | Disk size for worker nodes                 | `32G`         |
| `--haproxy-disk`    | Disk size for HAProxy node                 | `24G`         |
| `--haproxy-cpu`     | CPUs for HAProxy node                      | `2`           |
| `--haproxy-memory`  | Memory for HAProxy node                    | `4G`          |
| `--help`            | Display help message                       | -             |

---

## Example

```bash
./scripts/setup --base-name dev-k8s --cluster-version v1 --num-masters 3 --num-workers 4 --master-mem 3G --worker-mem 6G
```

- This command will create a Kubernetes cluster named `dev-k8s`, with version `v1`, 3 master nodes, and 3 worker
  nodes. Master nodes will have 3GB of memory, and worker nodes will have 6GB of memory.

---

## Network Setup

The script automatically applies a network plugin. For non-ARM architectures, **Weave** is used:

```bash
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
```

For ARM architectures, **Calico** is applied:

```bash
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

---

## Logging

- Logs for each execution are stored in the `./.temp` directory with filenames based on the timestamp of execution.

---

## Notes

- The script assumes a Unix-like environment.
- Ensure you have sufficient resources (CPU, memory, disk space) on your host machine to run the virtual machines.
- Each node created will have the necessary configuration and Kubernetes setup executed via a transferred script (
  `kube-config.sh`).

---

## Example Output

After completing the steps described in [Master Node Setup](#master-node-setup), you will see the output below:

![Cluster setup run example](doc/setup-execution-example.png)

![Multipass filtering created instances](doc/multipass-filter.png)

![k8s nodes](doc/k8s-nodes-info.png)

---

## Installing kube-prometheus

To monitor your cluster, you can install **kube-prometheus**:

```bash
git clone https://github.com/prometheus-operator/kube-prometheus
cd kube-prometheus
kubectl create -f manifests/setup
kubectl apply -f manifests/
kubectl get pods -n monitoring
```

When all pods in the `monitoring` namespace are running, access the Prometheus dashboard:

```bash
kubectl port-forward -n monitoring svc/grafana 3000:3000
```

Access the dashboard at [http://localhost:3000](http://localhost:3000) and use the default credentials (`admin/admin`).

---

## Cleanup

To delete all instances created by the script, use:

```bash
./scripts/delete-instances.sh <pattern>
```

Replace `<pattern>` with a keyword that matches the instance names to delete.

---

## Author

Created by [Elias Meireles](https://eliasmeireles.com/).  
License: MIT