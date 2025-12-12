<?php
// api/students/migrate_backend.php
require_once __DIR__ . '/../../config/config.php';
header('Content-Type: application/json');

// 1. Disable error printing to prevent JSON syntax errors
error_reporting(E_ALL);
ini_set('display_errors', 0);
ini_set('log_errors', 1);

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method Not Allowed']);
    exit;
}

$input = json_decode(file_get_contents('php://input'), true);
$student_ids = $input['student_ids'] ?? [];
$target_year = $input['target_year'] ?? ''; 
$target_term = $input['target_term'] ?? '';
$target_level = $input['target_level'] ?? '';
$target_class = $input['target_class'] ?? '';
$target_stream = $input['target_stream'] ?? '';

if (empty($student_ids) || empty($target_year) || empty($target_term) || empty($target_level) || empty($target_class)) {
    echo json_encode(['success' => false, 'message' => 'Missing required fields.']);
    exit;
}

$target_academic_year = format_academic_year($target_year);

$conn = get_db_connection_transactional($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
if (!$conn) {
    echo json_encode(['success' => false, 'message' => 'Database connection failed.']);
    exit;
}

try {
    // 2. Check Capacity
    $sql_check = "SELECT COUNT(*) as count FROM Enrollment 
                  WHERE AcademicYear = ? AND Class = ? AND Stream = ?";
    $stmt_check = $conn->prepare($sql_check);
    if (!$stmt_check) throw new Exception("Prepare check failed: " . $conn->error);
    
    $stmt_check->bind_param("sss", $target_academic_year, $target_class, $target_stream);
    $stmt_check->execute();
    $curr_count_result = $stmt_check->get_result()->fetch_assoc();
    $current_count = $curr_count_result['count'];
    $stmt_check->close();

    $incoming_count = count($student_ids);
    
    if (defined('MAX_STUDENTS_PER_STREAM') && ($current_count + $incoming_count) > MAX_STUDENTS_PER_STREAM) {
        throw new Exception("Migration Blocked: Class is full ($current_count students). Limit: " . MAX_STUDENTS_PER_STREAM);
    }

    // 3. Migrate Students
    $sql_hist = "INSERT INTO EnrollmentHistory (AdmissionNo, AcademicYear, Level, Class, Term, Stream, Residence, EntryStatus)
                 SELECT AdmissionNo, AcademicYear, Level, Class, Term, Stream, Residence, EntryStatus
                 FROM Enrollment WHERE AdmissionNo = ?";
    $stmt_hist = $conn->prepare($sql_hist);

    $sql_update = "UPDATE Enrollment SET AcademicYear = ?, Term = ?, Level = ?, Class = ?, Stream = ? WHERE AdmissionNo = ?";
    $stmt_update = $conn->prepare($sql_update);

    $success_count = 0;

    foreach ($student_ids as $id) {
        // Save History
        $stmt_hist->bind_param("i", $id);
        $stmt_hist->execute(); 

        // Update Record
        $stmt_update->bind_param("sssssi", $target_academic_year, $target_term, $target_level, $target_class, $target_stream, $id);
        if (!$stmt_update->execute()) {
            throw new Exception("Failed to migrate Student ID: $id");
        }
        $success_count++;
    }

    $conn->commit();
    
    // 4. Return Success with ALL variables separated
    echo json_encode([
        'success' => true, 
        'count' => $success_count,
        'target_class' => $target_class,
        'target_stream' => $target_stream,
        'target_year' => $target_year,
        'message' => "Successfully migrated $success_count student(s)."
    ]);

} catch (Exception $e) {
    if ($conn) $conn->rollback();
    echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
} finally {
    if (isset($conn)) $conn->close();
}
?>