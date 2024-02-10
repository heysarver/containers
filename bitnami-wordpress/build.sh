#!/bin/bash

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

docker buildx build --platform linux/arm64,linux/amd64 --push --build-arg="TAG_NAME=$TAG_NAME" -t heysarver/bitnami-wordpress:$TAG_NAME .
