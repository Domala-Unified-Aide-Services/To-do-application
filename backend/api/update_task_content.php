<?php
require 'config.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

$data = json_decode(file_get_contents('php://input'), true);

$id = $data['id'] ?? 0;
$title = $data['title'] ?? '';
$description = $data['description'] ?? '';
$priority = isset($data['priority']) ? trim($data['priority']) : 'medium';

// Validate priority
if (!in_array($priority, ['high', 'medium', 'low'])) {
    $priority = 'medium';
}

if (!$id || !$title) {
    http_response_code(400);
    echo json_encode(['error' => 'ID and title are required']);
    exit;
}

try {
    $stmt = $pdo->prepare("UPDATE tasks SET title = ?, description = ?, priority = ? WHERE id = ?");
    $stmt->execute([$title, $description, $priority, $id]);
    
    if ($stmt->rowCount() > 0 || $stmt->rowCount() === 0) {
        // rowCount() can be 0 if nothing changed, but that's still success
        echo json_encode(['success' => true]);
    } else {
        http_response_code(404);
        echo json_encode(['error' => 'Task not found']);
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
}
?>