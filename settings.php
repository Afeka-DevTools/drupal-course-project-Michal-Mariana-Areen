<?php
$settings['hash_salt'] = 'afeka-course-secret-key-123456';
$settings['update_free_access'] = FALSE;
$settings['container_yamls'][] = $app_root . '/' . $site_path . '/services.yml';
$settings['file_scan_ignore_directories'] = [
  'node_modules',
  'bower_components',
];
$settings['entity_update_batch_size'] = 50;
$settings['entity_update_backup'] = TRUE;
$settings['migrate_node_migrate_type_default'] = 'idle';

$databases['default']['default'] = array (
  'database' => 'drupaldb',
  'username' => 'drupaluser',
  'password' => 'my-secret-pw',
  'host' => 'drupal-db',
  'port' => '3306',
  'driver' => 'mysql',
);
