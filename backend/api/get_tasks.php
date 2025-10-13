<?php
// get_tasks.php
header('Content-Type: application/json; charset=utf-8');
require 'config.php';

// Allow CORS for local dev (adjust in production)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type');
    exit(0);
}

try {
    $stmt = $pdo->query("SELECT id, title, description, priority, completed, created_at FROM tasks ORDER BY created_at DESC");
    $tasks = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Ensure priority is set for all tasks (in case some old tasks don't have it)
    foreach ($tasks as &$task) {
        if (!isset($task['priority']) || empty($task['priority'])) {
            $task['priority'] = 'medium';
        }
    }
    
    echo json_encode(['success' => true, 'tasks' => $tasks], JSON_UNESCAPED_UNICODE);
} catch (PDOException $e) {
    http_response_code(500);
    error_log('get_tasks error: ' . $e->getMessage());
    echo json_encode(['success' => false, 'error' => 'Database error.']);
}