<?php
require_once 'config.php';
ob_start();

global $DB_HOST, $DB_USER, $DB_PASS, $DB_NAME, $UPLOAD_FOLDER_REL, $UPLOAD_DIR_BASE;

$UPLOAD_DIR = $UPLOAD_DIR_BASE; 
$ALLOWED_EXTENSIONS = ['png', 'jpg', 'jpeg', 'gif'];
$MAX_FILE_SIZE = 5 * 1024 * 1024; 
$REDIRECT_SUCCESS = 'studentmanagement.php?status=success'; 

if (!is_dir($UPLOAD_DIR)) {
    if (!mkdir($UPLOAD_DIR, 0755, true)) error_log("Failed to create upload directory: " . $UPLOAD_DIR);
}

function allowed_file($filename, $allowed_extensions) {
    if (empty($filename)) return false;
    $parts = explode('.', $filename);
    $extension = strtolower(end($parts));
    return in_array($extension, $allowed_extensions);
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    exit("Method Not Allowed.");
}

$photo_temp_info = null;
if (isset($_FILES['photo']) && $_FILES['photo']['error'] === UPLOAD_ERR_OK) {
    $photo_temp_info = $_FILES['photo'];
}

try {
    // --- 1. Basic Student Info ---
    $name = $_POST['name'] ?? null;
    $surname = $_POST['surname'] ?? null;
    $dob = $_POST['dob'] ?? null;
    $gender = $_POST['gender'] ?? null;
    $address = $_POST['address'] ?? '';
    
    // YEAR HANDLING
    $admission_year = $_POST['admission_year'] ?? date('Y');
    $academic_year_string = format_academic_year($admission_year); // 20##-## conversion

    // --- 2. Parents Info (Strict Check) ---
    $father_name = trim($_POST['father_name'] ?? '');
    $mother_name = trim($_POST['mother_name'] ?? '');
    
    // Optional Parent Fields
    $father_contact = $_POST['father_contact'] ?? null;
    $father_age = $_POST['father_age'] ?? null;
    $father_occupation = $_POST['father_occupation'] ?? null;
    $father_education = $_POST['father_education'] ?? null;
    $mother_contact = $_POST['mother_contact'] ?? null;
    $mother_age = $_POST['mother_age'] ?? null;
    $mother_occupation = $_POST['mother_occupation'] ?? null;
    $mother_education = $_POST['mother_education'] ?? null;

    if (empty($father_name) || empty($mother_name)) {
        throw new Exception("Validation Error: Father's Name and Mother's Name are mandatory.");
    }

    // Guardian Fields
    $guardian_name = !empty($_POST['guardian_name']) ? $_POST['guardian_name'] : null;
    $guardian_contact = $_POST['guardian_contact'] ?? null;
    $guardian_relation = $_POST['guardian_relation'] ?? null;
    $guardian_age = $_POST['guardian_age'] ?? null;
    $guardian_occupation = $_POST['guardian_occupation'] ?? null;
    $guardian_education = $_POST['guardian_education'] ?? null;
    $guardian_address = $_POST['guardian_address'] ?? null;

    // --- 3. Academic Records (Mandatory Validation) ---
    $former_school = trim($_POST['former_school'] ?? '');
    $ple_index = trim($_POST['ple_index'] ?? '');
    $uce_index = $_POST['uce_index'] ?? '';
    $uce_result = $_POST['uce_result'] ?? '';
    $ple_agg = (!empty($_POST['ple_agg']) && is_numeric($_POST['ple_agg'])) ? (int)$_POST['ple_agg'] : null;

    if (empty($former_school) || empty($ple_index)) {
        throw new Exception("Validation Error: Former School and PLE Index Number are mandatory.");
    }

    // --- 4. Enrollment Data ---
    $class_grade = $_POST['class'] ?? '';
    $term = $_POST['term'] ?? '';
    $residence = $_POST['residence'] ?? '';
    $entry_status = $_POST['entry_status'] ?? '';
    $stream = $_POST['stream'] ?? '';
    $level = $_POST['level'] ?? '';
    
    // --- 5. Additional Info (Mandatory Validation) ---
    $more_info = trim($_POST['more_info'] ?? '');
    if (empty($more_info)) {
        throw new Exception("Validation Error: Additional Information field is required.");
    }

    // Global Required Field Check
    $required_fields = ['name', 'surname', 'dob', 'gender', 'admission_year', 'level', 'class', 'term', 'residence', 'entry_status'];
    foreach ($required_fields as $field) {
        if (empty($_POST[$field])) throw new Exception("Missing required form field: " . ucfirst(str_replace('_', ' ', $field)));
    }

    $conn = get_db_connection_transactional($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
    if ($conn === null) throw new Exception("Database connection failed.");

    // CAPACITY CHECK
    $check_capacity_sql = "SELECT COUNT(*) as count FROM Enrollment WHERE AcademicYear = ? AND Class = ? AND Stream = ?";
    $stmt_cap = $conn->prepare($check_capacity_sql);
    $stmt_cap->bind_param("sss", $academic_year_string, $class_grade, $stream);
    $stmt_cap->execute();
    $cap_result = $stmt_cap->get_result()->fetch_assoc();
    $stmt_cap->close();

    if ($cap_result['count'] >= MAX_STUDENTS_PER_STREAM) {
        throw new Exception("Admission Blocked: Class $class_grade (Stream $stream) is full for $academic_year_string.");
    }

    // A. Insert Student
    $sql_student = "INSERT INTO Students (AdmissionYear, Name, Surname, DateOfBirth, Gender, CurrentAddress, PhotoPath) VALUES (?, ?, ?, ?, ?, ?, ?)";
    $stmt_student = $conn->prepare($sql_student);
    $null_photo = null;
    $stmt_student->bind_param("issssss", $admission_year, $name, $surname, $dob, $gender, $address, $null_photo);
    if (!$stmt_student->execute()) throw new Exception("Execution failed for Students: " . $stmt_student->error);
    $student_id = $conn->insert_id;
    $stmt_student->close();
    
    // B. Photo Upload
    if ($photo_temp_info !== null) {
        $file = $photo_temp_info;
        $filename = basename($file['name']);
        if ($file['size'] <= $MAX_FILE_SIZE && allowed_file($filename, $ALLOWED_EXTENSIONS)) {
            $folder_name = $student_id . '/'; 
            $STUDENT_DIR = $UPLOAD_DIR . $folder_name;
            $STUDENT_FOLDER_REL = $UPLOAD_FOLDER_REL . $folder_name;
            if (!is_dir($STUDENT_DIR) && !mkdir($STUDENT_DIR, 0755, true)) throw new Exception("Failed to create student directory");
            
            $safe_filename = $student_id . '_' . uniqid() . '.' . strtolower(pathinfo($filename, PATHINFO_EXTENSION)); 
            if (move_uploaded_file($file['tmp_name'], $STUDENT_DIR . $safe_filename)) {
                $photo_path = $STUDENT_FOLDER_REL . $safe_filename;
                $stmt_up = $conn->prepare("UPDATE Students SET PhotoPath = ? WHERE StudentID = ?");
                $stmt_up->bind_param("si", $photo_path, $student_id);
                $stmt_up->execute();
                $stmt_up->close();
            }
        }
    }

    // C. Insert Parents
    $sql_parents = "INSERT INTO Parents (
        StudentID, father_name, father_age, father_contact, father_occupation, father_education,
        mother_name, mother_age, mother_contact, mother_occupation, mother_education,
        guardian_name, guardian_relation, guardian_age, guardian_contact, guardian_occupation, guardian_education, guardian_address,
        MoreInformation
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
    $stmt_parents = $conn->prepare($sql_parents);
    $stmt_parents->bind_param("isisssissssssisssss", 
        $student_id, $father_name, $father_age, $father_contact, $father_occupation, $father_education,
        $mother_name, $mother_age, $mother_contact, $mother_occupation, $mother_education,
        $guardian_name, $guardian_relation, $guardian_age, $guardian_contact, $guardian_occupation, $guardian_education, $guardian_address,
        $more_info
    );
    $stmt_parents->execute();
    $stmt_parents->close();

    // D. Insert AcademicHistory
    $stmt_acad = $conn->prepare("INSERT INTO AcademicHistory (StudentID, FormerSchool, PLEIndexNumber, PLEAggregate, UCEIndexNumber, UCEResult) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt_acad->bind_param("isisss", $student_id, $former_school, $ple_index, $ple_agg, $uce_index, $uce_result);
    $stmt_acad->execute();
    $stmt_acad->close();

    // E. Insert Enrollment
    $stmt_enrol = $conn->prepare("INSERT INTO Enrollment (StudentID, AcademicYear, Term, Class, Level, Stream, Residence, EntryStatus) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
    $stmt_enrol->bind_param("isssssss", $student_id, $academic_year_string, $term, $class_grade, $level, $stream, $residence, $entry_status);
    $stmt_enrol->execute();
    $stmt_enrol->close();

    $conn->commit();
    header("Location: " . $REDIRECT_SUCCESS . "&id=" . $student_id . "#admission");
    exit();

} catch (Exception $e) {
    if (isset($conn)) $conn->rollback();
    error_log("Database error: " . $e->getMessage());
    exit("Error: " . $e->getMessage());
} finally {
    if (isset($conn)) $conn->close();
    ob_end_clean();
}
?>