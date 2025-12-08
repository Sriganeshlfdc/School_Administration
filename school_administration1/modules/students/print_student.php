<?php
// modules/students/print_student.php
require_once __DIR__ . '/../../config/config.php';

// 1. Validate ID
$student_id = filter_input(INPUT_GET, 'id', FILTER_SANITIZE_NUMBER_INT);
if (!$student_id) die("Error: Student ID required.");

// 2. Fetch Data
$conn = get_db_connection($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
$data = null;
if ($conn) {
    $data = fetch_full_student_data($conn, $student_id);
    $conn->close();
}
if (!$data) die("Error: Student not found.");

// 3. Data Formatting Helpers
$d = fn($v) => !empty($v) ? htmlspecialchars($v) : '-';
$fmtID = fn($id) => str_pad($id, 3, '0', STR_PAD_LEFT);
// Construct Address from split fields
$addr_parts = [];
if (!empty($data['HouseNo'])) $addr_parts[] = $data['HouseNo'];
if (!empty($data['Street'])) $addr_parts[] = $data['Street'];
if (!empty($data['Village'])) $addr_parts[] = $data['Village'];
if (!empty($data['Town'])) $addr_parts[] = $data['Town'];
if (!empty($data['District'])) $addr_parts[] = $data['District'];

$display_address = !empty($addr_parts) ? implode(', ', $addr_parts) : '-';
// 4. Image Path Resolution
$photo_db = $data['PhotoPath']; 
$photo_src = '../../assets/images/default_profile.png';
if (!empty($photo_db)) {
    // Handle paths starting with 'assets/' or relative 'uploads/'
    if (strpos($photo_db, 'assets/') === 0) {
        $photo_src = '../../' . $photo_db; 
    } else {
        $photo_src = '../../assets/' . $photo_db;
    }
}

// 5. Business Logic: Guardian
$has_guardian = !empty($data['guardian_name']);

// 6. Dates
$dob = $data['DateOfBirth'] ? date('d-M-Y', strtotime($data['DateOfBirth'])) : '-';
date_default_timezone_set('Africa/Kampala');
$print_date = date('d-M-Y');       
$print_time = date('h:i:s A');
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Profile: <?php echo htmlspecialchars($data['Name'] . ' ' . $data['Surname']); ?></title>
    
    <link rel="stylesheet" href="../../assets/styles/base.css">
    <link rel="stylesheet" href="../../assets/styles/student.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body class="print-body">

    <div class="no-print-bar">
        <button onclick="window.print()" class="btn-primary" style="width: auto; padding: 8px 20px;">
            <i class="fa fa-print"></i> Print Profile
        </button>
    </div>

    <div class="print-page">
        
        <div class="letterhead">
            <div class="school-details">
                <h1 style="margin:0; font-size: 24pt; font-weight: 800; text-transform:uppercase;">Montfort School</h1>
                <p style="margin:5px 0; font-size: 10pt; font-weight:600;">Excellence in Education • Holistic Development</p>
                <p style="margin:0; font-size: 9pt;">P.O. Box 123, Kampala, Uganda | Tel: +256 700 000 000</p>
            </div>
        </div>
        <hr class="divider">
        <h2 class="document-title">Student Profile Record</h2>
        
        <div class="header-info-block">
            <div class="info-text">
                <table class="info-grid-table">
                    <tr>
                        <td class="label">Name:</td>
                        <td class="val-lg"><?php echo htmlspecialchars($data['Name'] . ' ' . $data['Surname']); ?></td>
                    </tr>
                    <tr>
                        <td class="label">Student ID:</td>
                        <td class="val"><strong><?php echo $fmtID($data['StudentID']); ?></strong></td>
                    </tr>
                    <tr>
                        <td class="label">Class:</td>
                        <td class="val"><?php echo $d($data['Class']) . ' ' . $d($data['Stream']); ?></td>
                    </tr>
                    <tr>
                        <td class="label">Acad. Year:</td>
                        <td class="val"><?php echo $d($data['AcademicYear']); ?></td>
                    </tr>
                </table>
            </div>
            <div class="photo-box">
                <img src="<?php echo $photo_src; ?>" alt="Student Photo">
            </div>
        </div>

        <div class="print-section">
            <h3 class="section-title">1. Personal Information</h3>
            <table class="print-table">
                <tr>
                    <td class="label">Gender</td><td class="value"><?php echo $d($data['Gender']); ?></td>
                    <td class="label">DOB</td><td class="value"><?php echo $dob; ?></td>
                </tr>
                <tr>
                    <td class="label">Admission Year</td><td class="value"><?php echo $d($data['AdmissionYear']); ?></td>
                    <td class="label">Residence</td><td class="value"><?php echo $d($data['Residence']); ?></td>
                </tr>
                <tr>
                    <td class="label">Address</td><td class="value" colspan="3"><?php echo htmlspecialchars($display_address); ?></td>
                </tr>
            </table>
        </div>

        <div class="print-section">
            <h3 class="section-title">2. Parents Information</h3>
            <table class="print-table" style="margin-bottom:-1px;">
                <tr>
                    <td class="label" style="width:15%; background:#eef;">Father</td>
                    <td class="value" style="width:35%;"><strong><?php echo $d($data['father_name']); ?></strong></td>
                    <td class="label" style="width:15%;">Contact</td>
                    <td class="value" style="width:35%;"><?php echo $d($data['father_contact']); ?></td>
                </tr>
                <tr>
                    <td class="label">Occupation</td><td class="value"><?php echo $d($data['father_occupation']); ?></td>
                    <td class="label">Education</td><td class="value"><?php echo $d($data['father_education']); ?></td>
                </tr>
            </table>
            <table class="print-table" style="margin-top:10px;">
                <tr>
                    <td class="label" style="width:15%; background:#eef;">Mother</td>
                    <td class="value" style="width:35%;"><strong><?php echo $d($data['mother_name']); ?></strong></td>
                    <td class="label" style="width:15%;">Contact</td>
                    <td class="value" style="width:35%;"><?php echo $d($data['mother_contact']); ?></td>
                </tr>
                <tr>
                    <td class="label">Occupation</td><td class="value"><?php echo $d($data['mother_occupation']); ?></td>
                    <td class="label">Education</td><td class="value"><?php echo $d($data['mother_education']); ?></td>
                </tr>
            </table>
        </div>

        <?php if ($has_guardian): ?>
        <div class="print-section">
            <h3 class="section-title">3. Guardian Information</h3>
            <table class="print-table">
                <tr>
                    <td class="label">Name</td>
                    <td class="value" colspan="3"><strong><?php echo $d($data['guardian_name']); ?></strong></td>
                </tr>
                <tr>
                    <td class="label">Relation</td><td class="value"><?php echo $d($data['guardian_relation']); ?></td>
                    <td class="label">Contact</td><td class="value"><?php echo $d($data['guardian_contact']); ?></td>
                </tr>
                <tr>
                    <td class="label">Occupation</td><td class="value"><?php echo $d($data['guardian_occupation']); ?></td>
                    <td class="label">Address</td><td class="value"><?php echo $d($data['guardian_address']); ?></td>
                </tr>
            </table>
        </div>
        <?php endif; ?>

        <div class="print-section">
            <h3 class="section-title">4. Academic History</h3>
            <table class="print-table">
                <tr>
                    <td class="label">Former School</td>
                    <td class="value" colspan="3"><?php echo $d($data['FormerSchool']); ?></td>
                </tr>
                <tr>
                    <td class="label">PLE Index</td><td class="value"><?php echo $d($data['PLEIndexNumber']); ?></td>
                    <td class="label">PLE Agg</td><td class="value"><?php echo $d($data['PLEAggregate']); ?></td>
                </tr>
                <tr>
                    <td class="label">UCE Index</td><td class="value"><?php echo $d($data['UCEIndexNumber']); ?></td>
                    <td class="label">UCE Result</td><td class="value"><?php echo $d($data['UCEResult']); ?></td>
                </tr>
            </table>
        </div>

        <div class="print-section">
            <h3 class="section-title">5. Enrollment Details</h3>
            <table class="print-table">
                <tr>
                    <td class="label">Academic Year</td><td class="value"><?php echo $d($data['AcademicYear']); ?></td>
                    <td class="label">Term</td><td class="value"><?php echo $d($data['Term']); ?></td>
                </tr>
                <tr>
                    <td class="label">Level</td><td class="value"><?php echo $d($data['Level']); ?></td>
                    <td class="label">Class/Stream</td><td class="value"><?php echo $d($data['Class']) . ' ' . $d($data['Stream']); ?></td>
                </tr>
                <tr>
                    <td class="label">Entry Status</td><td class="value"><?php echo $d($data['EntryStatus']); ?></td>
                    <td class="label">Status</td><td class="value">Active</td>
                </tr>
            </table>
        </div>

        <div class="print-footer">
            <div class="footer-line"></div>
            <div class="footer-content">
                <span>Generated by Montfort School Management System</span>
                <span>Date: <?php echo $print_date; ?>&nbsp;|&nbsp;Time: <?php echo $print_time; ?></span>
            </div>
        </div>

    </div>

    <script src="../../assets/scripts/student.js"></script>
</body>
</html>