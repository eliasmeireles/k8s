.PHONY: build push buildx

# Setup Buildx builder
buildx:
	@docker buildx create --name buildxBuilder --use
	@docker buildx inspect buildxBuilder --bootstrap

build:
	@read -p "Enter your Docker Hub username: " USERNAME; \
	 read -p "Enter the tag version: " TAG; \
	 docker buildx build --platform linux/amd64,linux/arm64 -t $$USERNAME/busybox:$$TAG --push .

push:
	@read -p "Enter your Docker Hub username: " USERNAME; \
	 read -p "Enter the tag version: " TAG; \
	 docker push $$USERNAME/busybox:$$TAG

# Default target
build-push: build

