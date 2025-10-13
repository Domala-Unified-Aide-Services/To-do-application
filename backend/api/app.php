# To-Do List API in PHP

<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
$host = 'localhost';
$db = 'todo_db';
$user = 'root';

// Try different common password configurations
$password_options = ['', 'root', 'password', 'admin'];

$pdo = null;
$connection_error = '';

foreach ($password_options as $pass) {
    try {
        $pdo = new PDO("mysql:host=$host;dbname=$db", $user, $pass);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        // If we get here, connection was successful
        break;
    } catch (PDOException $e) {
        $connection_error = $e->getMessage();
        continue;
    }
}

if (!$pdo) {
    echo json_encode(['error' => "Database connection failed. Tried passwords: empty, 'root', 'password', 'admin'. Last error: " . $connection_error]);
    exit();
}

$requestMethod = $_SERVER["REQUEST_METHOD"];

switch ($requestMethod) {
    case 'GET':
        getTasks();
        break;
    case 'POST':
        createTask();
        break;
    case 'PUT':
        updateTask();
        break;
    case 'DELETE':
        deleteTask();
        break;
    default:
        echo json_encode(['error' => 'Invalid Request Method']);
        break;
}

function getTasks() {
    global $pdo;
    $stmt = $pdo->query("SELECT * FROM tasks");
    $tasks = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode($tasks);
}

function createTask() {
    global $pdo;
    $data = json_decode(file_get_contents("php://input"));
    $stmt = $pdo->prepare("INSERT INTO tasks (title, completed) VALUES (?, ?)");
    $stmt->execute([$data->title, $data->completed]);
    echo json_encode(['message' => 'Task created successfully']);
}

function updateTask() {
    global $pdo;
    $data = json_decode(file_get_contents("php://input"));
    $stmt = $pdo->prepare("UPDATE tasks SET title = ?, completed = ? WHERE id = ?");
    $stmt->execute([$data->title, $data->completed, $data->id]);
    echo json_encode(['message' => 'Task updated successfully']);
}

function deleteTask() {
    global $pdo;
    $data = json_decode(file_get_contents("php://input"));
    $stmt = $pdo->prepare("DELETE FROM tasks WHERE id = ?");
    $stmt->execute([$data->id]);
    echo json_encode(['message' => 'Task deleted successfully']);
}
?>
