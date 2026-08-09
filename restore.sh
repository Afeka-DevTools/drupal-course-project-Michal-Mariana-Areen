#!/bin/bash
echo "Restoring Drupal database from backup..."
cat my-drupal.backup.sql | docker exec -i drupal-db mysql -uroot -p"my-secret-pw"
echo "Database restored successfully!"