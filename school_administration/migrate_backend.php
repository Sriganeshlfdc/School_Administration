<?php
require_once 'config.php';
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method Not Allowed']);
    exit;
}

$input = json_decode(file_get_contents('php://input'), true);
$student_ids = $input['student_ids'] ?? [];
$target_year = $input['target_year'] ?? ''; // e.g., 2026
$target_term = $input['target_term'] ?? '';
$target_level = $input['target_level'] ?? '';
$target_class = $input['target_class'] ?? '';
$target_stream = $input['target_stream'] ?? '';

if (empty($student_ids) || empty($target_year) || empty($target_term) || empty($target_level) || empty($target_class)) {
    echo json_encode(['success' => false, 'message' => 'Missing required fields.']);
    exit;
}

// FORMAT ACADEMIC YEAR (YYYY-YY)
$target_academic_year = format_academic_year($target_year);

$conn = get_db_connection_transactional($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
if (!$conn) {
    echo json_encode(['success' => false, 'message' => 'Database connection failed.']);
    exit;
}

try {
    // 1. Capacity Check of Target Class
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
    
    if (($current_count + $incoming_count) > MAX_STUDENTS_PER_STREAM) {
        throw new Exception("Migration Blocked: Target Class $target_class ($target_stream) has $current_count students. Adding $incoming_count would exceed the limit of " . MAX_STUDENTS_PER_STREAM . ".");
    }

    // 2. History Insert (Preserve previous state)
    $sql_hist = "
        INSERT INTO EnrollmentHistory (StudentID, AcademicYear, Level, Class, Term, Stream, Residence, EntryStatus)
        SELECT StudentID, AcademicYear, Level, Class, Term, Stream, Residence, EntryStatus
        FROM Enrollment WHERE StudentID = ?
    ";
    $stmt_hist = $conn->prepare($sql_hist);

    // 3. Update Enrollment with new AcademicYear string
    $sql_update = "UPDATE Enrollment SET AcademicYear = ?, Term = ?, Level = ?, Class = ?, Stream = ? WHERE StudentID = ?";
    $stmt_update = $conn->prepare($sql_update);

    if (!$stmt_update) throw new Exception("Prepare failed: " . $conn->error);

    $success_count = 0;

    foreach ($student_ids as $id) {
        if ($stmt_hist) {
            $stmt_hist->bind_param("i", $id);
            $stmt_hist->execute(); 
        }

        $stmt_update->bind_param("sssssi", $target_academic_year, $target_term, $target_level, $target_class, $target_stream, $id);
        if (!$stmt_update->execute()) {
            throw new Exception("Failed to migrate Student ID: $id");
        }
        $success_count++;
    }

    $conn->commit();
    echo json_encode([
        'success' => true, 
        'message' => "Successfully migrated $success_count student(s) to $target_academic_year."
    ]);

} catch (Exception $e) {
    if ($conn) $conn->rollback();
    echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
} finally {
    if (isset($conn)) $conn->close();
}
?>