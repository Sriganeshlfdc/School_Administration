<?php
// webpages/print_student.php
require_once 'config.php';

$student_id = filter_input(INPUT_GET, 'id', FILTER_SANITIZE_NUMBER_INT);
if (!$student_id) die("Student ID required.");

$conn = get_db_connection($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
$data = null;
if ($conn) {
    // Uses the centralized function which aliases columns (e.g., CurrentAddress -> Address)
    $data = fetch_full_student_data($conn, $student_id);
    $conn->close();
}
if (!$data) die("Student not found.");

$photo_src = !empty($data['PhotoPath']) ? $data['PhotoPath'] : 'static/images/default_profile.png';
$d = fn($v) => !empty($v) ? htmlspecialchars($v) : 'N/A';
$fmtID = fn($id) => str_pad($id, 2, '0', STR_PAD_LEFT);
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Profile-<?php echo htmlspecialchars($fmtID($data['StudentID']).'-'.$data['Surname'].' '.$data['Name']); ?></title>
    
    <link rel="stylesheet" href="static/styles/base.css">
    <link rel="stylesheet" href="static/styles/student.css">
</head>
<body class="print-body">

    <div class="no-print-bar">
        <button onclick="window.print()" class="btn-primary">🖨 Print Official Profile</button>
    </div>

    <div class="print-page">
        
        <div class="letterhead">
            <div class="school-details">
                <h1>MONTFORT SCHOOL</h1>
                <p>Excellence in Education &bull; Holistic Development</p>
                <p class="small">Phone: +123 456 7890 | Email: info@montfortschool.com</p>
            </div>
        </div>

        <hr class="divider">

        <h2 class="document-title">STUDENT PROFILE RECORD</h2>
        
        <div class="header">
            <div class="header-info">
                <h1><?php echo htmlspecialchars($data['Name'] . ' ' . $data['Surname']); ?></h1>
                <p><strong>Student ID:</strong> <?php echo $fmtID($data['StudentID']); ?></p>
                <p><strong>Academic Year:</strong> <?php echo $data['AcademicYear']; ?></p>
                <p><strong>Current Class:</strong> <?php echo $data['Level'] . ' - ' . $data['Class']; ?></p>
            </div>
            <div class="photo-cell">
                <img src="<?php echo $photo_src; ?>" alt="Student Photo">
            </div>
        </div>

        <div class="print-section">
            <h3 class="section-title">1. Personal Information</h3>
            <table class="print-table">
                <tr>
                    <td class="label">Ad.Year</td>
                    <td class="value"><?php echo $d($data['AdmissionYear']); ?></td>
                    <td class="label">DOB</td>
                    <td class="value"><?php echo $d($data['DateOfBirth']); ?></td>
                    <td class="label">Gender</td>
                    <td class="value"><?php echo $d($data['Gender']); ?></td>
                </tr>
                <tr>
                    <td class="label">Address</td>
                    <td class="value" colspan="6"><?php echo $d($data['Address']); ?></td>
                </tr>
            </table>
        </div>

        <div class="print-section">
            <h3 class="section-title">2. Parents & Guardian Info</h3>
            
            <table class="print-table" style="margin-bottom: 5px;">
                <tr>
                    <td class="label" style="background:#e0e0e0;"style="width: 20%;">Father</td>
                    <td class="value" colspan="3"><strong><?php echo $d($data['father_name']); ?></strong></td>
                </tr>
                <tr>
                    <td class="label">Contact</td><td class="value"><?php echo $d($data['father_contact']); ?></td>
                    <td class="label">Occup.</td><td class="value"><?php echo $d($data['father_occupation']); ?></td>
                </tr>
            </table>

            <table class="print-table" style="margin-bottom: 5px;">
                <tr>
                    <td class="label" style="background:#e0e0e0;">Mother</td>
                    <td class="value"colspan="3"><strong><?php echo $d($data['mother_name']); ?></strong></td>
                </tr>
                <tr>
                    <td class="label">Contact</td><td class="value"><?php echo $d($data['mother_contact']); ?></td>
                    <td class="label">Occup.</td><td class="value"><?php echo $d($data['mother_occupation']); ?></td>
                </tr>
            </table>

            <table class="print-table">
                <tr>
                    <td class="label" style="background:#e0e0e0;">Guardian</td>
                    <td class="value" colspan="3" ><strong><?php echo $d($data['guardian_name']); ?></strong></td>
                </tr>
                <tr>
                    <td class="label">Relation</td><td class="value"><?php echo $d($data['guardian_relation']); ?></td>
                    <td class="label">Contact</td><td class="value"><?php echo $d($data['guardian_contact']); ?></td>
                </tr>
                <tr><td class="label">Address</td><td class="value" colspan="5"><?php echo $d($data['guardian_address']); ?></td></tr>
            </table>
        </div>

        <div class="print-section">
            <h3 class="section-title">3. Enrollment Details</h3>
            <table class="print-table">
                <tr>
                    <td class="label">Academic Year</td>
                    <td class="value"><?php echo $d($data['AcademicYear']); ?></td>
                    <td class="label">Current Term</td>
                    <td class="value"><?php echo $d($data['Term']); ?></td>
                </tr>
                <tr>
                    <td class="label">Level</td>
                    <td class="value"><?php echo $d($data['Level']); ?></td>
                    <td class="label">Class</td>
                    <td class="value"><?php echo $d($data['Class']); ?></td>
                </tr>
                <tr>
                    <td class="label">Stream</td>
                    <td class="value"><?php echo $d($data['Stream']); ?></td>
                    <td class="label">Residence</td>
                    <td class="value"><?php echo $d($data['Residence']); ?></td>
                </tr>
                <tr>
                    <td class="label">Entry Status</td>
                    <td class="value" colspan="3"><?php echo $d($data['EntryStatus']); ?></td>
                </tr>
            </table>
        </div>

        <div class="print-section">
            <h3 class="section-title">4. Academic History</h3>
            <table class="print-table">
                <tr>
                    <td class="label" style="width: 20%;">Former School</td>
                    <td class="value" colspan="3"><?php echo $d($data['FormerSchool']); ?></td>
                </tr>
                <tr>
                    <td class="label">PLE Index No</td>
                    <td class="value"><?php echo $d($data['PLEIndexNumber']); ?></td>
                    <td class="label">PLE Aggregate</td>
                    <td class="value"><?php echo $d($data['PLEAggregate']); ?></td>
                </tr>
                <tr>
                    <td class="label">UCE Index No</td>
                    <td class="value"><?php echo $d($data['UCEIndexNumber']); ?></td>
                    <td class="label">UCE Result</td>
                    <td class="value"><?php echo $d($data['UCEResult']); ?></td>
                </tr>
            </table>
        </div>

        <div class="footer">
            <p>Generated by Montfort School Management System</p>
            <?php
                date_default_timezone_set('Asia/Kolkata'); // set your timezone
                echo date('d-M-Y h:i:s A');
            ?>

        </div>

    </div>

    <script>
        window.onload = function() { setTimeout(function() { window.print(); }, 500); }
    </script>
</body>
</html>