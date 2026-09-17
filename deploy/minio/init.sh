#!/bin/sh
# Runs inside the minio/mc container after MinIO is healthy. Idempotent.
set -eu
mc alias set local "http://minio:9000" "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD"
mc mb --ignore-existing "local/$S3_BUCKET_TILES"
mc anonymous set download "local/$S3_BUCKET_TILES"
echo "minio-init: bucket $S3_BUCKET_TILES ready (public read)"
