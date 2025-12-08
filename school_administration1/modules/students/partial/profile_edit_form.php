<?php
// modules/students/partial/profile_edit_form.php
if (!isset($val)) { $val = fn($v) => htmlspecialchars($v ?? ''); }
?>
<form id="edit-mode-form" class="profile-grid-system" action="edit_student.php" method="POST" enctype="multipart/form-data" style="display: none;">
    <input type="hidden" name="StudentID" value="<?php echo $val($student_data['StudentID']); ?>">
    
    <fieldset>
        <legend>1. Personal Information</legend>
        <div class="grid-row">
            <div class="grid-item"><label>Name</label> <input type="text" name="Name" id="i-name" value="<?php echo $val($student_data['Name']); ?>" required></div>
            <div class="grid-item"><label>Surname</label> <input type="text" name="Surname" id="i-surname" value="<?php echo $val($student_data['Surname']); ?>" required></div>
            <div class="grid-item"><label>Date of Birth</label> <input type="date" name="DateOfBirth" id="i-dob" value="<?php echo $val($student_data['DateOfBirth']); ?>"></div>
            <div class="grid-item"><label>Gender</label> 
                <select name="Gender" id="i-gender">
                    <option value="Male" <?php echo ($student_data['Gender'] == 'Male') ? 'selected' : ''; ?>>Male</option>
                    <option value="Female" <?php echo ($student_data['Gender'] == 'Female') ? 'selected' : ''; ?>>Female</option>
                </select>
            </div>
            
            <div class="grid-item"><label>House No/Zone</label> <input type="text" name="HouseNo" value="<?php echo $val($student_data['HouseNo']); ?>"></div>
            <div class="grid-item"><label>Street</label> <input type="text" name="Street" value="<?php echo $val($student_data['Street']); ?>"></div>
            <div class="grid-item"><label>Village</label> <input type="text" name="Village" value="<?php echo $val($student_data['Village']); ?>"></div>
            <div class="grid-item"><label>Town</label> <input type="text" name="Town" value="<?php echo $val($student_data['Town']); ?>"></div>
            <div class="grid-item"><label>District</label> <input type="text" name="District" value="<?php echo $val($student_data['District']); ?>"></div>
            
            <input type="hidden" name="AdmissionYear" value="<?php echo $val($student_data['AdmissionYear']); ?>">
            <input type="file" id="edit-photo" name="photo" accept="image/*" style="display: none;">
        </div>
    </fieldset>

    <fieldset>
        <legend>2. Father's Details</legend>
        <div class="grid-row">
            <div class="grid-item"><label>Name</label> <input type="text" name="father_name" value="<?php echo $val($student_data['father_name']); ?>"></div>
            <div class="grid-item"><label>Contact</label> <input type="text" name="father_contact" value="<?php echo $val($student_data['father_contact']); ?>"></div>
            <div class="grid-item"><label>Email</label> <input type="email" name="father_email" value="<?php echo $val($student_data['father_email']); ?>"></div>
            <div class="grid-item"><label>Occupation</label> <input type="text" name="father_occupation" value="<?php echo $val($student_data['father_occupation']); ?>"></div>
            <div class="grid-item"><label>Education</label> <input type="text" name="father_education" value="<?php echo $val($student_data['father_education']); ?>"></div>
        </div>
    </fieldset>

    <fieldset>
        <legend>3. Mother's Details</legend>
        <div class="grid-row">
             <div class="grid-item"><label>Name</label> <input type="text" name="mother_name" value="<?php echo $val($student_data['mother_name']); ?>"></div>
            <div class="grid-item"><label>Contact</label> <input type="text" name="mother_contact" value="<?php echo $val($student_data['mother_contact']); ?>"></div>
            <div class="grid-item"><label>Email</label> <input type="email" name="mother_email" value="<?php echo $val($student_data['mother_email']); ?>"></div>
            <div class="grid-item"><label>Occupation</label> <input type="text" name="mother_occupation" value="<?php echo $val($student_data['mother_occupation']); ?>"></div>
            <div class="grid-item"><label>Education</label> <input type="text" name="mother_education" value="<?php echo $val($student_data['mother_education']); ?>"></div>
        </div>
    </fieldset>

    <fieldset>
        <legend>4. Guardian Details</legend>
        <div class="grid-row">
            <div class="grid-item"><label>Name</label> <input type="text" name="guardian_name" value="<?php echo $val($student_data['guardian_name']); ?>"></div>
            <div class="grid-item"><label>Contact</label> <input type="text" name="guardian_contact" value="<?php echo $val($student_data['guardian_contact']); ?>"></div>
            <div class="grid-item"><label>Email</label> <input type="email" name="guardian_email" value="<?php echo $val($student_data['guardian_email']); ?>"></div>
            <div class="grid-item"><label>Relation</label> 
                <select name="guardian_relation">
                    <option value="">Select</option>
                    <?php $rels=['Brother','Sister','Uncle','Aunt','Grandparent','Other']; foreach($rels as $r) {
                        $sel = ($student_data['guardian_relation'] == $r) ? 'selected' : '';
                        echo "<option value='$r' $sel>$r</option>";
                    } ?>
                </select>
            </div>
            <div class="grid-item"><label>Address</label> <input type="text" name="guardian_address" value="<?php echo $val($student_data['guardian_address']); ?>"></div>
            <div class="grid-item full-width"><label>Notes</label> <textarea name="GuardianNotes"><?php echo $val($student_data['GuardianNotes']); ?></textarea></div>
        </div>
    </fieldset>

    <fieldset>
        <legend>5. Enrollment Details</legend>
        <div class="grid-row">
            <div class="grid-item"><label>Academic Year</label>
                <select name="AcademicYear" id="i-regyear">
                    <?php 
                    $curr = date('Y');
                    $curr_ay = format_academic_year($curr);
                    $sel_year = $student_data['AcademicYear'] ? $student_data['AcademicYear'] : $curr_ay;
                    for($y=$curr+1; $y>=$curr-5; $y--) {
                        $ay = format_academic_year($y);
                        $sel = ($ay == $sel_year) ? 'selected' : '';
                        echo "<option value='$ay' $sel>$ay</option>";
                    }
                    ?>
                </select>
            </div>
            <div class="grid-item"><label>Level</label>
                <select name="Level" id="i-level">
                    <option value="pre-primary" <?php echo ($student_data['Level'] == 'pre-primary') ? 'selected' : ''; ?>>Pre-Primary</option>
                    <option value="primary" <?php echo ($student_data['Level'] == 'primary') ? 'selected' : ''; ?>>Primary</option>
                    <option value="secondary" <?php echo ($student_data['Level'] == 'secondary') ? 'selected' : ''; ?>>Secondary</option>
                </select>
            </div>
            <div class="grid-item"><label>Class</label> 
                <select name="Class" id="i-class">
                    <option value="<?php echo $val($student_data['Class']); ?>" selected><?php echo $val($student_data['Class']); ?></option>
                </select>
            </div>
            <div class="grid-item"><label>Stream</label> 
                <select name="Stream" id="i-stream">
                    <option value="">Select</option>
                    <?php 
                    $central_streams = getStreamOptions();
                    foreach($central_streams as $s_opt) {
                        $selected = ($student_data['Stream'] === $s_opt) ? 'selected' : '';
                        echo "<option value=\"$s_opt\" $selected>$s_opt</option>";
                    }
                    ?>
                </select>
            </div>
            <div class="grid-item"><label>Term</label>
                <select name="Term" id="i-term">
                    <option value="Term 1" <?php echo ($student_data['Term'] == 'Term 1') ? 'selected' : ''; ?>>Term 1</option>
                    <option value="Term 2" <?php echo ($student_data['Term'] == 'Term 2') ? 'selected' : ''; ?>>Term 2</option>
                    <option value="Term 3" <?php echo ($student_data['Term'] == 'Term 3') ? 'selected' : ''; ?>>Term 3</option>
                </select>
            </div>
            <div class="grid-item"><label>Residence</label>
                <select name="Residence" id="i-residence">
                    <option value="Day" <?php echo ($student_data['Residence'] == 'Day') ? 'selected' : ''; ?>>Day</option>
                    <option value="Boarding" <?php echo ($student_data['Residence'] == 'Boarding') ? 'selected' : ''; ?>>Boarding</option>
                </select>
            </div>
            <input type="hidden" name="EntryStatus" value="<?php echo $val($student_data['EntryStatus']); ?>">
        </div>
    </fieldset>

    <fieldset>
        <legend>6. Academic History</legend>
        <div class="grid-row">
            <div class="grid-item"><label>Former School</label> <input type="text" name="FormerSchool" value="<?php echo $val($student_data['FormerSchool']); ?>"></div>
            <div class="grid-item"><label>PLE Index No</label> <input type="text" name="PLEIndexNumber" value="<?php echo $val($student_data['PLEIndexNumber']); ?>"></div>
            <div class="grid-item"><label>PLE Aggregate</label> <input type="number" name="PLEAggregate" value="<?php echo $val($student_data['PLEAggregate']); ?>"></div>
            <div class="grid-item"><label>UCE Index No</label> <input type="text" name="UCEIndexNumber" value="<?php echo $val($student_data['UCEIndexNumber']); ?>"></div>
            <div class="grid-item"><label>UCE Results</label> <input type="text" name="UCEResult" value="<?php echo $val($student_data['UCEResult']); ?>"></div>
        </div>
    </fieldset>
</form>