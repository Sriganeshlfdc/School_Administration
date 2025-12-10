<?php
// school_administration1/api/students/upload_temp.php

require_once __DIR__ . '/../../config/config.php';
header('Content-Type: application/json');

// 1. Validate Student ID
$student_id = filter_input(INPUT_POST, 'StudentID', FILTER_SANITIZE_NUMBER_INT);
if (!$student_id) {
    echo json_encode(['success' => false, 'message' => 'Student ID is required for folder selection.']);
    exit;
}

// 2. Define Student Directory (Not generic temp)
$STUDENT_FOLDER_REL = "assets/uploads/students/$student_id/";
$TARGET_DIR = __DIR__ . "/../../$STUDENT_FOLDER_REL";

// Create directory if it doesn't exist
if (!is_dir($TARGET_DIR)) {
    if (!mkdir($TARGET_DIR, 0777, true)) {
        echo json_encode(['success' => false, 'message' => 'Failed to create student directory']);
        exit;
    }
}

$ALLOWED_EXTENSIONS = ['png', 'jpg', 'jpeg', 'gif'];
$MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_FILES['photo'])) {
    $file = $_FILES['photo'];

    if ($file['error'] !== UPLOAD_ERR_OK) {
        echo json_encode(['success' => false, 'message' => 'Upload error code: ' . $file['error']]);
        exit;
    }

    if ($file['size'] > $MAX_FILE_SIZE) {
        echo json_encode(['success' => false, 'message' => 'File too large (Max 5MB)']);
        exit;
    }

    $ext = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
    if (!in_array($ext, $ALLOWED_EXTENSIONS)) {
        echo json_encode(['success' => false, 'message' => 'Invalid file format']);
        exit;
    }

    // 3. Generate Temp Name inside Student Folder
    // We add 'temp_' prefix so we can distinguish it later if needed, or just use it as is.
    $tempName = 'temp_' . uniqid() . '.' . $ext;
    $targetPath = $TARGET_DIR . $tempName;

    if (move_uploaded_file($file['tmp_name'], $targetPath)) {
        echo json_encode([
            'success' => true,
            'tempFileName' => $tempName, // Filename only
            'previewUrl' => $STUDENT_FOLDER_REL . $tempName // Web accessible path
        ]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Failed to move uploaded file']);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'No file received']);
}
?>