#!/bin/bash
set -ex

docker buildx build \
    --pull \
    -f docker/Dockerfile \
    