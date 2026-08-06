#!/bin/bash

echo "=== Starting Environment Cleanup ==="

# Stop and remove containers
echo "Stopping and removing containers..."
docker stop drupal-app postgres-db 2>/dev/null
docker rm drupal-app postgres-db 2>/dev/null

# Remove network
echo "Removing Docker network..."
docker network rm drupal-net 2>/dev/null

# Remove volumes
echo "Removing Docker volumes..."
docker volume rm drupal-data 2>/dev/null

# Remove images
echo "Removing Docker images..."
docker rmi drupal:latest postgres:latest 2>/dev/null

echo "=== Cleanup Completed Successfully! ==="