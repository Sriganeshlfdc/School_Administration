<?php
// webpages/fetch_students_migration.php
require_once __DIR__ . '/../../config/config.php';
header('Content-Type: application/json');

$level = filter_input(INPUT_GET, 'level', FILTER_SANITIZE_STRING);
$class = filter_input(INPUT_GET, 'class', FILTER_SANITIZE_STRING);
$stream = filter_input(INPUT_GET, 'stream', FILTER_SANITIZE_STRING);
$year_raw = filter_input(INPUT_GET, 'year', FILTER_SANITIZE_STRING);

if (!$level || !$class) {
    echo json_encode(['success' => false, 'message' => 'Please select at least Level and Class.']);
    exit;
}

$conn = get_db_connection($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
if (!$conn) {
    echo json_encode(['success' => false, 'message' => 'Database connection failed.']);
    exit;
}

// Dynamic Query Construction
$sql = "
    SELECT S.AdmissionNo, S.Name, S.Surname, S.PhotoPath, E.Level, E.Class, E.Stream, E.AcademicYear
    FROM Students S
    JOIN Enrollment E ON S.AdmissionNo = E.AdmissionNo
    WHERE E.Level = ? AND E.Class = ?
";

$params = [$level, $class];
$types = "ss";

if (!empty($stream)) {
    $sql .= " AND E.Stream = ?";
    $params[] = $stream;
    $types .= "s";
}

if (!empty($year_raw)) {
    // Format input (e.g. 2025) to string (2025-26) if not already formatted
    $academic_year = format_academic_year($year_raw);
    $sql .= " AND E.AcademicYear = ?";
    $params[] = $academic_year;
    $types .= "s";
}

$sql .= " ORDER BY S.Name ASC";

$stmt = $conn->prepare($sql);
$stmt->bind_param($types, ...$params);
$stmt->execute();
$result = $stmt->get_result();

$students = [];
while ($row = $result->fetch_assoc()) {
    $students[] = $row;
}

echo json_encode(['success' => true, 'data' => $students]);
$stmt->close();
$conn->close();
?>