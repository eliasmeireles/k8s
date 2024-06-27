#!/bin/bash

# Default values
DEFAULT_MASTER_MEM=2G
DEFAULT_MASTER_CPUS=1
DEFAULT_MASTER_DISK=22G
DEFAULT_WORKER_MEM=4G
DEFAULT_WORKER_CPUS=2
DEFAULT_WORKER_DISK=32G

# Function to display help
display_help() {
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
    echo "  --base-name          Base name for the cluster"
    echo "  --cluster-version    Kubernetes cluster version (e.g., v1.27)"
    echo "  --num-masters        Number of master nodes"
    echo "  --num-workers        Number of worker nodes"
    echo "  --master-mem         Memory for master nodes (default: $DEFAULT_MASTER_MEM)"
    echo "  --master-cpus        CPUs for master nodes (default: $DEFAULT_MASTER_CPUS)"
    echo "  --master-disk        Disk size for master nodes (default: $DEFAULT_MASTER_DISK)"
    echo "  --worker-mem         Memory for worker nodes (default: $DEFAULT_WORKER_MEM)"
    echo "  --worker-cpus        CPUs for worker nodes (default: $DEFAULT_WORKER_CPUS)"
    echo "  --worker-disk        Disk size for worker nodes (default: $DEFAULT_WORKER_DISK)"
    echo "  --help               Display this help message"
    exit 0
}

# Function to copy and run the kub-config.sh script on an instance
copy_and_run_kub_config() {
    local node=$1
    multipass transfer kub-config.sh "$node":/home/ubuntu/kub-config.sh
    multipass exec "$node" -- bash -c "chmod +x /home/ubuntu/kub-config.sh && sudo /home/ubuntu/kub-config.sh"
}

# Function to get the IP address of an instance
get_ip_address() {
    local instance_name=$1
    local ip_address=$(multipass info "$instance_name" | grep "IPv4" | awk '{print $2}')
    if [ -z "$ip_address" ]; then
        echo "No IP address found for instance: $instance_name"
        exit 1
    fi
    echo "$ip_address"
}

# Function to generate HAProxy master server configuration
config_master_ip_address() {
    local ip_address=$1
    local index=$2
    echo "    server k8s-master-${index} ${ip_address}:6443 check fall 3 rise 2"
}

# Function to generate HAProxy bind configuration
config_haproxy_ip_address() {
    local ip_address=$1
    echo "    bind ${ip_address}:6443"
}

# Function to read and validate user input
read_and_validate() {
    local prompt=$1
    local var_name=$2
    local validation_regex=$3
    local example_message=$4

    while true; do
        read -p "$prompt" input
        if [ -z "$input" ]; then
            echo "\n\tInput is required. $example_message\n"
        elif ! echo "$input" | grep -qE "$validation_regex"; then
            echo "Invalid input. $example_message"
        else
            eval $var_name="'$input'"
            break
        fi
    done
}

# Parse command-line arguments
while [ $# -gt 0 ]; do
    case "$1" in
        --base-name)
            BASE_NAME="$2"
            shift 2
            ;;
        --cluster-version)
            CLUSTER_VERSION="$2"
            shift 2
            ;;
        --num-masters)
            NUM_MASTERS="$2"
            shift 2
            ;;
        --num-workers)
            NUM_WORKERS="$2"
            shift 2
            ;;
        --master-mem)
            MASTER_MEM="$2"
            shift 2
            ;;
        --master-cpus)
            MASTER_CPUS="$2"
            shift 2
            ;;
        --master-disk)
            MASTER_DISK="$2"
            shift 2
            ;;
        --worker-mem)
            WORKER_MEM="$2"
            shift 2
            ;;
        --worker-cpus)
            WORKER_CPUS="$2"
            shift 2
            ;;
        --worker-disk)
            WORKER_DISK="$2"
            shift 2
            ;;
        --help)
            display_help
            ;;
        *)
            echo "Unknown option: $1"
            display_help
            ;;
    esac
done

