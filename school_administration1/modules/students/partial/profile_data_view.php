<?php
// modules/students/partial/profile_data_view.php
$h = fn($v) => htmlspecialchars($v ?? '');
$d = fn($v) => htmlspecialchars($v ?? 'N/A');
$s = $student_data;

// Logic to display address from split fields
$displayAddress = '';
if (!empty($s['HouseNo'])) $displayAddress .= $s['HouseNo'] . ' ';
if (!empty($s['Street'])) $displayAddress .= $s['Street'] . ', ';
if (!empty($s['Village'])) $displayAddress .= $s['Village'] . ', ';
if (!empty($s['Town'])) $displayAddress .= $s['Town'] . ' ';
if (!empty($s['District'])) $displayAddress .= $s['District'] .', ' ;
if (!empty($s['State'])) $displayAddress .= $s['State'] .'. ' ;

if (empty(trim($displayAddress))) $displayAddress = 'N/A';
?>

<div class="profile-grid-system">
    
    <fieldset>
        <legend>1. Personal Information</legend>
        <div class="grid-row">
            <div class="grid-item"><strong>Name</strong> <p id="v-name"><?php echo $h($s['Name']); ?></p></div>
            <div class="grid-item"><strong>Surname</strong> <p id="v-surname"><?php echo $h($s['Surname']); ?></p></div>
            <div class="grid-item"><strong>Date of Birth</strong> <p id="v-dob"><?php echo $h($s['DateOfBirth']); ?></p></div>
            <div class="grid-item"><strong>Gender</strong> <p id="v-gender"><?php echo $h($s['Gender']); ?></p></div>
            <div class="grid-item"><strong>Admission year</strong> <p><?php echo $h($s['AdmissionYear']); ?></p></div>
            <div class="grid-item"><strong>Address</strong> <p id="v-address"><?php echo $h($displayAddress); ?></p></div>
        </div>
    </fieldset>

    <fieldset>
        <legend>2. Father's Details</legend>
        <div class="grid-row">
            <div class="grid-item"><strong>Name</strong> <p><?php echo $d($s['father_name']); ?></p></div>
            <div class="grid-item"><strong>Contact</strong> <p><?php echo $d($s['father_contact']); ?></p></div>
            <div class="grid-item"><strong>Email</strong> <p><?php echo $d($s['father_email']); ?></p></div>
            <div class="grid-item"><strong>Occupation</strong> <p><?php echo $d($s['father_occupation']); ?></p></div>
            <div class="grid-item"><strong>Education</strong> <p><?php echo $d($s['father_education']); ?></p></div>
        </div>
    </fieldset>

    <fieldset>
        <legend>3. Mother's Details</legend>
        <div class="grid-row">
            <div class="grid-item"><strong>Name</strong> <p><?php echo $d($s['mother_name']); ?></p></div>
            <div class="grid-item"><strong>Contact</strong> <p><?php echo $d($s['mother_contact']); ?></p></div>
            <div class="grid-item"><strong>Email</strong> <p><?php echo $d($s['mother_email']); ?></p></div>
            <div class="grid-item"><strong>Occupation</strong> <p><?php echo $d($s['mother_occupation']); ?></p></div>
            <div class="grid-item"><strong>Education</strong> <p><?php echo $d($s['mother_education']); ?></p></div>
        </div>
    </fieldset>

    <fieldset>
        <legend>4. Guardian Details</legend>
        <div class="grid-row">
            <div class="grid-item"><strong>Name</strong> <p><?php echo $d($s['guardian_name']); ?></p></div>
            <div class="grid-item"><strong>Contact</strong> <p><?php echo $d($s['guardian_contact']); ?></p></div>
            <div class="grid-item"><strong>Email</strong> <p><?php echo $d($s['guardian_email']); ?></p></div>
            <div class="grid-item"><strong>Relation</strong> <p><?php echo $d($s['guardian_relation']); ?></p></div>
            <div class="grid-item"><strong>Address</strong> <p><?php echo $d($s['guardian_address']); ?></p></div>
             <div class="grid-item full-width"><strong>Notes</strong> <p><?php echo nl2br($h($s['GuardianNotes'])); ?></p></div>
        </div>
    </fieldset>

    <fieldset>
        <legend>5. Enrollment Details</legend>
        <div class="grid-row">
            <div class="grid-item"><strong>Academic Year</strong> <p id="v-regyear"><?php echo $h($s['AcademicYear']); ?></p></div>
            <div class="grid-item"><strong>Level</strong> <p id="v-level"><?php echo $h($s['Level']); ?></p></div>
            <div class="grid-item"><strong>Class</strong> <p id="v-class"><?php echo $h($s['Class']); ?></p></div>
            <div class="grid-item"><strong>Stream</strong> <p id="v-stream"><?php echo $h($s['Stream']); ?></p></div>
            <div class="grid-item"><strong>Term</strong> <p id="v-term"><?php echo $h($s['Term']); ?></p></div>
            <div class="grid-item"><strong>Residence</strong> <p id="v-residence"><?php echo $h($s['Residence']); ?></p></div>
            <div class="grid-item"><strong>Entry Status</strong> <p id="v-entrystatus"><?php echo $h($s['EntryStatus']); ?></p></div>
        </div>
    </fieldset>

    <fieldset>
        <legend>6. Academic History</legend>
        <div class="grid-row">
            <div class="grid-item"><strong>Former School</strong> <p id="v-former-school"><?php echo $d($s['FormerSchool']); ?></p></div>
            <div class="grid-item"><strong>PLE Index No</strong> <p id="v-ple-index"><?php echo $d($s['PLEIndexNumber']); ?></p></div>
            <div class="grid-item"><strong>PLE Aggregate</strong> <p id="v-ple-agg"><?php echo $d($s['PLEAggregate']); ?></p></div>
            <div class="grid-item"><strong>UCE Index No</strong> <p id="v-uce-index"><?php echo $d($s['UCEIndexNumber']); ?></p></div>
            <div class="grid-item"><strong>UCE Results</strong> <p id="v-uce-result"><?php echo $d($s['UCEResult']); ?></p></div>
        </div>
    </fieldset>
</div>