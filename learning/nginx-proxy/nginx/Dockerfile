FROM nginx:latest

WORKDIR /app

# Install inotify-tools to watch for file changes
RUN apt-get update && apt-get install -y inotify-tools

# Copy a custom reload script
COPY reload-nginx.sh /usr/local/bin/reload-nginx.sh
RUN chmod +x /usr/local/bin/reload-nginx.sh

# Create a volume for nginx configurations
VOLUME /etc/nginx

# Start nginx and watch for configuration changes
CMD ["/bin/bash", "-c", "/usr/local/bin/reload-nginx.sh & nginx -g 'daemon off;'"]
