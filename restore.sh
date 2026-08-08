#!/bin/bash
echo "=== Starting Automatic Restore Process ==="

echo "[1/4] Setting up Docker containers and network..."
chmod +x setup.sh
./setup.sh

echo "Waiting 20 seconds for PostgreSQL and Drupal to initialize..."
sleep 20

echo "[2/4] Restoring PostgreSQL database..."
docker cp drupal_db_backup.sql postgres-db:/drupal_db_backup.sql
docker exec postgres-db psql -U root -d drupal_db -f /drupal_db_backup.sql

echo "[3/4] Restoring Drupal Volumes..."
docker cp drupal_volumes_backup.tar.gz drupal-app:/opt/drupal/drupal_volumes_backup.tar.gz
docker exec drupal-app tar -xzf /opt/drupal/drupal_volumes_backup.tar.gz -C /opt/drupal/web
docker exec drupal-app rm /opt/drupal/drupal_volumes_backup.tar.gz

echo "=== Restore Completed Successfully! ==="
