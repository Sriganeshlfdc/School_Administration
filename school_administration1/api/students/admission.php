<?php
// school_administration1/api/students/admission.php

require_once __DIR__ . '/../../config/config.php';
header('Content-Type: application/json');

// Enable strict error reporting to catch SQL issues
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
ini_set('display_errors', 0); 
ini_set('log_errors', 1);

function send_json_error($message) {
    echo json_encode(['success' => false, 'message' => $message]);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    send_json_error('Method Not Allowed');
}

global $DB_HOST, $DB_USER, $DB_PASS, $DB_NAME, $UPLOAD_DIR_BASE, $UPLOAD_FOLDER_REL;

$UPLOAD_DIR = $UPLOAD_DIR_BASE;
$ALLOWED_EXTENSIONS = ['png', 'jpg', 'jpeg', 'gif'];
$MAX_FILE_SIZE = 5 * 1024 * 1024; 

if (!is_dir($UPLOAD_DIR)) {
    if (!mkdir($UPLOAD_DIR, 0755, true)) {
        send_json_error("Failed to create upload directory.");
    }
}

function allowed_file($filename, $allowed_extensions) {
    if (empty($filename)) return false;
    $ext = strtolower(pathinfo($filename, PATHINFO_EXTENSION));
    return in_array($ext, $allowed_extensions);
}

// Regex Patterns
$phone_pattern = '/^\+256\d{9}$/'; // Strict Uganda format

$uploaded_file_path = null; 
$conn = null;

