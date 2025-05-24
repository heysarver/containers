#!/bin/bash
set -e

# Configuration
IMAGE_NAME="heysarver/toolkit"
PLATFORMS="linux/amd64,linux/arm64"
TAGS="latest"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --tag)
            TAGS="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--tag TAG1,TAG2,...]"
            exit 1
            ;;
    esac
done

# Check if docker buildx is available
if ! docker buildx version > /dev/null 2>&1; then
    echo "Error: docker buildx not available. Please ensure you have Docker Desktop with buildx enabled."
    exit 1
fi

# Build and push multi-architecture image
echo "Building and pushing multi-architecture image for platforms: $PLATFORMS"

# Create a new builder instance if it doesn't exist
if ! docker buildx inspect toolkit-builder > /dev/null 2>&1; then
    docker buildx create --name toolkit-builder --use
else
    docker buildx use toolkit-builder
fi

# Bootstrap the builder
docker buildx inspect --bootstrap

# Prepare tags
TAG_ARGS=""
IFS=',' read -ra TAG_ARRAY <<< "$TAGS"
for tag in "${TAG_ARRAY[@]}"; do
    TAG_ARGS="$TAG_ARGS --tag $IMAGE_NAME:$tag"
done

# Build and push all platforms in one command
echo "Building and pushing $IMAGE_NAME with tags: $TAGS..."
docker buildx build \
    --platform=$PLATFORMS \
    $TAG_ARGS \
    --push \
    .

echo "Successfully built and pushed $IMAGE_NAME for platforms: $PLATFORMS with tags: $TAGS" 
