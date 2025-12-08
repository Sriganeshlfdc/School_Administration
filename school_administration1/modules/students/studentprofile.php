<?php
require_once __DIR__ . '/../../config/config.php';

$student_id = filter_input(INPUT_GET, 'id', FILTER_SANITIZE_NUMBER_INT);

if (!$student_id) {
    die("<h1 style='text-align:center; margin-top:50px;'>Error: Student ID is required.</h1>");
}

global $DB_HOST, $DB_USER, $DB_PASS, $DB_NAME;
$conn = get_db_connection($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
$student_data = null;

if ($conn) {
    $student_data = fetch_full_student_data($conn, $student_id);
    $conn->close();
}

if (!$student_data) die("<h1 style='text-align:center; margin-top:50px;'>Error: Student not found.</h1>");

$format = fn($value) => htmlspecialchars($value ?? 'N/A');
$val = fn($value) => htmlspecialchars($value ?? ''); 
$photo_src = !empty($student_data['PhotoPath']) ? $student_data['PhotoPath'] : 'static/images/default_profile.png';
$full_name = $format($student_data['Name']) . ' ' . $format($student_data['Surname']);
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo $full_name; ?> - Student Profile</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../../assets/styles/base.css">
    <link rel="stylesheet" href="../../assets/styles/student.css">
</head>
<body class="layout-wrapper light-theme">
    
    <?php include 'includes/navbar.php'; ?>
    
    <div class="layout">
        <?php include 'includes/sidebar.php'; ?>

        <div class="content" id="content">
            <div class="viewer-container" style="max-width: 1400px; margin: 0 auto;">
                
                <div class="top-action-bar">
                    <a href="studentmanagement.php#list" class="btn-primary" style="background-color: #6c757d;"><i class="fa fa-arrow-left"></i> Back</a>
                    <button id="edit-btn" onclick="togglePageEditMode('edit')" class="btn-primary" style="background-color: var(--primary-color);"><i class="fa fa-edit"></i> Edit Details</button>
                    <div id="save-cancel-group" style="display:none; gap: 10px;">
                        <button onclick="submitEditForm()" class="btn-primary" style="background-color: var(--success-color);"><i class="fa fa-save"></i> Save Changes</button>
                        <button onclick="togglePageEditMode('view')" class="btn-primary" style="background-color: #6c757d;"><i class="fa fa-times-circle"></i> Cancel</button>
                    </div>
                    <a href="print_student.php?id=<?php echo $val($student_id); ?>" target="_blank" class="btn-primary" style="background-color: #17a2b8; text-decoration: none;">
                        <i class="fa fa-print"></i> Print
                    </a>
                    <div style="flex-grow: 1;"></div>
                    <button class="btn-primary" onclick="window.showDeleteConfirmModal('<?php echo $val($student_id); ?>', '<?php echo $full_name; ?>')" style="background-color: var(--danger-color);"><i class="fa fa-trash"></i> Delete</button>
                </div>

                <div class="unified-frame single-column-layout">
                    <div class="profile-header-inline">
                        <div class="header-info">
                            <h3 id="display-name-header"><?php echo $full_name; ?></h3>
                            <p class="id-badge">ID: <strong><?php echo $val($student_id); ?></strong></p>
                            <p class="status-badge">
                                <span class="badge"><?php echo $val($student_data['Level']); ?></span> 
                                <i class="fa fa-chevron-right" style="font-size: 0.8em; opacity: 0.5; margin: 0 5px;"></i>
                                <span class="badge"><?php echo $val($student_data['Class']); ?></span>
                            </p>
                        </div>
                        <div class="header-photo">
                            <div class="profile-image-container small-inline">
                                <img id="display-photo" src="<?php echo $photo_src; ?>" alt="Student Photo">
                                <div class="photo-edit-overlay"><i class="fa fa-camera"></i> Change</div>
                            </div>
                        </div>
                    </div>

                    <div class="profile-content-area">
                        <div id="view-mode-content">
    <?php include __DIR__ . '/../../modules/students/partial/profile_data_view.php'; ?>
</div>
<?php include __DIR__ . '/../../modules/students/partial/profile_edit_form.php'; ?>
                    </div>
                </div>
            </div>
        </div>

        <div id="custom-alert-modal" class="modal-backdrop">
            <div class="modal-content">
                <i class="fa modal-icon" id="custom-alert-icon"></i>
                <h4 id="custom-alert-title">Alert Title</h4>
                <p id="custom-alert-message">Alert message content.</p>
                <button id="custom-alert-close-btn" class="modal-close-btn">Close</button>
            </div>
        </div>

        <div id="deleteConfirmationModal" class="modal-backdrop">
            <div class="modal-content delete-confirmation-modal">
                <i class="fa fa-exclamation-triangle modal-icon warning"></i>
                <h4>Confirm Deletion</h4>
                <p>Are you sure you want to permanently delete this student record?</p>
                <div class="modal-actions">
                    <button id="delete-cancel-btn" class="modal-close-btn" style="background:#ccc;">Cancel</button>
                    <button id="delete-confirm-btn" class="modal-close-btn delete-btn" style="background:var(--danger-color);">Delete</button>
                </div>
            </div>
        </div>
    </div>
    <script src="static/scripts/base.js"></script>
    <script src="static/scripts/student.js"></script>
</body>
</html><?php
require_once __DIR__ . '/../../config/config.php';

$student_id = filter_input(INPUT_GET, 'id', FILTER_SANITIZE_NUMBER_INT);

if (!$student_id) {
    die("<h1 style='text-align:center; margin-top:50px;'>Error: Student ID is required.</h1>");
}

global $DB_HOST, $DB_USER, $DB_PASS, $DB_NAME;
$conn = get_db_connection($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
$student_data = null;

if ($conn) {
    $student_data = fetch_full_student_data($conn, $student_id);
    $conn->close();
}

if (!$student_data) die("<h1 style='text-align:center; margin-top:50px;'>Error: Student not found.</h1>");

$format = fn($value) => htmlspecialchars($value ?? 'N/A');
$val = fn($value) => htmlspecialchars($value ?? ''); 
$photo_src = !empty($student_data['PhotoPath']) ? $student_data['PhotoPath'] : 'static/images/default_profile.png';
$full_name = $format($student_data['Name']) . ' ' . $format($student_data['Surname']);
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo $full_name; ?> - Student Profile</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="static/styles/base.css">
    <link rel="stylesheet" href="static/styles/student.css">
</head>
<body class="layout-wrapper light-theme">
    
    <?php include 'includes/navbar.php'; ?>
    
    <div class="layout">
        <?php include 'includes/sidebar.php'; ?>

        <div class="content" id="content">
            <div class="viewer-container" style="max-width: 1400px; margin: 0 auto;">
                
                <div class="top-action-bar">
                    <a href="studentmanagement.php#list" class="btn-primary btn-gray js-back-to-list"><i class="fa fa-arrow-left"></i> Back</a>
                    <button id="edit-btn" class="btn-primary"><i class="fa fa-edit"></i> Edit Details</button>
                    <div id="save-cancel-group" style="display:none; gap: 10px;">
                        <button class="btn-primary btn-success js-save-profile"><i class="fa fa-save"></i> Save Changes</button>
                        <button class="btn-primary btn-gray js-cancel-edit"><i class="fa fa-times-circle"></i> Cancel</button>
                    </div>
                    <a href="print_student.php?id=<?php echo $val($student_id); ?>" target="_blank" class="btn-primary btn-info js-print-student" data-id="<?php echo $val($student_id); ?>">
                        <i class="fa fa-print"></i> Print
                    </a>
                    <div style="flex-grow: 1;"></div>
                    <button class="btn-primary btn-danger js-delete-student" data-id="<?php echo $val($student_id); ?>" data-name="<?php echo $full_name; ?>"><i class="fa fa-trash"></i> Delete</button>
                </div>

                <div class="unified-frame single-column-layout">
                    <div class="profile-header-inline">
                        <div class="header-info">
                            <h3 id="display-name-header"><?php echo $full_name; ?></h3>
                            <p class="id-badge">ID: <strong><?php echo $val($student_id); ?></strong></p>
                            <p class="status-badge">
                                <span class="badge"><?php echo $val($student_data['Level']); ?></span> 
                                <i class="fa fa-chevron-right separator-icon"></i>
                                <span class="badge"><?php echo $val($student_data['Class']); ?></span>
                            </p>
                        </div>
                        <div class="header-photo">
                            <div class="profile-image-container small-inline">
                                <img id="display-photo" src="<?php echo $photo_src; ?>" alt="Student Photo">
                                <div class="photo-edit-overlay"><i class="fa fa-camera"></i> Change</div>
                            </div>
                        </div>
                    </div>

                    <div class="profile-content-area">
                        <div id="view-mode-content">
                            <?php include __DIR__ . '/../../modules/students/partial/profile_data_view.php'; ?>
                        </div>
                        <?php include __DIR__ . '/../../modules/students/partial/profile_edit_form.php'; ?>
                    </div>
                </div>
            </div>
        </div>

        <div id="custom-alert-modal" class="modal-backdrop">
            <div class="modal-content">
                <i class="fa modal-icon" id="custom-alert-icon"></i>
                <h4 id="custom-alert-title">Alert Title</h4>
                <p id="custom-alert-message">Alert message content.</p>
                <button id="custom-alert-close-btn" class="modal-close-btn js-close-modal">Close</button>
            </div>
        </div>
    </div>
    <script src="../../assets/scripts/base.js"></script>
    <script src="../../assets/scripts/student.js"></script>
</body>
</html>