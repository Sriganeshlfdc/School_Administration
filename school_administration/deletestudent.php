<?php
// webpages/deletestudent.php
require_once 'config.php';

// Use global constants from config.php
global $DB_HOST, $DB_USER, $DB_PASS, $DB_NAME, $UPLOAD_FOLDER_REL, $UPLOAD_DIR_BASE;

// Ensure UPLOAD_DIR_BASE is available
$UPLOAD_DIR = $UPLOAD_DIR_BASE; 

$REDIRECT_SUCCESS = 'studentmanagement.php?status=delete_success#list'; 
$REDIRECT_FAILURE = 'studentmanagement.php?status=delete_error#list'; 

// Recursive function to delete a directory and its contents
function rmdir_recursive($dir) {
    global $UPLOAD_DIR_BASE;
    // Security check: Ensure we are only deleting within the expected uploads folder
    if (!isset($UPLOAD_DIR_BASE) || strpos($dir, $UPLOAD_DIR_BASE) !== 0) {
        error_log("SECURITY ALERT: Attempted to delete outside UPLOAD_DIR_BASE: " . $dir);
        return false;
    }
    
    if (!file_exists($dir)) return true;
    if (!is_dir($dir)) return unlink($dir);
    
    foreach (scandir($dir) as $item) {
        if ($item == '.' || $item == '..') continue;
        if (!rmdir_recursive($dir . DIRECTORY_SEPARATOR . $item)) return false; 
    }
    return rmdir($dir);
}

// 1. Input Validation
if ($_SERVER['REQUEST_METHOD'] !== 'GET' || !isset($_GET['id']) || empty($_GET['id'])) {
    header("Location: " . $REDIRECT_FAILURE . "&msg=" . urlencode("Invalid request parameters."));
    exit();
}

$student_id = filter_input(INPUT_GET, 'id', FILTER_SANITIZE_NUMBER_INT);

// 2. Database Connection (Transactional)
$conn = get_db_connection_transactional($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);

if ($conn === null) {
    header("Location: " . $REDIRECT_FAILURE . "&msg=" . urlencode("Database connection failed."));
    exit();
}

try {
    // 3. Fetch Student Info (PhotoPath) Before Deletion for cleanup
    $sql_select = "SELECT PhotoPath FROM Students WHERE StudentID = ?";
    $stmt_select = $conn->prepare($sql_select);
    $stmt_select->bind_param("i", $student_id);
    $stmt_select->execute();
    $result = $stmt_select->get_result();
    $student_info = $result->fetch_assoc();
    $stmt_select->close();

    if (!$student_info) {
        throw new Exception("Student ID not found.");
    }
    
    $photo_path = $student_info['PhotoPath']; 

    // 4. Delete Dependent Records First (Foreign Key Constraints)
    // CRITICAL UPDATE: 'Parents' table instead of 'Guardian'
    $tables_to_delete = ['Enrollment', 'Parents', 'AcademicHistory']; 
    foreach ($tables_to_delete as $table) {
        $sql_del = "DELETE FROM {$table} WHERE StudentID = ?";
        $stmt_del = $conn->prepare($sql_del);
        if ($stmt_del === false) throw new Exception("Prepare delete {$table} failed: " . $conn->error);
        $stmt_del->bind_param("i", $student_id);
        if (!$stmt_del->execute()) throw new Exception("Execution delete {$table} failed: " . $stmt_del->error);
        $stmt_del->close();
    }

    // 5. Delete the Main Student Record
    $sql_del_student = "DELETE FROM Students WHERE StudentID = ?";
    $stmt_del_student = $conn->prepare($sql_del_student);
    if ($stmt_del_student === false) throw new Exception("Prepare delete Students failed: " . $conn->error);
    $stmt_del_student->bind_param("i", $student_id);
    if (!$stmt_del_student->execute()) throw new Exception("Execution delete Students failed: " . $stmt_del_student->error);
    $stmt_del_student->close();
    
    // 6. Commit the Transaction
    $conn->commit();

    // 7. Delete Physical Files (After successful DB deletion)
    $STUDENT_ID_DIR = $UPLOAD_DIR . $student_id . '/';
    
    if (is_dir($STUDENT_ID_DIR)) {
        rmdir_recursive($STUDENT_ID_DIR);
    } else {
        // Legacy Cleanup
        if (!empty($photo_path)) {
             $folder_rel = dirname($photo_path);
             if (strpos($folder_rel, $UPLOAD_FOLDER_REL) === 0) {
                 $folder_sub = substr($folder_rel, strlen($UPLOAD_FOLDER_REL)); 
                 $LEGACY_DIR = $UPLOAD_DIR . $folder_sub . '/'; 
                 if (is_dir($LEGACY_DIR)) rmdir_recursive($LEGACY_DIR);
             }
        }
    }

    header("Location: " . $REDIRECT_SUCCESS . "&id=" . $student_id);
    exit();

} catch (Exception $e) {
    if ($conn) {
        $conn->rollback();
    }
    error_log("Student deletion failed (ID: {$student_id}): " . $e->getMessage());
    header("Location: " . $REDIRECT_FAILURE . "&id=" . $student_id . "&msg=" . urlencode("An internal error occurred. " . $e->getMessage()));
    exit();
} finally {
    if (isset($conn)) {
        $conn->close();
    }
}
?>