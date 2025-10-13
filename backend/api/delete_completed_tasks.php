<?php
// delete_completed_tasks.php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

require __DIR__ . '/config.php';

try {
    // Delete all tasks where completed = 1
    $stmt = $pdo->prepare("DELETE FROM tasks WHERE completed = 1");
    $stmt->execute();
    
    $deletedCount = $stmt->rowCount();
    
    echo json_encode([
        'success' => true, 
        'deleted_count' => $deletedCount,
        'message' => "$deletedCount completed task(s) deleted successfully."
    ]);
} catch (Exception $e) {
    error_log('delete_completed_tasks error: ' . $e->getMessage());
    http_response_code(500);
    echo json_encode([
        'success' => false, 
        'error' => 'Could not delete completed tasks.',
        'details' => $e->getMessage()
    ]);
}