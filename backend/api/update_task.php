<?php
// update_task.php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

require __DIR__ . '/config.php';

// Handle both GET query parameters and POST JSON body
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // GET request with query parameters (for checkbox toggle)
    $id = isset($_GET['id']) ? (int)$_GET['id'] : 0;
    $completed = isset($_GET['completed']) ? (int)$_GET['completed'] : null;
    
    if ($id <= 0 || $completed === null) {
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'Valid task id and completed status are required.']);
        exit;
    }
    
    try {
        $stmt = $pdo->prepare('UPDATE tasks SET completed = :completed WHERE id = :id');
        $stmt->execute([':completed' => $completed, ':id' => $id]);
        echo json_encode(['success' => true, 'updated' => $stmt->rowCount()]);
    } catch (Exception $e) {
        error_log('update_task error: ' . $e->getMessage());
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'Could not update task.']);
    }
    exit;
}

// POST/PUT request with JSON body (for other updates)
$body = json_decode(file_get_contents('php://input'), true);

if (!is_array($body)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Invalid JSON body.']);
    exit;
}

$id = isset($body['id']) ? (int)$body['id'] : 0;
if ($id <= 0) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Valid task id is required.']);
    exit;
}

// Possible fields to update
$fields = [];
$params = [':id' => $id];

if (isset($body['title'])) {
    $fields[] = 'title = :title';
    $params[':title'] = trim($body['title']);
}
if (isset($body['description'])) {
    $fields[] = 'description = :description';
    $params[':description'] = trim($body['description']);
}
if (isset($body['completed'])) {
    $completed = $body['completed'] ? 1 : 0;
    $fields[] = 'completed = :completed';
    $params[':completed'] = $completed;
}

if (empty($fields)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'No fields to update.']);
    exit;
}

$sql = 'UPDATE tasks SET ' . implode(', ', $fields) . ' WHERE id = :id';

try {
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    echo json_encode(['success' => true, 'updated' => $stmt->rowCount()]);
} catch (Exception $e) {
    error_log('update_task error: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => 'Could not update task.']);
}