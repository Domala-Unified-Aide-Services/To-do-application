<?php
// config.php - database connection (no debug output)
ini_set('display_errors', 0); // disable showing errors in output
ini_set('log_errors', 1);
error_reporting(E_ALL);

$host = 'localhost';
$dbname = 'todo_db';
$user = 'root';

// Try different common password configurations
$password_options = ['', 'root', 'password', 'admin'];

$pdo = null;
$connection_error = '';

foreach ($password_options as $password) {
    try {
        $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $user, $password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        break;
    } catch(PDOException $e) {
        $connection_error = $e->getMessage();
        continue;
    }
}

if (!$pdo) {
    error_log("DB connection failed: " . $connection_error);
    // Do not echo the error — return failure to caller or handle it where required
    // If this file is included by an API endpoint, that endpoint should handle the response
    // For scripts that require DB, you could throw an exception:
    throw new Exception('Database connection failed.');
}
