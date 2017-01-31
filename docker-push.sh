#!/bin/bash

set -e

[[ -n "$IMAGE_NAME" ]] || (echo "Must set IMAGE_NAME"; exit 1)
[[ -n "$TAGS" ]] || (echo "Must set TAGS"; exit 1)

for tag in $TAGS; do
  docker push ${IMAGE_NAME}:${tag}
done
