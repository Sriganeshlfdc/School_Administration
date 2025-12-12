<?php
// api/students/update_academic_edit.php
require_once __DIR__ . '/../../config/config.php';
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success' => false, 'message' => 'Method Not Allowed']);
    exit;
}

$conn = get_db_connection_transactional($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
if (!$conn) {
    echo json_encode(['success' => false, 'message' => 'Database connection failed.']);
    exit;
}

try {
    $ad_no = filter_input(INPUT_POST, 'AdmissionNo', FILTER_SANITIZE_NUMBER_INT);
    if (!$ad_no) throw new Exception("Admission No is missing.");

    // 1. Inputs
    $stream = filter_input(INPUT_POST, 'Stream', FILTER_SANITIZE_STRING);
    $lin = filter_input(INPUT_POST, 'LIN', FILTER_SANITIZE_STRING);
    $combination = filter_input(INPUT_POST, 'Combination', FILTER_SANITIZE_STRING);
    $ple_idx = filter_input(INPUT_POST, 'PLEIndexNumber', FILTER_SANITIZE_STRING);
    $ple_agg = filter_input(INPUT_POST, 'PLEAggregate', FILTER_SANITIZE_NUMBER_INT);
    $uce_idx = filter_input(INPUT_POST, 'UCEIndexNumber', FILTER_SANITIZE_STRING);
    $uce_res = filter_input(INPUT_POST, 'UCEResult', FILTER_SANITIZE_STRING);

    // 2. Update Enrollment (Stream)
    if (isset($_POST['Stream'])) {
        $stmt_e = $conn->prepare("UPDATE Enrollment SET Stream = ? WHERE AdmissionNo = ?");
        $stmt_e->bind_param("si", $stream, $ad_no);
        $stmt_e->execute();
        $stmt_e->close();
    }

    // 3. Update AcademicHistory (LIN, Combination, PLE, UCE)
    // Check if record exists
    $stmt_check = $conn->prepare("SELECT HistoryID FROM AcademicHistory WHERE AdmissionNo = ?");
    $stmt_check->bind_param("i", $ad_no);
    $stmt_check->execute();
    $exists = $stmt_check->get_result()->num_rows > 0;
    $stmt_check->close();

    if ($exists) {
        $sql = "UPDATE AcademicHistory SET 
                LIN = ?, Combination = ?, 
                PLEIndexNumber = ?, PLEAggregate = ?, 
                UCEIndexNumber = ?, UCEResult = ? 
                WHERE AdmissionNo = ?";
        $stmt_a = $conn->prepare($sql);
        $stmt_a->bind_param("sssissi", $lin, $combination, $ple_idx, $ple_agg, $uce_idx, $uce_res, $ad_no);        $stmt_a->execute();
        $stmt_a->close();
    } else {
        // Optional: Insert if missing (though standard admission creates it)
        $sql = "INSERT INTO AcademicHistory (AdmissionNo, LIN, Combination, PLEIndexNumber, PLEAggregate, UCEIndexNumber, UCEResult) VALUES (?, ?, ?, ?, ?, ?, ?)";
        $stmt_a = $conn->prepare($sql);
        $stmt_a->bind_param("isssiss", $ad_no, $lin, $combination, $ple_idx, $ple_agg, $uce_idx, $uce_res);        $stmt_a->execute();
        $stmt_a->close();
    }

    $conn->commit();
    echo json_encode(['success' => true, 'message' => 'Academic details updated.']);

} catch (Exception $e) {
    if ($conn) $conn->rollback();
    echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
} finally {
    if (isset($conn)) $conn->close();
}
?>