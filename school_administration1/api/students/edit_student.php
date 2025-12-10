<?php
// school_administration1/api/students/edit_student.php

require_once __DIR__ . '/../../config/config.php'; 
header('Content-Type: application/json');

global $DB_HOST, $DB_USER, $DB_PASS, $DB_NAME, $UPLOAD_FOLDER_REL, $UPLOAD_DIR_BASE;

$UPLOAD_DIR = $UPLOAD_DIR_BASE; 
$ALLOWED_EXTENSIONS = ['png', 'jpg', 'jpeg', 'gif'];
$MAX_FILE_SIZE = 5 * 1024 * 1024; 

function allowed_file($filename, $allowed_extensions) {
    if (empty($filename)) return false;
    $parts = explode('.', $filename);
    $extension = strtolower(end($parts));
    return in_array($extension, $allowed_extensions);
}

// Function to build dynamic SQL UPDATE statements
function build_dynamic_update($table, $id_col, $id_val, $field_map, $conn) {
    $updates = [];
    $types = "";
    $params = [];

    foreach ($field_map as $post_key => $db_col) {
        if (array_key_exists($post_key, $_POST)) {
            $val = trim(filter_input(INPUT_POST, $post_key, FILTER_SANITIZE_STRING));
            
            if ($post_key === 'AcademicYear') {
                $val = format_academic_year($val);
            }

            // Prevent clearing mandatory fields
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

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success' => false, 'message' => 'Method Not Allowed']);
    exit();
}

$student_id = filter_input(INPUT_POST, 'StudentID', FILTER_SANITIZE_NUMBER_INT);

if (!$student_id) {
    echo json_encode(['success' => false, 'message' => 'Missing required Student ID.']);
    exit();
}

$conn = get_db_connection_transactional($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
if (!$conn) {
    echo json_encode(['success' => false, 'message' => 'Database connection failed.']);
    exit();
}

try {
    $new_photo_path = null;
    $photo_updated = false;

    // --- 1. Handle Photo Upload ---
    if (isset($_FILES['photo']) && $_FILES['photo']['error'] === UPLOAD_ERR_OK) {
        $file = $_FILES['photo'];
        $filename = basename($file['name']);
        
        if ($file['size'] <= $MAX_FILE_SIZE && allowed_file($filename, $ALLOWED_EXTENSIONS)) {
            $sql_fetch = "SELECT PhotoPath FROM Students WHERE StudentID = ?";
            $stmt_fetch = $conn->prepare($sql_fetch);
            $stmt_fetch->bind_param("i", $student_id);
            $stmt_fetch->execute();
            $res = $stmt_fetch->get_result();
            $current_info = $res->fetch_assoc();
            $old_photo_path = $current_info['PhotoPath'] ?? null;
            $stmt_fetch->close();

            $folder_name = $student_id . '/';
            $STUDENT_DIR = $UPLOAD_DIR . $folder_name;
            
            if (!is_dir($STUDENT_DIR)) {
                if (!mkdir($STUDENT_DIR, 0777, true)) {
                    throw new Exception("Failed to create upload directory.");
                }
            }
            
            $extension = strtolower(pathinfo($filename, PATHINFO_EXTENSION));
            $safe_filename = $student_id . '_' . uniqid() . '.' . $extension; 
            $file_path = $STUDENT_DIR . $safe_filename;
            
            if (move_uploaded_file($file['tmp_name'], $file_path)) {
                $STUDENT_FOLDER_REL = rtrim($UPLOAD_FOLDER_REL, '/') . '/' . $folder_name;
                $new_photo_path = $STUDENT_FOLDER_REL . $safe_filename;
                $photo_updated = true;
                
                if ($old_photo_path) {
                    $clean_rel_path = str_replace($UPLOAD_FOLDER_REL, '', $old_photo_path);
                    if (strpos($clean_rel_path, '..') === false) {
                        $old_abs_path = $UPLOAD_DIR . $clean_rel_path;
                        if (file_exists($old_abs_path) && is_file($old_abs_path)) {
                            unlink($old_abs_path);
                        }
                    }
                }
            }
        }
    }

    if ($photo_updated) {
        $stmt_p = $conn->prepare("UPDATE Students SET PhotoPath = ? WHERE StudentID = ?");
        $stmt_p->bind_param("si", $new_photo_path, $student_id);
        $stmt_p->execute();
        $stmt_p->close();
    }

    // --- 2. Update Student Info (FIXED MAPS) ---
    $student_map = [
        'Name' => 'Name',
        'Surname' => 'Surname',
        'DateOfBirth' => 'DateOfBirth',
        'Gender' => 'Gender',
        // New Split Address Fields
        'HouseNo' => 'HouseNo',
        'Street' => 'Street',
        'Village' => 'Village',
        'Town' => 'Town',
        'District' => 'District',
        'State' => 'State',
        'Country' => 'Country'
    ];
    
    $parents_map = [
        'father_name' => 'father_name',
        'father_contact' => 'father_contact',
        'father_email' => 'father_email', // Added
        'father_age' => 'father_age',
        'father_occupation' => 'father_occupation',
        'father_education' => 'father_education',
        
        'mother_name' => 'mother_name',
        'mother_contact' => 'mother_contact',
        'mother_email' => 'mother_email', // Added
        'mother_age' => 'mother_age',
        'mother_occupation' => 'mother_occupation',
        'mother_education' => 'mother_education',
        
        'guardian_name' => 'guardian_name',
        'guardian_contact' => 'guardian_contact',
        'guardian_email' => 'guardian_email', // Added
        'guardian_relation' => 'guardian_relation',
        'guardian_age' => 'guardian_age',
        'guardian_occupation' => 'guardian_occupation',
        'guardian_education' => 'guardian_education',
        'guardian_address' => 'guardian_address',
        'GuardianNotes' => 'MoreInformation'
    ];

    $enrollment_map = [
        'Level' => 'Level',
        'Class' => 'Class',
        'Stream' => 'Stream',
        'Term' => 'Term',
        'Residence' => 'Residence',
        'EntryStatus' => 'EntryStatus',
        'AcademicYear' => 'AcademicYear'
    ];
    
    $academic_map = [
        'FormerSchool' => 'FormerSchool',
        'PLEIndexNumber' => 'PLEIndexNumber',
        'PLEAggregate' => 'PLEAggregate',
        'UCEIndexNumber' => 'UCEIndexNumber',
        'UCEResult' => 'UCEResult'
    ];

    build_dynamic_update('Students', 'StudentID', $student_id, $student_map, $conn);
    build_dynamic_update('Parents', 'StudentID', $student_id, $parents_map, $conn);
    build_dynamic_update('Enrollment', 'StudentID', $student_id, $enrollment_map, $conn);
    build_dynamic_update('AcademicHistory', 'StudentID', $student_id, $academic_map, $conn);

    $conn->commit();

    echo json_encode([
        'success' => true, 
        'message' => 'Student record updated successfully.',
        'data' => $_POST 
    ]);

} catch (Exception $e) {
    if ($conn) $conn->rollback();
    echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
} finally {
    if (isset($conn)) $conn->close();
}
?>