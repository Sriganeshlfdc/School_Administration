<?php
// school_administration1/api/students/edit_student.php

// 1. Load Configuration
require_once __DIR__ . '/../../config/config.php'; 
header('Content-Type: application/json');

// 2. Setup Globals & Constants
global $DB_HOST, $DB_USER, $DB_PASS, $DB_NAME, $UPLOAD_FOLDER_REL, $UPLOAD_DIR_BASE;

// Use the absolute path defined in config.php for file operations
$UPLOAD_DIR = $UPLOAD_DIR_BASE; 
$ALLOWED_EXTENSIONS = ['png', 'jpg', 'jpeg', 'gif'];
$MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB

// --- Helper Functions ---

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
            
            // Special formatting for Academic Year
            if ($post_key === 'AcademicYear') {
                $val = format_academic_year($val);
            }

            // Validation: Prevent clearing mandatory fields
            $mandatory_fields = ['Name', 'Surname', 'father_name', 'mother_name'];
            if (in_array($post_key, $mandatory_fields) && empty($val)) {
                throw new Exception("Field '$post_key' cannot be empty.");
            }

            $updates[] = "$db_col = ?";
            $types .= "s"; 
            $params[] = $val;
        }
    }

    // If nothing to update for this table, return success
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

// --- Main Request Handling ---

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method Not Allowed']);
    exit();
}

$student_id = filter_input(INPUT_POST, 'StudentID', FILTER_SANITIZE_NUMBER_INT);

if (!$student_id) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Missing required Student ID.']);
    exit();
}

$conn = get_db_connection_transactional($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
if (!$conn) {
    http_response_code(500);
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
            // A. Fetch old photo path to delete later
            $sql_fetch = "SELECT PhotoPath FROM Students WHERE StudentID = ?";
            $stmt_fetch = $conn->prepare($sql_fetch);
            $stmt_fetch->bind_param("i", $student_id);
            $stmt_fetch->execute();
            $res = $stmt_fetch->get_result();
            $current_info = $res->fetch_assoc();
            $old_photo_path = $current_info['PhotoPath'] ?? null;
            $stmt_fetch->close();

            // B. Prepare Upload Directory
            $folder_name = $student_id . '/';
            $STUDENT_DIR = $UPLOAD_DIR . $folder_name;
            
            // Create directory if it doesn't exist (using 0777 for wider permission compatibility during dev)
            if (!is_dir($STUDENT_DIR)) {
                if (!mkdir($STUDENT_DIR, 0777, true)) {
                    throw new Exception("Failed to create upload directory: " . $STUDENT_DIR);
                }
            }
            
            $extension = strtolower(pathinfo($filename, PATHINFO_EXTENSION));
            $safe_filename = $student_id . '_' . uniqid() . '.' . $extension; 
            $file_path = $STUDENT_DIR . $safe_filename;
            
            // C. Attempt Move
            if (move_uploaded_file($file['tmp_name'], $file_path)) {
                // Construct relative path for DB (e.g., assets/uploads/123/file.jpg)
                // Remove trailing slashes from base and ensure single slash separator
                $STUDENT_FOLDER_REL = rtrim($UPLOAD_FOLDER_REL, '/') . '/' . $folder_name;
                $new_photo_path = $STUDENT_FOLDER_REL . $safe_filename;
                $photo_updated = true;
                
                // D. Delete Old Photo
                if ($old_photo_path) {
                    // Convert stored relative path to absolute path
                    $clean_rel_path = str_replace($UPLOAD_FOLDER_REL, '', $old_photo_path);
                    // Prevent deleting files outside upload dir (basic directory traversal check)
                    if (strpos($clean_rel_path, '..') === false) {
                        $old_abs_path = $UPLOAD_DIR . $clean_rel_path;
                        if (file_exists($old_abs_path) && is_file($old_abs_path)) {
                            unlink($old_abs_path);
                        }
                    }
                }
            } else {
                throw new Exception("Failed to move uploaded file. Check folder permissions.");
            }
        } else {
            throw new Exception("Invalid file type or file size too large (Max 5MB).");
        }
    } elseif (isset($_FILES['photo']) && $_FILES['photo']['error'] !== UPLOAD_ERR_NO_FILE) {
        throw new Exception("File upload failed with error code: " . $_FILES['photo']['error']);
    }

    // --- 2. Update Student Info ---
    
    // Explicitly update Photo in DB if it was changed
    if ($photo_updated) {
        $stmt_p = $conn->prepare("UPDATE Students SET PhotoPath = ? WHERE StudentID = ?");
        $stmt_p->bind_param("si", $new_photo_path, $student_id);
        if (!$stmt_p->execute()) {
            throw new Exception("Database update for photo failed: " . $stmt_p->error);
        }
        $stmt_p->close();
    }

    // Define Mappings for other tables
    $student_map = [
        'Name' => 'Name',
        'Surname' => 'Surname',
        'Address' => 'CurrentAddress',
        'DateOfBirth' => 'DateOfBirth',
        'Gender' => 'Gender'
    ];
    
    $parents_map = [
        'father_name' => 'father_name',
        'father_age' => 'father_age',
        'father_contact' => 'father_contact',
        'father_occupation' => 'father_occupation',
        'father_education' => 'father_education',
        'mother_name' => 'mother_name',
        'mother_age' => 'mother_age',
        'mother_contact' => 'mother_contact',
        'mother_occupation' => 'mother_occupation',
        'mother_education' => 'mother_education',
        'guardian_name' => 'guardian_name',
        'guardian_relation' => 'guardian_relation',
        'guardian_age' => 'guardian_age',
        'guardian_contact' => 'guardian_contact',
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

    // Execute Updates
    build_dynamic_update('Students', 'StudentID', $student_id, $student_map, $conn);
    build_dynamic_update('Parents', 'StudentID', $student_id, $parents_map, $conn);
    build_dynamic_update('Enrollment', 'StudentID', $student_id, $enrollment_map, $conn);
    build_dynamic_update('AcademicHistory', 'StudentID', $student_id, $academic_map, $conn);

    // Commit Transaction
    $conn->commit();

    // Prepare response
    $response_data = $_POST;
    if ($new_photo_path) $response_data['photo_path'] = $new_photo_path;

    echo json_encode([
        'success' => true, 
        'message' => 'Student record updated successfully.',
        'data' => $response_data 
    ]);

} catch (Exception $e) {
    if ($conn) $conn->rollback();
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
} finally {
    if (isset($conn)) $conn->close();
}
?>