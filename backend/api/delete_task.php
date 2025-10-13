<?php
// delete_task.php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

require __DIR__ . '/config.php';

// Prefer JSON body, but also support form-encoded or query param
$body = json_decode(file_get_contents('php://input'), true);
$id = 0;

if (is_array($body) && isset($body['id'])) {
    $id = (int)$body['id'];
} elseif (isset($_POST['id'])) {
    $id = (int)$_POST['id'];
} elseif (isset($_GET['id'])) {
    $id = (int)$_GET['id'];
}

if ($id <= 0) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Valid task id is required.']);
    exit;
}

try {
    $stmt = $pdo->prepare("DELETE FROM tasks WHERE id = :id");
    $stmt->execute([':id' => $id]);
    if ($stmt->rowCount() === 0) {
        http_response_code(404);
        echo json_encode(['success' => false, 'error' => 'Task not found.']);
    } else {
        echo json_encode(['success' => true, 'deleted' => $id]);
    }
} catch (Exception $e) {
    error_log('delete_task error: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => 'Could not delete task.']);
}
