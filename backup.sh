#!/bin/bash

echo "=== Starting Full Backup (Database + Volumes) ==="

# 1. Execute pg_dump on postgres-db container (Database Backup)
echo "Backing up Database..."
docker exec postgres-db sh -c 'exec pg_dump -U root drupal_db' > drupal_db_backup.sql

# 2. Backup Drupal Volumes (Design and Files)
echo "Backing up Drupal Volumes..."
docker exec drupal-app tar -czf - -C /opt/drupal/web/sites . > drupal_volumes_backup.tar.gz

echo "=== Backup Completed Successfully! ==="
echo "Files saved: drupal_db_backup.sql AND drupal_volumes_backup.tar.gz"