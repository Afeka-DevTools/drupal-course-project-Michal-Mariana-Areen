#!/bin/bash
echo "=== Starting Automatic Restore Process ==="

echo "[1/4] Setting up Docker containers and network..."
chmod +x setup.sh
./setup.sh

echo "Waiting 10 seconds for PostgreSQL and Drupal to initialize..."
sleep 10

echo "[2/4] Restoring PostgreSQL database..."
docker cp drupal_db_backup.sql postgres-db:/drupal_db_backup.sql
docker exec postgres-db psql -U postgres -d postgres -f /drupal_db_backup.sql

echo "[3/4] Restoring Drupal Volumes (Design and Files - FIXED PATH)..."
docker exec -i drupal-app tar -xzf - -C /opt/drupal/web < drupal_volumes_backup.tar.gz

echo "=== Restore Completed Successfully! ==="
