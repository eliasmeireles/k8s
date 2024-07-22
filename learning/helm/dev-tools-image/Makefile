# Makefile for building and pushing a Docker image

.PHONY: build push buildx all

# Setup Buildx builder
buildx:
	@docker buildx create --name buildxBuilder --use
	@docker buildx inspect buildxBuilder --bootstrap

# Build the Docker image
build:
	@echo "Building Docker image..."
	@read -p "Enter your Docker Hub username: " USERNAME; \
	 read -p "Enter the tag version: " TAG; \
	 docker buildx build --platform linux/amd64,linux/arm64 -t $$USERNAME/dev-tools:$$TAG --push .

# Push the Docker image
push:
	@echo "Pushing Docker image..."
	@read -p "Enter your Docker Hub username: " USERNAME; \
	 read -p "Enter the tag version: " TAG; \
	 docker push $$USERNAME/dev-tools:$$TAG

# Default target
all: build
