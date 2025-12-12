<?php
require_once __DIR__ . '/../../config/config.php';
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success' => false, 'message' => 'Invalid request method.']);
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

    $name = trim(filter_input(INPUT_POST, 'Name', FILTER_SANITIZE_STRING));
    $surname = trim(filter_input(INPUT_POST, 'Surname', FILTER_SANITIZE_STRING));
    $gender = filter_input(INPUT_POST, 'Gender', FILTER_SANITIZE_STRING);
    $class = filter_input(INPUT_POST, 'Class', FILTER_SANITIZE_STRING);
    $stream = filter_input(INPUT_POST, 'Stream', FILTER_SANITIZE_STRING);
    $residence = filter_input(INPUT_POST, 'Residence', FILTER_SANITIZE_STRING);
    $entry = filter_input(INPUT_POST, 'EntryStatus', FILTER_SANITIZE_STRING);
    $contact = trim(filter_input(INPUT_POST, 'Contact', FILTER_SANITIZE_STRING));
    $lin = trim(filter_input(INPUT_POST, 'LIN', FILTER_SANITIZE_STRING));

    $stmt1 = $conn->prepare("UPDATE Students SET Name = ?, Surname = ?, Gender = ? WHERE AdmissionNo = ?");
    $stmt1->bind_param("sssi", $name, $surname, $gender, $ad_no);
    $stmt1->execute();
    $stmt1->close();

    $stmt2 = $conn->prepare("UPDATE Enrollment SET Class = ?, Stream = ?, Residence = ?, EntryStatus = ? WHERE AdmissionNo = ?");
    $stmt2->bind_param("ssssi", $class, $stream, $residence, $entry, $ad_no);
    $stmt2->execute();
    $stmt2->close();

    if (!empty($contact)) {
        $stmt3 = $conn->prepare("UPDATE Parents SET father_contact = ? WHERE AdmissionNo = ?");
        $stmt3->bind_param("si", $contact, $ad_no);
        $stmt3->execute();
        $stmt3->close();
    }

    if(isset($_POST['LIN'])) {
        $stmt4 = $conn->prepare("UPDATE AcademicHistory SET LIN = ? WHERE AdmissionNo = ?");
        $stmt4->bind_param("si", $lin, $ad_no);
        $stmt4->execute();
        $stmt4->close();
    }
    
    $conn->commit();
    echo json_encode(['success' => true, 'message' => 'Record updated successfully.']);

} catch (Exception $e) {
    $conn->rollback();
    echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
} finally {
    $conn->close();
}
?>