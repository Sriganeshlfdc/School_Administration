<?php
// school_administration1/api/students/edit_student.php

require_once __DIR__ . '/../../config/config.php'; 
header('Content-Type: application/json');

global $DB_HOST, $DB_USER, $DB_PASS, $DB_NAME, $UPLOAD_FOLDER_REL, $UPLOAD_DIR_BASE;

$UPLOAD_DIR = $UPLOAD_DIR_BASE; 
$ALLOWED_EXTENSIONS = ['png', 'jpg', 'jpeg', 'gif'];
$MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
$ALLOWED_RELATIONS = ['Brother', 'Sister', 'Uncle', 'Aunt', 'Grandparent', 'Other'];

// --- HELPER FUNCTIONS ---
function allowed_file($filename, $allowed_extensions) {
    if (empty($filename)) return false;
    $parts = explode('.', $filename);
    $extension = strtolower(end($parts));
    return in_array($extension, $allowed_extensions);
}

function build_dynamic_update($table, $id_col, $id_val, $field_map, $conn) {
    $updates = [];
    $types = "";
    $params = [];

    foreach ($field_map as $post_key => $db_col) {
        if (array_key_exists($post_key, $_POST)) {
            $val = trim(filter_input(INPUT_POST, $post_key, FILTER_SANITIZE_STRING));
            if ($post_key === 'AcademicYear') $val = format_academic_year($val);
            if ($val === '') $val = null;

            $mandatory_fields = ['Name', 'Surname', 'father_name', 'mother_name'];
            if (in_array($post_key, $mandatory_fields) && empty($val)) {
                throw new Exception("Field '$post_key' cannot be empty.");
            }

            $updates[] = "$db_col = ?";
            $types .= "s"; 
            $params[] = $val;
        }
    }

    if (empty($updates)) return true;

    $sql = "UPDATE $table SET " . implode(', ', $updates) . " WHERE $id_col = ?";
    $types .= "i";
    $params[] = $id_val;

    $stmt = $conn->prepare($sql);
    if (!$stmt) throw new Exception("Prepare failed for $table: " . $conn->error);
    
    $stmt->bind_param($types, ...$params);
    if (!$stmt->execute()) throw new Exception("Execute failed for $table: " . $stmt->error);
    $stmt->close();
    return true;
}

// --- MAIN EXECUTION ---

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success' => false, 'message' => 'Method Not Allowed']);
    exit();
}

// 1. Get Basic Info
$Ad_no = filter_input(INPUT_POST, 'AdmissionNo', FILTER_SANITIZE_NUMBER_INT);
$action = $_POST['action'] ?? 'update';

if (!$Ad_no) {
    echo json_encode(['success' => false, 'message' => 'Missing required Student ID.']);
    exit();
}

