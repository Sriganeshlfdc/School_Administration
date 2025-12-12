<?php
// api/students/fetch_quick_edit.php
require_once __DIR__ . '/../../config/config.php';
header('Content-Type: application/json');

try {
    $conn = get_db_connection($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
    if (!$conn) {
        throw new Exception("Database connection failed.");
    }

    // 1. Get Filters & Pagination
    $year = filter_input(INPUT_GET, 'year', FILTER_SANITIZE_STRING);
    $level = filter_input(INPUT_GET, 'level', FILTER_SANITIZE_STRING);
    $class = filter_input(INPUT_GET, 'class', FILTER_SANITIZE_STRING);
    $stream = filter_input(INPUT_GET, 'stream', FILTER_SANITIZE_STRING);

    $page = filter_input(INPUT_GET, 'page', FILTER_VALIDATE_INT) ?: 1;
    $limit = filter_input(INPUT_GET, 'limit', FILTER_VALIDATE_INT) ?: 25;
    $offset = ($page - 1) * $limit;

    // 2. Build Query Conditions
    $where = ["1=1"];
    $params = [];
    $types = "";

    if (!empty($year)) { $where[] = "E.AcademicYear = ?"; $params[] = $year; $types .= "s"; }
    if (!empty($level)) { $where[] = "E.Level = ?"; $params[] = $level; $types .= "s"; }
    if (!empty($class)) { $where[] = "E.Class = ?"; $params[] = $class; $types .= "s"; }
    if (!empty($stream)) { $where[] = "E.Stream = ?"; $params[] = $stream; $types .= "s"; }

    $where_sql = implode(" AND ", $where);

    // 3. Get Total Count
    $count_sql = "SELECT COUNT(*) as total 
                  FROM Students S 
                  JOIN Enrollment E ON S.AdmissionNo = E.AdmissionNo 
                  WHERE $where_sql";
    $stmt = $conn->prepare($count_sql);
    if (!empty($params)) $stmt->bind_param($types, ...$params);
    $stmt->execute();
    $total_records = $stmt->get_result()->fetch_assoc()['total'];
    $stmt->close();

    // 4. Get Data
    $sql = "SELECT 
                S.AdmissionNo, S.Name, S.Surname, S.Gender, 
                E.Class, E.Stream, E.Residence, E.EntryStatus,
                A.LIN,
                COALESCE(P.father_contact, P.mother_contact, P.guardian_contact) as Contact
            FROM Students S 
            JOIN Enrollment E ON S.AdmissionNo = E.AdmissionNo
            LEFT JOIN Parents P ON S.AdmissionNo = P.AdmissionNo
            LEFT JOIN AcademicHistory A ON S.AdmissionNo = A.AdmissionNo
            WHERE $where_sql
            ORDER BY S.AdmissionNo ASC
            LIMIT ? OFFSET ?";

    // Add pagination params
    $params[] = $limit;
    $params[] = $offset;
    $types .= "ii";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param($types, ...$params);
    $stmt->execute();
    $result = $stmt->get_result();

    $data = [];
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }

    echo json_encode([
        'success' => true,
        'data' => $data,
        'total' => $total_records,
        'page' => $page,
        'limit' => $limit,
        'total_pages' => ceil($total_records / $limit)
    ]);

    $conn->close();

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}
?>