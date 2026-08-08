#!/bin/bash

echo "=== Starting Automatic Restore Process ==="

echo "[1/4] Setting up Docker containers and network..."
chmod +x setup.sh
./setup.sh

echo "Waiting 20 seconds for PostgreSQL and Drupal to initialize..."
sleep 20

echo "[2/4] Restoring PostgreSQL database..."
docker exec -i postgres-db psql -U root -d drupal_db < drupal_db_backup.sql

echo "[3/4] Restoring Drupal Volumes (Design and Files)..."
docker exec -i drupal-app tar -xzf - -C /opt/drupal/web < drupal_volumes_backup.tar.gz

echo "[4/4] Restarting Drupal to apply changes..."
docker restart drupal-app

echo "=== Restore Completed Successfully! ==="
