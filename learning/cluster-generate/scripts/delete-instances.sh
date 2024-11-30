#!/bin/bash

source ./scripts/log-utils

setup_logs "cluster-deletion"

# Check if an argument is provided
if [ -z "$1" ]; then
    log "Usage: $0 <pattern>"
    exit 1
fi

PATTERN=$1

# List all instances and filter by the given pattern
INSTANCES=$(multipass list --format csv | grep -i "$PATTERN" | cut -d, -f1)

# Check if any instances were found
if [ -z "$INSTANCES" ]; then
    log "No instances found matching pattern: $PATTERN"
    exit 1
fi

# Confirm deletion
log "The following instances will be deleted:"
log "$INSTANCES"
# shellcheck disable=SC2162
read -p "Are you sure you want to delete these instances? (y/N): " CONFIRM

if [[ "$CONFIRM" =~ ^[yY](es)?$ ]]; then
    for instance in $INSTANCES; do
        log "Deleting instance: $instance"
        multipass delete --purge "$instance"
    done
    log "Deletion complete."
else
    log "Deletion canceled."
fi
