#!/bin/bash

echo "=== מתחיל תהליך שחזור נתונים ==="

# משיכת הגיבוי האחרון מה-Repository ב-Git
echo "[1/3] Pulling latest backup from Git..."
git pull

# שחזור בסיס הנתונים של Postgres מתוך קובץ הגיבוי
echo "[2/3] Restoring PostgreSQL database..."
docker exec -i postgres-db psql -U root -d drupal_db < drupal_db_backup.sql

# אתחול מחדש לקונטיינר של דרופל כדי להחיל את השינויים
echo "[3/3] Restarting Drupal container..."
docker restart drupal-app

echo "=== השחזור בוצע בהצלחה! ==="
