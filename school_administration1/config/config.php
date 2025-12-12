<?php
// webpages/config.php

define('CONFIG_LOADED', true);

// --- Database Configuration ---
$DB_HOST = '127.0.0.1';
$DB_USER = 'root'; 
$DB_PASS = '$riG@nesh27'; 
$DB_NAME = 'school_administration';

// --- File Handling ---
$UPLOAD_FOLDER_REL = 'assets/uploads/students/'; 
$UPLOAD_DIR_BASE = __DIR__ . '/../assets/uploads/students/';
$MAX_FILE_SIZE = 5 * 1024 * 1024; // 5 MB
define('MAX_STUDENTS_PER_STREAM', 50); 
define('MAX_STUDENTS_PER_CLASS', 250); 

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

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

function fetch_full_student_data($conn, $Ad_no) {
    // UPDATED: Now selects split address fields and parent emails
    $sql = "
        SELECT 
            S.AdmissionNo, S.AdmissionYear, S.Name, S.Surname, S.DateOfBirth, S.Gender, S.PhotoPath,
            -- Split Address Columns
            S.HouseNo, S.Street, S.Village, S.Town, S.District, S.State, S.Country,
            
            -- Father Details (Added Email)
            P.father_name, P.father_age, P.father_contact, P.father_email, P.father_occupation, P.father_education,
            
            -- Mother Details (Added Email)
            P.mother_name, P.mother_age, P.mother_contact, P.mother_email, P.mother_occupation, P.mother_education,
            
            -- Guardian Details (Added Email)
            P.guardian_name, P.guardian_relation, P.guardian_age, P.guardian_contact, P.guardian_email, 
            P.guardian_occupation, P.guardian_education, P.guardian_address,
            P.MoreInformation AS GuardianNotes,
            
            -- Academic & Enrollment
            A.FormerSchool, A.PLEIndexNumber, A.PLEAggregate, A.UCEIndexNumber, A.UCEResult,A.LIN,
            E.Class, E.Level, E.Term, E.AcademicYear, E.Residence, E.EntryStatus, E.Stream
        FROM Students S
        JOIN Enrollment E ON S.AdmissionNo = E.AdmissionNo
        LEFT JOIN Parents P ON S.AdmissionNo = P.AdmissionNo        
        LEFT JOIN AcademicHistory A ON S.AdmissionNo = A.AdmissionNo 
        WHERE S.AdmissionNo = ?
    ";
    $stmt = $conn->prepare($sql);
    if ($stmt) {
        $stmt->bind_param("i", $Ad_no);
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