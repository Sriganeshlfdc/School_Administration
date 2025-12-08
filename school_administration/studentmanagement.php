<?php
require_once 'config.php';

function is_filter_or_search_active() {
    return isset($_GET['search_id']) && !empty($_GET['search_id']) ||
           isset($_GET['search_name']) && !empty($_GET['search_name']) ||
           isset($_GET['level']) && !empty($_GET['level']) ||
           isset($_GET['class']) && !empty($_GET['class']) ||
           isset($_GET['term']) && !empty($_GET['term']) ||
           isset($_GET['admission_year']) && !empty($_GET['admission_year']) ||
           isset($_GET['residence']) && !empty($_GET['residence']);
}

function get_summary_filter_value($key, $default) {
    return htmlspecialchars(filter_input(INPUT_GET, $key, FILTER_SANITIZE_STRING) ?? $default);
}

$current_year = date('Y');
$selected_summary_year = get_summary_filter_value('summary_year', $current_year);
$selected_summary_term = get_summary_filter_value('summary_term', 'Term 1'); 
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Montfort School Dashboard</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="static/styles/base.css">
  <link rel="stylesheet" href="static/styles/student.css"> </head>
<body class="layout-wrapper light-theme">
  
  <?php include 'includes/navbar.php'; ?>

  <div class="layout">
    <?php include 'includes/sidebar.php'; ?>

    <div class="content" id="content">
      
      <div id="admission-module" class="module">
      <div class="form-container">
          <h1>Student Admission Application Form</h1>
          <form action="admission.php" method="POST" enctype="multipart/form-data">
              <fieldset>
                <legend><h3>I. Personal Information</h3></legend>
              <div class="input-group">
                  <div class="field half-width"><label for="name" class="required">Name</label><input type="text" id="name" name="name" required></div>
                  <div class="field half-width"><label for="surname" class="required">Surname</label><input type="text" id="surname" name="surname" required></div>
                  <div class="field half-width"><label for="dob">Date Of Birth</label><input type="date" id="dob" name="dob"></div>
                  <div class="field half-width">
                      <label for="gender" class="required">Gender</label>
                      <select id="gender" name="gender" required>
                          <option value="">Select Gender</option><option value="Male">Male</option><option value="Female">Female</option><option value="Other">Other</option>
                      </select>
                  </div>
                  <div class="field full-width"><label for="address">Student Address</label><textarea id="address" name="address" rows="3"></textarea></div>
              </div>
              </fieldset>

             <fieldset>
               <legend><h3>II. Parents & Guardian Information</h3></legend>
               
               <div class="subtitle" style="margin-top:10px; color:var(--primary-color);">Father's Details</div>
               <div class="input-group">
                  <div class="field full-width"><label for="father_name" class="required">Father's Name</label><input type="text" id="father_name" name="father_name" required></div>
                  <div class="field "><label for="father_contact">Father's Contact</label><input type="text" id="father_contact" name="father_contact"></div>
                  <div class="field"><label for="father_age">Age</label><input type="text" id="father_age" name="father_age"></div>
                  <div class="field full-width"><label for="father_occupation">Occupation</label><input type="text" id="father_occupation" name="father_occupation"></div>
                  <div class="field full-width"><label for="father_education">Education</label><input type="text" id="father_education" name="father_education"></div>
               </div>

               <div class="subtitle" style="margin-top:15px; color:var(--primary-color);">Mother's Details</div>
               <div class="input-group">
                  <div class="field full-width"><label for="mother_name" class="required">Mother's Name</label><input type="text" id="mother_name" name="mother_name" required></div>
                  <div class="field"><label for="mother_contact">Mother's Contact</label><input type="text" id="mother_contact" name="mother_contact"></div>
                  <div class="field"><label for="mother_age">Age</label><input type="text" id="mother_age" name="mother_age"></div>
                  <div class="field full-width"><label for="mother_occupation">Occupation</label><input type="text" id="mother_occupation" name="mother_occupation"></div>
                  <div class="field full-width"><label for="mother_education">Education</label><input type="text" id="mother_education" name="mother_education"></div>
               </div>

               <fieldset>
                <div class="subtitle" style="margin-top:15px; color:var(--primary-color);">Guardian Details (Optional)</div>
               <div class="input-group">
                  <div class="field full-width"><label for="guardian_name">Guardian Name</label><input type="text" id="guardian_name" name="guardian_name"></div>
                  <div class="field"><label for="guardian_contact">Guardian Contact</label><input type="text" id="guardian_contact" name="guardian_contact"></div>
                  <div class="field"><label for="guardian_relation">Relation</label>
                      <select id="guardian_relation" name="guardian_relation">
                          <option value="">Select Relation</option>
                          <option value="Brother">Brother</option>
                          <option value="Sister">Sister</option>
                          <option value="Uncle">Uncle</option>
                          <option value="Aunt">Aunt</option>
                          <option value="Grandparent">Grandparent</option>
                          <option value="Other">Other</option>
                      </select>
                  </div>
                  <div class="field"><label for="guardian_age">Age</label><input type="text" id="guardian_age" name="guardian_age"></div>
                  <div class="field"><label for="guardian_occupation">Occupation</label><input type="text" id="guardian_occupation" name="guardian_occupation"></div>
                  <div class="field full-width"><label for="guardian_address">Guardian Address</label><textarea id="guardian_address" name="guardian_address" rows="2"></textarea></div>
               </div>
             </fieldset>
             </fieldset>
              <fieldset>
                <legend><h3>III. Academic Records</h3></legend>
              <div class="input-group">
                  <div class="field full-width"><label for="former_school">Former School</label><input type="text" id="former_school" name="former_school"></div>
                  <div class="field half-width"><label for="ple_index">PLE Index Number</label><input type="text" id="ple_index" name="ple_index"></div>
                  <div class="field half-width"><label for="ple_agg">PLE Aggregate</label><input type="number" id="ple_agg" name="ple_agg" min="4" max="36"></div>
                  <div class="field half-width"><label for="uce_index">UCE Index Number</label><input type="text" id="uce_index" name="uce_index"></div>
                  <div class="field half-width"><label for="uce_result">UCE Result</label><input type="text" id="uce_result" name="uce_result"></div>
              </div>
              </fieldset>

              <fieldset>
              <legend><h3>IV. Enrollment Details</h3></legend>
              <div class="input-group">
                  <div class="field">
                      <label for="admission_year" class="required">Admission Year</label>
                      <input type="text" id="admission_year" name="admission_year" value="<?php echo date('Y'); ?>" required>
                      <small style="color: #666; font-size: 0.8em;">Sets Cohort & Academic Year</small>
                  </div>
                  <div class="field"><label for="term" class="required">Term</label><select id="term" name="term" required><option value="">Select Term</option><option value="Term 1">Term 1</option><option value="Term 2">Term 2</option><option value="Term 3">Term 3</option></select></div>
                  <div class="field"><label for="residence" class="required">Residence</label><select id="residence" name="residence" required><option value="">Select Residence</option><option value="Day">Day</option><option value="Boarding">Boarding</option></select></div>
                  <div class="field"><label for="entry_status" class="required">Entry Status</label><select id="entry_status" name="entry_status" required><option value="">Select Entry</option><option value="Continuing">Continuing</option><option value="New">New</option></select></div>
                  <div class="field"><label for="level" class="required">Level</label><select id="level" name="level" required><option value="">Select Level</option><option value="pre-primary">Pre-Primary</option><option value="primary">Primary</option><option value="secondary">Secondary</option></select></div>
                  <div class="field"><label for="class" class="required">Class</label><select id="class" name="class" required><option value="">Select Class</option></select></div>
                  <div class="field half-width">
                      <label for="stream">Stream</label>
                      <select id="stream" name="stream">
                          <option value="">Select Stream</option>
                          <?php 
                          $streams = getStreamOptions();
                          foreach($streams as $st) echo "<option value='$st'>$st</option>"; 
                          ?>
                      </select>
                  </div>
              </div>
              </fieldset>

              <fieldset>
              <legend><h3>V. Additional Information</h3></legend>
              <div class="input-group">
                  <div class="field half-width"><label for="more_info">More Information</label><textarea id="more_info" name="more_info" rows="3"></textarea></div>
                  <div class="field half-width"><label for="photo">Student Photo</label><div class="photo-upload"><input type="file" id="photo" name="photo" accept="image/*"><p>(Max 5MB)</p></div></div>
              </div>
              </fieldset>
              
             <div class="button-wrapper">
              <button type="button" id="admission-reset-btn" class="btn-primary">Reset</button>
               <button type="submit" class="btn-primary">Submit </button>
             </div>
          </form>
          
          <div class="modal-backdrop" id="submission-modal">
              <div class="modal-content"><i class="fa fa-check-circle modal-icon"></i><h4>Application Successful!</h4><p>The student record has been successfully saved.</p><button id="modal-close-btn" class="modal-close-btn">Close</button></div>
          </div>
          <div class="modal-backdrop" id="custom-alert-modal"><div class="modal-content"><i class="fa modal-icon" id="custom-alert-icon"></i><h4 id="custom-alert-title">Alert Title</h4><p id="custom-alert-message">Alert message content.</p><button id="custom-alert-close-btn" class="modal-close-btn">OK</button></div></div>
          </div>
      </div>
      
      <div id="list-module" class="module">
          <div class="viewer-container">
              <h2>View Students</h2>
             <form id="student-filter-form" class="filter-form" method="GET" action="studentmanagement.php#list">
                <input type="hidden" name="module" value="list"> 
                
                <div class="field-group"><label for="search-id">ID</label><input type="text" id="search-id" name="search_id" placeholder="ID..."></div>
                <div class="field-group"><label for="search-name">Name</label><input type="text" id="search-name" name="search_name" placeholder="Name..."></div>
                
                <div class="field-group"><label for="filter-level">Level</label><select id="filter-level" name="level"><option value="">All</option><option value="pre-primary">Pre-Primary</option><option value="primary">Primary</option><option value="secondary">Secondary</option></select></div>
                <div class="field-group"><label for="filter-class">Class</label><select id="filter-class" name="class"><option value="">All</option></select></div>
                
                <div class="field-group">
                    <label for="filter-stream">Stream</label>
                    <select id="filter-stream" name="stream">
                        <option value="">All</option>
                        <option value="A">A</option><option value="B">B</option><option value="C">C</option><option value="D">D</option><option value="E">E</option>
                    </select>
                </div>
                <div class="field-group">
                    <label for="filter-gender">Gender</label>
                    <select id="filter-gender" name="gender">
                        <option value="">All</option>
                        <option value="Male">Male</option><option value="Female">Female</option>
                    </select>
                </div>
                <div class="field-group">
                    <label for="filter-residence">Residence</label>
                    <select id="filter-residence" name="residence">
                        <option value="">All</option>
                        <option value="Day">Day</option><option value="Boarding">Boarding</option>
                    </select>
                </div>

                <div class="field-group"><label for="filter-term">Term</label><select id="filter-term" name="term"><option value="">All</option><option value="Term 1">Term 1</option><option value="Term 2">Term 2</option><option value="Term 3">Term 3</option></select></div>
                <div class="field-group"><label for="filter-year">Year</label><select id="filter-year" name="admission_year"><option value="">All</option><option value="2025">2025</option><option value="2024">2024</option></select></div>
                
                <div class="button-wrapper" style="align-self:flex-end;">
                    <button type="submit" class="btn-primary">Search</button>
                    <button type="button" id="reset-filter-btn" class="btn-primary" style="background: #6c757d;">Reset</button>
                </div>
            </form>

              <div id="student-list-results">
                  <?php 
                      if (isset($_GET['module']) && $_GET['module'] === 'list' && is_filter_or_search_active()) {
                          include 'viewstudents.php';
                      } else {
                          echo "<p style='text-align:center; padding: 40px; font-size: 1.1em; color: #555;'>Use the search options above to find students.</p>";
                      }
                  ?>
              </div>
          </div>
      </div>
      
      <div class="modal-backdrop" id="details-modal">
          <div class="modal-content large-modal">
              <div class="modal-header">
                  <h4 id="details-modal-title">Edit Student Details: <span id="modal-student-name"></span></h4>
                  <button id="details-close-btn" class="close-btn" aria-label="close details">&times;</button>
              </div>
              <form id="editStudentForm" action="edit_student.php" method="POST">
                  <div class="modal-body">
                      <input type="hidden" name="StudentID" id="modal-StudentID">
                      <div class="detail-section">
                          <div class="detail-photo">
                              <img id="detail-photo-img" src="" alt="Student Photo">
                              <p style="font-size: 0.8em; color: var(--text-color-light);">Photo (Read Only)</p>
                          </div>
                          <fieldset>
                              <legend>Personal & Enrollment</legend>
                              <div class="field half-width"><label for="modal-Name">Name</label><input type="text" id="modal-Name" name="Name" required></div>
                              <div class="field half-width"><label for="modal-Surname">Surname</label><input type="text" id="modal-Surname" name="Surname" required></div>
                              <div class="field half-width"><label>DOB (R/O)</label><input type="date" id="modal-DOB" name="DateOfBirth" readonly></div>
                              <div class="field half-width"><label>Gender (R/O)</label><input type="text" id="modal-Gender" name="Gender" readonly></div>
                              <div class="field full-width"><label for="modal-Address">Address</label><textarea id="modal-Address" name="Address" rows="2"></textarea></div>
                              <div class="field full-width"><p>Enrollment: <span id="detail-level"></span> / <span id="detail-class"></span></p></div>
                          </fieldset>
                          <fieldset>
                              <legend>Guardian Info</legend>
                              <div class="field full-width"><label for="modal-GuardianName">Guardian Name</label><input type="text" id="modal-GuardianName" name="guardian_name"></div>
                              <div class="field half-width"><label for="modal-ContactPrimary">Contact</label><input type="text" id="modal-ContactPrimary" name="guardian_contact"></div>
                          </fieldset>
                      </div>
                      <div class="button-wrapper" style="margin-top: 20px;">
                          <button type="submit" class="btn-primary" style="width: auto;">Save Changes</button>
                      </div>
                      <p id="editMessage" style="text-align: center; margin-top: 10px;"></p>
                  </div>
              </form>
          </div>
      </div>

      <div id="summary-module" class="module">
          <div class="viewer-container">
          <h2>Student Enrollment Summary</h2>
              <form id="summary-filter-form" class="filter-form" method="GET" action="studentmanagement.php#summary">
                  <input type="hidden" name="module" value="summary"> <div class="field-group">
                      <label for="summary_term">Term</label>
                      <select id="summary_term" name="summary_term" required>
                          <option value="Term 1" <?php if ($selected_summary_term == 'Term 1') echo 'selected'; ?>>Term 1</option>
                          <option value="Term 2" <?php if ($selected_summary_term == 'Term 2') echo 'selected'; ?>>Term 2</option>
                          <option value="Term 3" <?php if ($selected_summary_term == 'Term 3') echo 'selected'; ?>>Term 3</option>
                      </select>
                  </div>
                  <div class="field-group">
                      <label for="summary_year">Academic Year</label>
                      <select id="summary_year" name="summary_year" required>
                          <?php 
                          // Show formatted Academic Years
                          for ($y = $current_year; $y >= $current_year - 5; $y--) {
                              $ay = format_academic_year($y);
                              // We use the year part as value for simplicity in logic, OR the full string
                              // The logic in studentsummary.php needs to match. Let's use the string.
                              echo "<option value='$ay'>$ay</option>";
                          }
                          ?>
                      </select>
                  </div>
                  <div class="button-wrapper">
                      <button type="submit" class="btn-primary">Generate Summary</button>
                  </div>
              </form>
              <?php
              if (isset($_GET['module']) && $_GET['module'] === 'summary') {
                  include 'studentsummary.php';
              } else {
                   echo "<p style='text-align:center; padding: 40px; color: #555;'>Select filters to generate report.</p>";
              }
              ?>
          </div>
      </div>
      
      <div id="migrate-module" class="module">
          <?php include 'migrate_view.php'; ?>
      </div>

      <div id="quickedit-module" class="module"></div>
      <div id="academicedit-module" class="module"></div>
      <div id="searchstudent-module" class="module"></div>
      <div id="studentaccounts-module" class="module"></div>
      <div id="oldstudentdebt-module" class="module"></div>
      <div id="oldstudentrec-module" class="module"></div>
      <div id="studentcomments-module" class="module"></div> 
      
      <div class="overlay" id="overlay"></div>
      <div class="settings-panel" id="settings-panel">
        <div class="settings-header">
          <h3>Settings</h3><button id="settings-close-btn" class="close-btn">&times;</button>
        </div>
        <div class="settings-item theme-toggle"><strong>Theme</strong><button id="theme-toggle-btn" class="btn btn-secondary">Switch to Dark</button></div>
      </div>
    </div>
  </div>
  <script src="static/scripts/base.js"></script>
  <script src="static/scripts/student.js"></script>
</body>
</html>