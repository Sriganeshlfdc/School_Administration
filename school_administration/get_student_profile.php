<?php
require_once 'config.php';

$student_id = filter_input(INPUT_GET, 'id', FILTER_SANITIZE_NUMBER_INT);

if (!$student_id) {
    echo "<div class='error-message' style='color:red; padding:20px; text-align:center;'>Error: Student ID is required.</div>";
    exit;
}

$conn = get_db_connection($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
$student_data = null;

if ($conn) {
    $student_data = fetch_full_student_data($conn, $student_id);
    $conn->close();
}

if (!$student_data) {
    echo "<div class='error-message' style='color:red; padding:20px; text-align:center;'>Error: Student not found.</div>";
    exit;
}

$format = fn($value) => htmlspecialchars($value ?? 'N/A');
$val = fn($value) => htmlspecialchars($value ?? ''); 
$photo_src = !empty($student_data['PhotoPath']) ? $student_data['PhotoPath'] : 'static/images/default_profile.png';
$full_name = $format($student_data['Name']) . ' ' . $format($student_data['Surname']);
?>

<div class="viewer-container">
    <div class="top-action-bar">
        <button onclick="window.location.hash = 'list'" class="btn-primary" style="background-color: #6c757d;"><i class="fa fa-arrow-left"></i> Back to List</button>
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
                <div class="profile-image-container small-inline" onclick="triggerPhotoUpload()">
                    <img id="display-photo" src="<?php echo $photo_src; ?>" alt="Student Photo">
                    <div class="photo-edit-overlay"><i class="fa fa-camera"></i> Change</div>
                </div>
            </div>
        </div>

        <div class="profile-content-area">
            <div id="view-mode-content">
                <?php include 'includes/profile_data_view.php'; ?>
            </div>
            <?php include 'includes/profile_edit_form.php'; ?>
        </div>
    </div>
</div>