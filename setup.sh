#!/bin/bash

echo "=== Starting Drupal Infrastructure Setup ==="

# 1. Create Docker Network
echo "[1/3] Creating Docker network 'drupal-net'..."
docker network create drupal-net 2>/dev/null || echo "Network 'drupal-net' already exists."

# 2. Run PostgreSQL Containerś
echo "[2/3] Starting PostgreSQL container..."
docker run -d --name postgres-db --network drupal-net -p 5432:5432 -e POSTGRES_PASSWORD=my-secret-pw -e POSTGRES_USER=root -e POSTGRES_DB=drupal_db postgres:latest

# 3. Run Drupal Container
echo "[3/3] Starting Drupal container..."
docker run -d --name drupal-app --network drupal-net -p 8080:80 -v drupal-data:/var/www/html drupal:latest

echo "=== Setup Completed Successfully! ==="
echo "Drupal is accessible at: http://localhost:8080"
