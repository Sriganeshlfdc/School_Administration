<?php
// webpages/config.php

define('CONFIG_LOADED', true);

// --- Database Configuration ---
$DB_HOST = '127.0.0.1';
$DB_USER = 'root'; 
$DB_PASS = ''; 
$DB_NAME = 'school_administration';

// --- File Handling ---
$UPLOAD_FOLDER_REL = 'static/uploads/';
$UPLOAD_DIR_BASE = __DIR__ . '/static/uploads/'; 

// --- Business Logic Constants ---
define('MAX_STUDENTS_PER_STREAM', 50); 
define('MAX_STUDENTS_PER_CLASS', 250); 

// --- Session Management ---
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// --- Helper Functions ---

/**
 * Formats a year (e.g., 2025) into an Academic Year string (e.g., "2025-26").
 */
function format_academic_year($year) {
    if (empty($year) || !is_numeric($year)) return $year;
    $next_year_short = substr((int)$year + 1, -2);
    return $year . '-' . $next_year_short;
}

function get_db_connection($host, $user, $pass, $db_name) {
    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
    try {
        return new mysqli($host, $user, $pass, $db_name);
    } catch (mysqli_sql_exception $e) {
        error_log("Database connection failed: " . $e->getMessage());
        return null; 
    }
}

function get_db_connection_transactional($host, $user, $pass, $db_name) {
    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
    try {
        $conn = new mysqli($host, $user, $pass, $db_name);
        $conn->autocommit(false); 
        return $conn;
    } catch (mysqli_sql_exception $e) {
        error_log("Database connection failed: " . $e->getMessage());
        return null;
    }
}

function fetch_full_student_data($conn, $student_id) {
    // Updated to select AcademicYear instead of RegistrationYear
    $sql = "
        SELECT 
            S.StudentID, S.AdmissionYear, S.Name, S.Surname, S.DateOfBirth, S.Gender, S.CurrentAddress AS Address, S.PhotoPath,
            P.father_name, P.father_age, P.father_contact, P.father_occupation, P.father_education,
            P.mother_name, P.mother_age, P.mother_contact, P.mother_occupation, P.mother_education,
            P.guardian_name, P.guardian_relation, P.guardian_age, P.guardian_contact, P.guardian_occupation, P.guardian_education, P.guardian_address,
            P.MoreInformation AS GuardianNotes,
            A.FormerSchool, A.PLEIndexNumber, A.PLEAggregate, A.UCEIndexNumber, A.UCEResult,
            E.Class, E.Level, E.Term, E.AcademicYear, E.Residence, E.EntryStatus, E.Stream
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
        $stmt->close();
        return $data;
    }
    return null;
}

function getStreamOptions() {
    return ['A', 'B', 'C', 'D', 'E'];
}
?>