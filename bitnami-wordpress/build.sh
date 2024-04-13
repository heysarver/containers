#!/bin/bash

# Function to join array elements by a character
join_by() { local IFS="$1"; shift; echo "$*"; }

while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -t|--tag)
    TAG_NAME="$2"
    shift
    shift
    ;;
    *)
    shift
    ;;
  esac
done

# Split the version number into its components
IFS='.' read -ra VERSION_PARTS <<< "$TAG_NAME"

# Create additional tags
TAGS=""
for index in "${!VERSION_PARTS[@]}"; do
  TAGS+="-t heysarver/bitnami-wordpress:$(join_by . "${VERSION_PARTS[@]:0:$index+1}") "
done

# Add the "latest" tag
TAGS+="-t heysarver/bitnami-wordpress:latest"

# Print the Docker command before executing it
echo "docker buildx build --platform linux/arm64,linux/amd64 --push --build-arg=\"TAG_NAME=$TAG_NAME\" $TAGS ."

# Build and push the Docker image with all tags
eval "docker buildx build --platform linux/arm64,linux/amd64 --push --build-arg=\"TAG_NAME=$TAG_NAME\" $TAGS ."
