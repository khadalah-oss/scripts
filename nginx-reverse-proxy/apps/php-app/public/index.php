<?php
header('Content-Type: application/json');

$response = [
    'message' => 'Welcome to PHP Application',
    'timestamp' => date('c'),
    'service' => 'php-fpm',
    'environment' => $_ENV['PHP_ENV'] ?? 'production'
];

echo json_encode($response, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
?>
