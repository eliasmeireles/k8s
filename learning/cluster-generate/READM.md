# Kubernetes Cluster Setup Script

This script automates the setup of a Kubernetes cluster using Multipass for virtual machines and HAProxy for load
balancing.

## Prerequisites

- **Multipass**: Ensure Multipass is installed on your machine. See [Multipass Install](https://multipass.run/install).

## Usage

1. **Clone the Repository:**

````bash
git clone https://github.com/eliasmeireles/ssh-test.git
cd learning/cluster-generate
````

2. **Run the Script:**

````bash
./setup.sh
````

## Options

- `--base-name`: Base name for the cluster (required).
- `--cluster-version`: Kubernetes cluster version (e.g., v1.27, required).
- `--num-masters`: Number of master nodes (required).
- `--num-workers`: Number of worker nodes (required).
- `--master-mem`: Memory for master nodes (default: 2G).
- `--master-cpus`: CPUs for master nodes (default: 1).
- `--master-disk`: Disk size for master nodes (default: 22G).
- `--worker-mem`: Memory for worker nodes (default: 4G).
- `--worker-cpus`: CPUs for worker nodes (default: 2).
- `--worker-disk`: Disk size for worker nodes (default: 32G).
- `--help`: Display help message.

## Example:

````bash
./setup.sh --base-name my-cluster --cluster-version v1.27 --num-masters 3 --num-workers 3 --master-mem 3G --worker-mem 6G
````

- This command will create a Kubernetes cluster named my-cluster, with version v1.27, 3 master nodes, and 3 worker
  nodes. Master nodes will have 3GB of memory, and worker nodes will have 6GB of memory.

# Logging:

- Logs for each execution are stored in `./.temp` directory with filenames based on the timestamp of execution.

## Notes:

- The script assumes a Unix-like environment.
- Ensure you have sufficient resources (CPU, memory, disk space) on your host machine to run the virtual machines.
- Each node created will have the necessary configuration and Kubernetes setup executed via a transferred script (
  kub-config.sh).

## Cleanup:

- To delete all instances created by the script, use:

````bash
./delete-instances.sh <pattern>
````

- Replace <pattern> with a keyword that matches the instance names to delete.

## Author:

Created by [Elias Meireles](https://eliasmeireles.com/).
License:

