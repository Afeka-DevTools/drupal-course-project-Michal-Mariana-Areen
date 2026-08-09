#!/bin/bash
echo "Creating docker network..."
docker network create drupal-net

echo "Starting MySQL container..."
docker run -d --name drupal-db --network drupal-net -p 3306:3306 -e MYSQL_ROOT_PASSWORD=my-secret-pw -e MYSQL_DATABASE=drupaldb -e MYSQL_USER=drupaluser -e MYSQL_PASSWORD=drupalpass mysql:latest

echo "Starting Drupal container..."
docker run -d --name my-drupal --network drupal-net -p 8080:80 drupal:latest

echo "Setup complete! Drupal is available at http://localhost:8080"