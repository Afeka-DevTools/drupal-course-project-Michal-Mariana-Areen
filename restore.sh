#!/bin/bash
echo "=== Starting Automatic Restore Process ==="
echo "[1/3] Setting up Docker containers and network..."
chmod +x setup.sh
./setup.sh
echo "Waiting 10 seconds for PostgreSQL to initialize..."
sleep 10
echo "[2/3] Restoring PostgreSQL database..."
docker cp drupal_db_backup.sql postgres-db:/drupal_db_backup.sql
docker exec postgres-db psql -U postgres -d postgres -f /drupal_db_backup.sql
echo "=== Restore Completed Successfully! ==="