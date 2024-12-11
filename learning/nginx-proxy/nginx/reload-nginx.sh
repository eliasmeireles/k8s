#!/bin/bash

# Watch for changes in nginx configuration directories
inotifywait -m -r -e modify,move,create,delete /etc/nginx |
while read path action file; do
    echo "Configuration change detected in $path: $action $file"
    nginx -s reload
done
