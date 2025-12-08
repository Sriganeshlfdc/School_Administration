<?php
// api/students/deletestudent.php
require_once __DIR__ . '/../../config/config.php';
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'GET' || !isset($_GET['id'])) {
    echo json_encode(['success' => false, 'message' => 'Invalid request.']);
    exit;
}

$student_id = filter_input(INPUT_GET, 'id', FILTER_SANITIZE_NUMBER_INT);
global $DB_HOST, $DB_USER, $DB_PASS, $DB_NAME, $UPLOAD_DIR_BASE;

function rmdir_recursive($dir) {
    if (!file_exists($dir)) return true;
    if (!is_dir($dir)) return unlink($dir);
    foreach (scandir($dir) as $item) {
        if ($item == '.' || $item == '..') continue;
        if (!rmdir_recursive($dir . DIRECTORY_SEPARATOR . $item)) return false;
    }
    return rmdir($dir);
}

$conn = get_db_connection_transactional($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
if (!$conn) {
    echo json_encode(['success' => false, 'message' => 'Database connection failed.']);
    exit;
}

try {
    // Get photo path for cleanup
    $stmt = $conn->prepare("SELECT PhotoPath FROM Students WHERE StudentID = ?");
    $stmt->bind_param("i", $student_id);
    $stmt->execute();
    $res = $stmt->get_result();
    $row = $res->fetch_assoc();
    $stmt->close();

    if (!$row) {
        throw new Exception("Student not found.");
    }

    // Delete Dependents
    $tables = ['Enrollment', 'Parents', 'AcademicHistory', 'EnrollmentHistory'];
    foreach ($tables as $tbl) {
        $conn->query("DELETE FROM $tbl WHERE StudentID = $student_id");
    }

    // Delete Student
    $stmt_del = $conn->prepare("DELETE FROM Students WHERE StudentID = ?");
    $stmt_del->bind_param("i", $student_id);
    if (!$stmt_del->execute()) throw new Exception($stmt_del->error);
    $stmt_del->close();

    $conn->commit();

    // File Cleanup
    $student_dir = $UPLOAD_DIR_BASE . $student_id . '/';
    if (is_dir($student_dir)) {
        rmdir_recursive($student_dir);
    }

    echo json_encode(['success' => true, 'message' => "Student deleted successfully."]);

} catch (Exception $e) {
    $conn->rollback();
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
} finally {
    $conn->close();
}
?>