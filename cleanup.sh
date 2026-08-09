#!/bin/bash
echo "Stopping and removing containers..."
docker stop my-drupal drupal-db
docker rm my-drupal drupal-db

echo "Removing network..."
docker network rm drupal-net

echo "Removing Docker images..."
docker rmi drupal:latest mysql:latest

echo "Cleanup complete!"