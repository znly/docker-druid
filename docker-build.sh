#!/bin/bash

set -e

[[ -n "$IMAGE_NAME" ]] || (echo "Must set IMAGE_NAME"; exit 1)
[[ -n "$TAGS" ]] || (echo "Must set TAGS"; exit 1)

canonical=
for tag in $TAGS; do
  if [[ -z "$canonical" ]]; then
    docker build -t ${IMAGE_NAME}:${tag} .
    canonical=${tag}
  else
    docker tag ${IMAGE_NAME}:${canonical} ${IMAGE_NAME}:${tag}
  fi
done