# Validate required inputs
[ -z "$BASE_NAME" ] && read_and_validate "Enter base name for the cluster: " BASE_NAME "^[a-zA-Z0-9_-]+$" "Example: k8s-cluster"
[ -z "$CLUSTER_VERSION" ] && read_and_validate "Enter Kubernetes cluster version: " CLUSTER_VERSION "^[vV]?[0-9]+(\.[0-9]+)*$" "Example: v1.27"
[ -z "$NUM_MASTERS" ] && read_and_validate "Enter number of master nodes: " NUM_MASTERS "^[0-9]+$" "Example: 3"
[ -z "$NUM_WORKERS" ] && read_and_validate "Enter number of worker nodes: " NUM_WORKERS "^[0-9]+$" "Example: 3"

# Use default values if not provided
MASTER_MEM=${MASTER_MEM:-$DEFAULT_MASTER_MEM}
MASTER_CPUS=${MASTER_CPUS:-$DEFAULT_MASTER_CPUS}
MASTER_DISK=${MASTER_DISK:-$DEFAULT_MASTER_DISK}
WORKER_MEM=${WORKER_MEM:-$DEFAULT_WORKER_MEM}
WORKER_CPUS=${WORKER_CPUS:-$DEFAULT_WORKER_CPUS}
WORKER_DISK=${WORKER_DISK:-$DEFAULT_WORKER_DISK}

# Arrays to hold master and worker node names
MASTER_NODES=()
WORKER_NODES=()

# Create master nodes
for i in $(seq 1 $NUM_MASTERS); do
    MASTER_NAME="${BASE_NAME}-master-${i}-${CLUSTER_VERSION}"
    echo "Creating master node: $MASTER_NAME"
    multipass launch --name $MASTER_NAME --memory $MASTER_MEM --cpus $MASTER_CPUS --disk $MASTER_DISK
    MASTER_NODES+=($MASTER_NAME)
    copy_and_run_kub_config $MASTER_NAME
done

# Create worker nodes
for i in $(seq 1 $NUM_WORKERS); do
    WORKER_NAME="${BASE_NAME}-worker-${i}-${CLUSTER_VERSION}"
    echo "Creating worker node: $WORKER_NAME"
    multipass launch --name $WORKER_NAME --memory $WORKER_MEM --cpus $WORKER_CPUS --disk $WORKER_DISK
    WORKER_NODES+=($WORKER_NAME)
    copy_and_run_kub_config $WORKER_NAME
done

# Create HAProxy node
HAPROXY_NAME="${BASE_NAME}-haproxy-${CLUSTER_VERSION}"
echo "Creating HAProxy node: $HAPROXY_NAME"
multipass launch --name $HAPROXY_NAME --memory 1G --cpus 1 --disk 22G

# Install HAProxy
multipass exec $HAPROXY_NAME -- bash -c "
    sudo apt-get update && sudo apt-get install -y haproxy
"

# Get HAProxy IP address
HAPROXY_IP=$(get_ip_address $HAPROXY_NAME)

# Generate HAProxy configuration
cat <<EOF | multipass exec $HAPROXY_NAME -- sudo tee /etc/haproxy/haproxy.cfg >> /dev/null

# K8s config
frontend kubernetes
    mode tcp
$(config_haproxy_ip_address $HAPROXY_IP)
    option tcplog
    default_backend k8s-masters

backend k8s-masters
    mode tcp
    balance roundrobin
    option tcp-check
EOF

# Add master nodes to HAProxy configuration
for i in "${!MASTER_NODES[@]}"; do
    MASTER_IP=$(get_ip_address ${MASTER_NODES[$i]})
    config_master_ip_address $MASTER_IP $i | multipass exec $HAPROXY_NAME -- sudo tee -a /etc/haproxy/haproxy.cfg > /dev/null
done

# Update /etc/hosts for all nodes
for node in "${MASTER_NODES[@]}" "${WORKER_NODES[@]}"; do
    multipass exec $node -- bash -c "echo '${HAPROXY_IP} ${HAPROXY_NAME}' | sudo tee -a /etc/hosts"
done

# Restart HAProxy to apply the new configuration
multipass exec $HAPROXY_NAME -- sudo systemctl restart haproxy

echo "Cluster setup is complete."
