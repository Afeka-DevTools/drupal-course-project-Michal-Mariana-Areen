#!/bin/bash
echo "Backing up Drupal database..."
docker exec drupal-db sh -c 'exec mysqldump --set-gtid-purged=OFF --all-databases -uroot -p"my-secret-pw"' > my-drupal.backup.sql
echo "Backup saved to my-drupal.backup.sql"