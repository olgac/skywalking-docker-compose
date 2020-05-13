#!/bin/bash

ROOT_PATH=$(dirname "$0")

echo "$(date) removing sky stack"
docker stack rm sky

echo "$(date) removing sky network"
docker network rm sky

echo "$(date) pruning death containers"
docker container prune -f