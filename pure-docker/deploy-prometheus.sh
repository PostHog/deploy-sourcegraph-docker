#!/usr/bin/env bash
set -e

# Description: Prometheus collects metrics and aggregates them into graphs.
#
# Disk: 200GB / persistent SSD
# Network: 100mbps
# Liveness probe: n/a
# Ports exposed to other Sourcegraph services: none
# Ports exposed to the public internet: none (HTTP 9090 should be exposed to admins only)
#
VOLUME="$HOME/sourcegraph-docker/prometheus-v2-disk"
./ensure-volume.sh $VOLUME 100
docker run --detach \
    --name=prometheus \
    --network=sourcegraph \
    --restart=always \
    --cpus=4 \
    --memory=8g \
    -p 0.0.0.0:9090:9090 \
    -v $VOLUME:/prometheus \
    -v $(pwd)/../prometheus:/sg_prometheus_add_ons \
    -e SRC_FRONTEND_INTERNAL=sourcegraph-frontend-internal:3090 \
    index.docker.io/sourcegraph/prometheus:3.34.0@sha256:a2c9f9f2f705fdda053ba7b979127a9173c2417aa175e379d6e8637e7d4f58ca
