<?php
// webpages/get_student.php
require_once 'config.php';
header('Content-Type: application/json');

$student_id = filter_input(INPUT_GET, 'id', FILTER_SANITIZE_NUMBER_INT);

if (!$student_id) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Student ID is required']);
    exit;
}

$conn = get_db_connection($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);

if ($conn) {
    // Select ALL fields for parents and guardian
    $sql = "
        SELECT 
            S.StudentID, S.AdmissionYear, S.Name, S.Surname, S.DateOfBirth, S.Gender, S.CurrentAddress AS Address, S.PhotoPath,
            
            -- Father Details
            P.father_name, P.father_age, P.father_contact, P.father_occupation, P.father_education,
            
            -- Mother Details
            P.mother_name, P.mother_age, P.mother_contact, P.mother_occupation, P.mother_education,
            
            -- Guardian Details (Aliases kept for compatibility if needed, plus new fields)
            P.guardian_name AS GuardianName, 
            P.guardian_relation, 
            P.guardian_age, 
            P.guardian_contact AS ContactPrimary, 
            P.guardian_occupation, 
            P.guardian_education, 
            P.guardian_address,
            P.MoreInformation AS GuardianNotes,
            
            -- Academic & Enrollment
            A.FormerSchool, A.PLEIndexNumber, A.PLEAggregate, A.UCEIndexNumber, A.UCEResult,
            E.Class, E.Level, E.Term, E.RegistrationYear, E.Residence, E.EntryStatus, E.Stream
        FROM Students S
        JOIN Enrollment E ON S.StudentID = E.StudentID
        LEFT JOIN Parents P ON S.StudentID = P.StudentID        
        LEFT JOIN AcademicHistory A ON S.StudentID = A.StudentID 
        WHERE S.StudentID = ?
    ";
    
    $stmt = $conn->prepare($sql);
    if ($stmt) {
        $stmt->bind_param("i", $student_id);
        $stmt->execute();
        $result = $stmt->get_result();
        $data = $result->fetch_assoc();
        
        if ($data) {
            echo json_encode(['success' => true, 'data' => $data]);
        } else {
            echo json_encode(['success' => false, 'message' => 'Student not found']);
        }
        $stmt->close();
    }
    $conn->close();
} else {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Database connection failed']);
}
?>