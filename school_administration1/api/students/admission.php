<?php
// school_administration1/api/students/admission.php

require_once __DIR__ . '/../../config/config.php';
header('Content-Type: application/json');

// Enable strict error reporting
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

// --- CONFIGURATION ---
$ALLOWED_RELATIONS = ['Brother', 'Sister', 'Uncle', 'Aunt', 'Grandparent', 'Other'];
$ALLOWED_RESIDENCE = ['Day', 'Boarding'];
$ALLOWED_ENTRY     = ['New', 'Continuing'];

$UPLOAD_DIR = $UPLOAD_DIR_BASE;
$ALLOWED_EXTENSIONS = ['png', 'jpg', 'jpeg', 'gif'];
$MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB

$uploaded_file_path = null; 
$conn = null;

try {
    // =========================================================
    // PHASE 1: STRICT PRE-VALIDATION (No Database Connection Yet)
    // =========================================================
    
    // 1. Personal Information Validation
    $name    = trim($_POST['name'] ?? '');
    $surname = trim($_POST['surname'] ?? '');
    $dob     = $_POST['dob'] ?? '';
    $gender  = $_POST['gender'] ?? '';
    
    if (empty($name) || empty($surname) || empty($dob) || empty($gender)) {
        throw new Exception("Personal Information (Name, Surname, DOB, Gender) is incomplete.");
    }

    // 2. Parents Validation (Mandatory Fields)
    $father_name = trim($_POST['father_name'] ?? '');
    $mother_name = trim($_POST['mother_name'] ?? '');
    
    if (empty($father_name) || empty($mother_name)) {
        throw new Exception("Father's and Mother's names are required.");
    }

    // 3. Guardian Validation (STRICT "ALL OR NOTHING" RULE)
    $g_name     = trim($_POST['guardian_name'] ?? '');
    $g_relation = trim($_POST['guardian_relation'] ?? '');
    $g_contact  = trim($_POST['guardian_contact'] ?? '');
    $g_email    = trim($_POST['guardian_email'] ?? '');
    $g_age      = trim($_POST['guardian_age'] ?? '');
    $g_occ      = trim($_POST['guardian_occupation'] ?? '');
    $g_edu      = trim($_POST['guardian_education'] ?? '');
    $g_addr     = trim($_POST['guardian_address'] ?? '');

    // Check if ANY field has data (Partial input check)
    $has_input = !empty($g_name) || !empty($g_relation) || !empty($g_contact) || 
                 !empty($g_email) || !empty($g_age) || !empty($g_occ) || 
                 !empty($g_edu) || !empty($g_addr);

    if ($has_input) {
        $missing = [];
        if (empty($g_name)) $missing[] = "Name";
        if (empty($g_relation)) $missing[] = "Relation";
        if (empty($g_contact)) $missing[] = "Contact";
        if (empty($g_email)) $missing[] = "Email";
        if (empty($g_age)) $missing[] = "Age";
        if (empty($g_occ)) $missing[] = "Occupation";
        if (empty($g_edu)) $missing[] = "Education";
        if (empty($g_addr)) $missing[] = "Address";

        // If ANYTHING is missing, block it entirely
        if (!empty($missing)) {
            throw new Exception("Guardian details cannot be partial. Since you provided some info, you must fill ALL guardian fields. Missing: " . implode(', ', $missing));
        }

        // Validate Relation specifically
        if (!in_array($g_relation, $ALLOWED_RELATIONS)) {
            throw new Exception("Invalid Guardian Relation. Allowed: " . implode(', ', $ALLOWED_RELATIONS));
        }
    }

    // 4. Enrollment Validation
    $residence    = $_POST['residence'] ?? '';
    $entry_status = $_POST['entry_status'] ?? '';
    $class_grade  = $_POST['class'] ?? '';
    $level        = $_POST['level'] ?? '';
    $term         = $_POST['term'] ?? '';

    if (empty($class_grade) || empty($level) || empty($term)) {
        throw new Exception("Enrollment details (Class, Level, Term) are required.");
    }
    
    if (!in_array($residence, $ALLOWED_RESIDENCE)) {
        throw new Exception("Invalid Residence. Please select Day or Boarding.");
    }
    if (!in_array($entry_status, $ALLOWED_ENTRY)) {
        throw new Exception("Invalid Entry Status. Please select New or Continuing.");
    }

    // 5. Photo Validation
    if (isset($_FILES['photo']) && $_FILES['photo']['error'] === UPLOAD_ERR_OK) {
        $file = $_FILES['photo'];
        $ext = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
        
        if ($file['size'] > $MAX_FILE_SIZE) {
            throw new Exception("Photo is too large. Max allowed size is 5MB.");
        }
        if (!in_array($ext, $ALLOWED_EXTENSIONS)) {
            throw new Exception("Invalid photo format. Allowed: " . implode(', ', $ALLOWED_EXTENSIONS));
        }
    }

    // =========================================================
    // PHASE 2: DATABASE OPERATION
    // =========================================================

    $conn = new mysqli($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
    if ($conn->connect_error) {
        throw new Exception("Database connection failed: " . $conn->connect_error);
    }

    $conn->begin_transaction();

    // Prepare Variables
    $admission_year = $_POST['admission_year'] ?? date('Y');
    $academic_year_string = format_academic_year($admission_year);
    
    // Address
    $house    = trim($_POST['house_no'] ?? '');
    $street   = trim($_POST['street'] ?? '');
    $village  = trim($_POST['village'] ?? '');
    $town     = trim($_POST['town'] ?? '');
    $district = trim($_POST['district'] ?? '');
    $state    = trim($_POST['state'] ?? '');
    $country  = trim($_POST['country'] ?? 'Uganda');

    // Parents Optional
    $father_contact = !empty($_POST['father_contact']) ? $_POST['father_contact'] : null;
    $mother_contact = !empty($_POST['mother_contact']) ? $_POST['mother_contact'] : null;
    $f_email        = !empty($_POST['father_email']) ? trim($_POST['father_email']) : null;
    $m_email        = !empty($_POST['mother_email']) ? trim($_POST['mother_email']) : null;
    
    // Guardian Final Variables (Either ALL Valid or ALL Null)
    $final_g_name     = $has_input ? $g_name : null;
    $final_g_relation = $has_input ? $g_relation : null;
    $final_g_contact  = $has_input ? $g_contact : null;
    $final_g_email    = $has_input ? $g_email : null;
    $final_g_age      = $has_input ? $g_age : null;
    $final_g_occ      = $has_input ? $g_occ : null;
    $final_g_edu      = $has_input ? $g_edu : null;
    $final_g_addr     = $has_input ? $g_addr : null;

    $stream = $_POST['stream'] ?? '';
    if (empty($stream) || $stream === 'Auto') {
        $stream = 'A';
    }

    // --- INSERT STUDENT ---
    $sql_stu = "INSERT INTO Students (AdmissionYear, Name, Surname, DateOfBirth, Gender, HouseNo, Street, Village, Town, District, State, Country, PhotoPath) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NULL)";
    $stmt_stu = $conn->prepare($sql_stu);
    $stmt_stu->bind_param("isssssssssss", $admission_year, $name, $surname, $dob, $gender, $house, $street, $village, $town, $district, $state, $country);
    $stmt_stu->execute();
    $student_id = $conn->insert_id; 
    $stmt_stu->close();

    // --- INSERT PARENTS ---
    $sql_par = "INSERT INTO Parents (
        StudentID, 
        father_name, father_contact, father_email, father_age, father_occupation, father_education, 
        mother_name, mother_contact, mother_email, mother_age, mother_occupation, mother_education, 
        guardian_name, guardian_relation, guardian_contact, guardian_email, guardian_age, guardian_occupation, guardian_education, guardian_address, 
        MoreInformation
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
    $stmt_par = $conn->prepare($sql_par);
    
    $f_age = !empty($_POST['father_age']) ? $_POST['father_age'] : null;
    $f_occ = $_POST['father_occupation'] ?? '';
    $f_edu = $_POST['father_education'] ?? '';
    $m_age = !empty($_POST['mother_age']) ? $_POST['mother_age'] : null;
    $m_occ = $_POST['mother_occupation'] ?? '';
    $m_edu = $_POST['mother_education'] ?? '';
    $more_info = $_POST['more_info'] ?? '';

    $stmt_par->bind_param("isssisssssissssssissss", 
        $student_id, 
        $father_name, $father_contact, $f_email, $f_age, $f_occ, $f_edu,
        $mother_name, $mother_contact, $m_email, $m_age, $m_occ, $m_edu,
        $final_g_name, $final_g_relation, $final_g_contact, $final_g_email, $final_g_age, $final_g_occ, $final_g_edu, $final_g_addr,
        $more_info
    );
    $stmt_par->execute();
    $stmt_par->close();

    // --- INSERT ACADEMIC HISTORY ---
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

    // --- INSERT ENROLLMENT ---
    $sql_enr = "INSERT INTO Enrollment (StudentID, AcademicYear, Term, Class, Level, Stream, Residence, EntryStatus) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    $stmt_enr = $conn->prepare($sql_enr);
    $stmt_enr->bind_param("isssssss", $student_id, $academic_year_string, $term, $class_grade, $level, $stream, $residence, $entry_status);
    $stmt_enr->execute();
    $stmt_enr->close();

    // --- PHOTO UPLOAD ---
    if (!is_dir($UPLOAD_DIR)) {
        if (!mkdir($UPLOAD_DIR, 0755, true)) {
             error_log("Failed to create upload directory");
        }
    }

    if (isset($_FILES['photo']) && $_FILES['photo']['error'] === UPLOAD_ERR_OK) {
        $file = $_FILES['photo'];
        // Re-check validation (redundant but safe)
        if ($file['size'] <= $MAX_FILE_SIZE) {
            $folder = $student_id . '/';
            if (!is_dir($UPLOAD_DIR . $folder)) mkdir($UPLOAD_DIR . $folder, 0755, true);
            
            $ext = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
            $safe_name = $student_id . '_' . uniqid() . '.' . $ext;
            
            if (move_uploaded_file($file['tmp_name'], $UPLOAD_DIR . $folder . $safe_name)) {
                $photo_path = $UPLOAD_FOLDER_REL . $folder . $safe_name;
                $uploaded_file_path = $UPLOAD_DIR . $folder . $safe_name;
                
                $conn->query("UPDATE Students SET PhotoPath = '$photo_path' WHERE StudentID = $student_id");
            }
        }
    }

    // ALL GOOD: Commit
    $conn->commit();
    echo json_encode(['success' => true, 'message' => "Student admitted successfully. ID: $student_id"]);

} catch (\Throwable $e) {
    // ERROR: Rollback
    if ($conn && $conn->ping()) {
        try {
            $conn->rollback(); 
        } catch (Exception $ex) {
            error_log("Rollback Failed: " . $ex->getMessage());
        }
    }
    
    // Clean up photo if uploaded
    if ($uploaded_file_path && file_exists($uploaded_file_path)) {
        unlink($uploaded_file_path);
        $folder_path = dirname($uploaded_file_path);
        @rmdir($folder_path);
    }

    send_json_error($e->getMessage());
} finally {
    if ($conn) $conn->close();
}
?>