// =========================================================
// ACTION: DELETE TEMP FILE (Cleanup on Cancel)
// =========================================================
if ($action === 'delete_temp') {
    $fileName = filter_input(INPUT_POST, 'fileName', FILTER_SANITIZE_STRING);
    
    if (!$fileName) {
        echo json_encode(['success' => false, 'message' => 'No filename provided']);
        exit;
    }

    // Security: Only allow deleting files starting with 'temp_' inside the student's folder
    $fileName = basename($fileName); // Prevent directory traversal
    if (strpos($fileName, 'temp_') !== 0) {
        echo json_encode(['success' => false, 'message' => 'Invalid file selection']);
        exit;
    }

    $targetPath = $UPLOAD_DIR . $Ad_no . '/' . $fileName;

    if (file_exists($targetPath)) {
        if (unlink($targetPath)) {
            echo json_encode(['success' => true, 'message' => 'Temp file deleted']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Could not delete file']);
        }
    } else {
        echo json_encode(['success' => true, 'message' => 'File already gone']);
    }
    exit;
}

// =========================================================
// ACTION: UPDATE PROFILE (Save Changes)
// =========================================================

$conn = get_db_connection_transactional($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
if (!$conn) {
    echo json_encode(['success' => false, 'message' => 'Database connection failed.']);
    exit();
}

try {
    // [Guardian Validation Logic Omitted for Brevity - It remains the same as before]
    
    // ... (Existing Guardian Validation code goes here) ...

    // --- PHOTO HANDLING ---
    $new_photo_path = null;
    $photo_updated = false;

    // A. Commit Temp File (Rename temp_xxx.jpg -> xxx.jpg)
    $temp_filename = filter_input(INPUT_POST, 'temp_photo_filename', FILTER_SANITIZE_STRING);
    
    if (!empty($temp_filename)) {
        $temp_abs_path = $UPLOAD_DIR . $Ad_no . '/' . $temp_filename;
        
        if (file_exists($temp_abs_path)) {
            // Generate Permanent Name (Remove 'temp_' prefix, add randomness)
            $ext = pathinfo($temp_filename, PATHINFO_EXTENSION);
            $perm_filename = $Ad_no . '_' . uniqid() . '.' . $ext;
            $perm_abs_path = $UPLOAD_DIR . $Ad_no . '/' . $perm_filename;
            
            if (rename($temp_abs_path, $perm_abs_path)) {
                $STUDENT_FOLDER_REL = rtrim($UPLOAD_FOLDER_REL, '/') . '/' . $Ad_no . '/';
                $new_photo_path = $STUDENT_FOLDER_REL . $perm_filename;
                $photo_updated = true;
            }
        }
    }
    // B. Direct Upload (Fallback)
    else if (isset($_FILES['photo']) && $_FILES['photo']['error'] === UPLOAD_ERR_OK) {
        $file = $_FILES['photo'];
        $filename = basename($file['name']);
        
        if ($file['size'] <= $MAX_FILE_SIZE && allowed_file($filename, $ALLOWED_EXTENSIONS)) {
            $folder_name = $Ad_no . '/';
            $STUDENT_DIR = $UPLOAD_DIR . $folder_name;
            if (!is_dir($STUDENT_DIR)) mkdir($STUDENT_DIR, 0777, true);
            
            $extension = strtolower(pathinfo($filename, PATHINFO_EXTENSION));
            $safe_filename = $Ad_no . '_' . uniqid() . '.' . $extension; 
            $file_path = $STUDENT_DIR . $safe_filename;
            
            if (move_uploaded_file($file['tmp_name'], $file_path)) {
                $new_photo_path = rtrim($UPLOAD_FOLDER_REL, '/') . '/' . $folder_name . $safe_filename;
                $photo_updated = true;
            }
        }
    }

    if ($photo_updated) {
        $stmt_p = $conn->prepare("UPDATE Students SET PhotoPath = ? WHERE AdmissionNo = ?");
        $stmt_p->bind_param("si", $new_photo_path, $Ad_no);
        $stmt_p->execute();
        $stmt_p->close();
        // Old photo is NOT deleted, acting as backup.
    }

    // --- DATA UPDATES ---
    $student_map = ['Name'=>'Name','Surname'=>'Surname','DateOfBirth'=>'DateOfBirth','Gender'=>'Gender','HouseNo'=>'HouseNo','Street'=>'Street','Village'=>'Village','Town'=>'Town','District'=>'District','State'=>'State','Country'=>'Country'];
    $parents_map = ['father_name'=>'father_name','father_contact'=>'father_contact','father_email'=>'father_email','father_age'=>'father_age','father_occupation'=>'father_occupation','father_education'=>'father_education','mother_name'=>'mother_name','mother_contact'=>'mother_contact','mother_email'=>'mother_email','mother_age'=>'mother_age','mother_occupation'=>'mother_occupation','mother_education'=>'mother_education','guardian_name'=>'guardian_name','guardian_contact'=>'guardian_contact','guardian_email'=>'guardian_email','guardian_relation'=>'guardian_relation','guardian_age'=>'guardian_age','guardian_occupation'=>'guardian_occupation','guardian_education'=>'guardian_education','guardian_address'=>'guardian_address','GuardianNotes'=>'MoreInformation'];
    $enrollment_map = ['Level'=>'Level','Class'=>'Class','Stream'=>'Stream','Term'=>'Term','Residence'=>'Residence','EntryStatus'=>'EntryStatus','AcademicYear'=>'AcademicYear'];
    $academic_map = ['FormerSchool'=>'FormerSchool','PLEIndexNumber'=>'PLEIndexNumber','PLEAggregate'=>'PLEAggregate','UCEIndexNumber'=>'UCEIndexNumber','UCEResult'=>'UCEResult'];

    build_dynamic_update('Students', 'AdmissionNo', $Ad_no, $student_map, $conn);
    build_dynamic_update('Parents', 'AdmissionNo', $Ad_no, $parents_map, $conn);
    build_dynamic_update('Enrollment', 'AdmissionNo', $Ad_no, $enrollment_map, $conn);
    build_dynamic_update('AcademicHistory', 'AdmissionNo', $Ad_no, $academic_map, $conn);

    $conn->commit();

    echo json_encode(['success' => true, 'message' => 'Student record updated successfully.']);

} catch (Exception $e) {
    if ($conn) $conn->rollback();
    echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
} finally {
    if (isset($conn)) $conn->close();
}
?>