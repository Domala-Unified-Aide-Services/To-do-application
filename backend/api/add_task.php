<?php
// add_task.php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    // CORS preflight
    http_response_code(204);
    exit;
}

require __DIR__ . '/config.php';

// Read JSON body
$body = json_decode(file_get_contents('php://input'), true);
$title = isset($body['title']) ? trim($body['title']) : '';
$description = isset($body['description']) ? trim($body['description']) : '';
$priority = isset($body['priority']) ? trim($body['priority']) : 'medium';

// Validate priority
if (!in_array($priority, ['high', 'medium', 'low'])) {
    $priority = 'medium';
}

if ($title === '') {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Title is required.']);
    exit;
}

try {
    $stmt = $pdo->prepare("INSERT INTO tasks (title, description, priority, completed, created_at) VALUES (:title, :description, :priority, 0, NOW())");
    $stmt->execute([
        ':title' => $title,
        ':description' => $description,
        ':priority' => $priority
    ]);
    $id = (int)$pdo->lastInsertId();
    http_response_code(201);
    echo json_encode([
        'success' => true, 
        'task' => [
            'id' => $id, 
            'title' => $title, 
            'description' => $description, 
            'priority' => $priority,
            'completed' => 0
        ]
    ]);
} catch (Exception $e) {
    error_log('add_task error: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => 'Could not add task.']);
}