#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <pattern>"
    exit 1
fi

PATTERN=$1

# List all instances and filter by the given pattern
INSTANCES=$(multipass list --format csv | grep -i "$PATTERN" | cut -d, -f1)

# Check if any instances were found
if [ -z "$INSTANCES" ]; then
    echo "No instances found matching pattern: $PATTERN"
    exit 1
fi

# Confirm deletion
echo "The following instances will be deleted:"
echo "$INSTANCES"
read -p -r "Are you sure you want to delete these instances? (y/N): " CONFIRM

if [[ "$CONFIRM" =~ ^[yY](es)?$ ]]; then
    for instance in $INSTANCES; do
        echo "Deleting instance: $instance"
        multipass delete --purge "$instance"
    done
    echo "Deletion complete."
else
    echo "Deletion canceled."
fi