try {
    // 1. Establish Connection
    $conn = new mysqli($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
    if ($conn->connect_error) {
        throw new Exception("Connection failed: " . $conn->connect_error);
    }

    // 2. START TRANSACTION
    // This ensures nothing is saved permanently until $conn->commit() is called
    $conn->begin_transaction();

    // --- 3. Gather & Validate Input ---
    $name = trim($_POST['name'] ?? '');
    $surname = trim($_POST['surname'] ?? '');
    $dob = $_POST['dob'] ?? '';
    $gender = $_POST['gender'] ?? '';
    $admission_year = $_POST['admission_year'] ?? date('Y');
    
    // Address
    $house = trim($_POST['house_no'] ?? '');
    $street = trim($_POST['street'] ?? '');
    $village = trim($_POST['village'] ?? '');
    $town = trim($_POST['town'] ?? '');
    $district = trim($_POST['district'] ?? '');
    $state = trim($_POST['state'] ?? '');
    $country = trim($_POST['country'] ?? 'Uganda');
    
    if (empty($name) || empty($surname) || empty($dob) || empty($gender)) {
        throw new Exception("Personal Information incomplete.");
    }

    $academic_year_string = format_academic_year($admission_year);

    // Parents
    $father_name = trim($_POST['father_name'] ?? '');
    $mother_name = trim($_POST['mother_name'] ?? '');
    $father_contact = $_POST['father_contact'] ?? '';
    $mother_contact = $_POST['mother_contact'] ?? '';
    $f_email = trim($_POST['father_email'] ?? '');
    $m_email = trim($_POST['mother_email'] ?? '');
    $g_email = trim($_POST['guardian_email'] ?? '');

    if (empty($father_name) || empty($mother_name)) {
        throw new Exception("Father's and Mother's names are required.");
    }
    
    // Guardian
    $g_name = trim($_POST['guardian_name'] ?? '');
    $g_contact = trim($_POST['guardian_contact'] ?? '');
    $g_relation = trim($_POST['guardian_relation'] ?? '');
    
    if (!empty($g_name) && (empty($g_contact) || empty($g_relation))) {
        throw new Exception("Guardian Contact and Relation are required if Guardian Name is provided.");
    }

    // Enrollment
    $class_grade = $_POST['class'] ?? '';
    $stream = $_POST['stream'] ?? '';
    $term = $_POST['term'] ?? '';
    $level = $_POST['level'] ?? '';
    $residence = $_POST['residence'] ?? '';
    $entry_status = $_POST['entry_status'] ?? '';

    if (empty($class_grade) || empty($level) || empty($term)) {
        throw new Exception("Enrollment details (Class, Level, Term) are required.");
    }

    // Stream Logic
    if (empty($stream) || $stream === 'Auto') {
        $stream = 'A'; // Simplified default for safety, extend with auto-assign logic if needed
    }

    // --- 4. INSERT STUDENT ---
    $sql_stu = "INSERT INTO Students (AdmissionYear, Name, Surname, DateOfBirth, Gender, HouseNo, Street, Village, Town, District, State, Country, PhotoPath) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NULL)";
    
    $stmt_stu = $conn->prepare($sql_stu);
    $stmt_stu->bind_param("isssssssssss", $admission_year, $name, $surname, $dob, $gender, $house, $street, $village, $town, $district, $state, $country);
    $stmt_stu->execute();
    $student_id = $conn->insert_id; // Get the ID of the new row
    $stmt_stu->close();

    // --- 5. INSERT PARENTS ---
    // If this fails, the catch block will trigger rollback, undoing the Student Insert
    $sql_par = "INSERT INTO Parents (
        StudentID, 
        father_name, father_contact, father_email, father_age, father_occupation, father_education, 
        mother_name, mother_contact, mother_email, mother_age, mother_occupation, mother_education, 
        guardian_name, guardian_relation, guardian_contact, guardian_email, guardian_age, guardian_occupation, guardian_address, 
        MoreInformation
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
    $stmt_par = $conn->prepare($sql_par);
    
    $f_age = $_POST['father_age'] ?: null;
    $f_occ = $_POST['father_occupation'] ?? '';
    $f_edu = $_POST['father_education'] ?? '';
    $m_age = $_POST['mother_age'] ?: null;
    $m_occ = $_POST['mother_occupation'] ?? '';
    $m_edu = $_POST['mother_education'] ?? '';
    $g_age = $_POST['guardian_age'] ?: null;
    $g_occ = $_POST['guardian_occupation'] ?? '';
    $g_addr = $_POST['guardian_address'] ?? '';
    $more_info = $_POST['more_info'] ?? '';

    $stmt_par->bind_param("isssisssssissssssisss", 
        $student_id, 
        $father_name, $father_contact, $f_email, $f_age, $f_occ, $f_edu,
        $mother_name, $mother_contact, $m_email, $m_age, $m_occ, $m_edu,
        $g_name, $g_relation, $g_contact, $g_email, $g_age, $g_occ, $g_addr,
        $more_info
    );
    $stmt_par->execute();
    $stmt_par->close();

    // --- 6. INSERT ACADEMIC HISTORY ---
    $sql_hist = "INSERT INTO AcademicHistory (StudentID, FormerSchool, PLEIndexNumber, PLEAggregate, UCEIndexNumber, UCEResult) VALUES (?, ?, ?, ?, ?, ?)";
    $stmt_hist = $conn->prepare($sql_hist);
    
    $former = $_POST['former_school'] ?? '';
    $ple_idx = $_POST['ple_index'] ?? '';
    $ple_agg = !empty($_POST['ple_agg']) ? $_POST['ple_agg'] : null;
    $uce_idx = $_POST['uce_index'] ?? '';
    $uce_res = $_POST['uce_result'] ?? '';

    $stmt_hist->bind_param("ississ", $student_id, $former, $ple_idx, $ple_agg, $uce_idx, $uce_res);
    $stmt_hist->execute();
    $stmt_hist->close();

    // --- 7. INSERT ENROLLMENT ---
    $sql_enr = "INSERT INTO Enrollment (StudentID, AcademicYear, Term, Class, Level, Stream, Residence, EntryStatus) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    $stmt_enr = $conn->prepare($sql_enr);
    $stmt_enr->bind_param("isssssss", $student_id, $academic_year_string, $term, $class_grade, $level, $stream, $residence, $entry_status);
    $stmt_enr->execute();
    $stmt_enr->close();

    // --- 8. PHOTO UPLOAD (Optional) ---
    if (isset($_FILES['photo']) && $_FILES['photo']['error'] === UPLOAD_ERR_OK) {
        $file = $_FILES['photo'];
        if ($file['size'] <= $MAX_FILE_SIZE && allowed_file($file['name'], $ALLOWED_EXTENSIONS)) {
            $folder = $student_id . '/';
            if (!is_dir($UPLOAD_DIR . $folder)) mkdir($UPLOAD_DIR . $folder, 0755, true);
            
            $ext = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
            $safe_name = $student_id . '_' . uniqid() . '.' . $ext;
            
            if (move_uploaded_file($file['tmp_name'], $UPLOAD_DIR . $folder . $safe_name)) {
                $photo_path = $UPLOAD_FOLDER_REL . $folder . $safe_name;
                $uploaded_file_path = $UPLOAD_DIR . $folder . $safe_name;
                
                // Update DB with photo path
                $conn->query("UPDATE Students SET PhotoPath = '$photo_path' WHERE StudentID = $student_id");
            }
        }
    }

    // ALL GOOD: Commit the transaction
    $conn->commit();
    echo json_encode(['success' => true, 'message' => "Student admitted successfully. ID: $student_id"]);

} catch (\Throwable $e) {
    // ERROR OCCURRED: Rollback everything
    if ($conn) {
        try {
            $conn->rollback(); 
        } catch (Exception $ex) {
            // Log if rollback itself fails
            error_log("Rollback Failed: " . $ex->getMessage());
        }
    }
    
    // Clean up file if it was uploaded but DB failed
    if ($uploaded_file_path && file_exists($uploaded_file_path)) {
        unlink($uploaded_file_path);
        $folder_path = dirname($uploaded_file_path);
        @rmdir($folder_path);
    }

    send_json_error("Error: " . $e->getMessage());
} finally {
    if ($conn) $conn->close();
}
?>