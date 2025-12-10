<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// 2. Database Connection
require_once __DIR__ . '/../../config/config.php';

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
    <div id="admission-module" class="module" style="display: none;">
    <div class="form-container">
        <h1>Student Admission Application Form</h1>
            <form id="admission-form"> 
                <fieldset>
                    <legend>I. Personal Information</legend>
                    <div class="input-group">
                        <div class="field half-width">
                            <label for="name" class="required">First Name</label>
                            <input type="text" id="name" name="name" required>
                        </div>
                        <div class="field half-width">
                            <label for="surname" class="required">Surname</label>
                            <input type="text" id="surname" name="surname" required>
                        </div>
                        <div class="field third-width">
                            <label for="gender" class="required">Gender</label>
                            <select id="gender" name="gender" required>
                                <option value="">Select</option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                            </select>
                        </div>
                        <div class="field third-width">
                            <label for="dob">Date Of Birth</label>
                            <input type="date" id="dob" name="dob">
                        </div>

                        <div class="field full-width">
                            <div class="subtitle">Residential Address</div>
                        </div>

                        <div class="field quarter-width"><label>House No/Block</label><input type="text" name="house_no" placeholder="e.g. 12B"></div>
                        <div class="field quarter-width"><label>Street/Zone</label><input type="text" name="street" placeholder="Street Name"></div>
                        <div class="field quarter-width"><label>Village</label><input type="text" name="village" placeholder="Near..."></div>
                        <div class="field quarter-width"><label>Town/Village</label><input type="text" name="town" placeholder="Town"></div>

                        <div class="field third-width"><label>District</label><input type="text" name="district"></div>
                        <div class="field third-width"><label>State/Region</label><input type="text" name="state" ></div>
                        <div class="field third-width"><label>Country</label><input type="text" name="country" value="Uganda"></div>
                    </div>
                </fieldset>

                <fieldset>
                    <legend>II. Parents & Guardian</legend>

                    <div class="subtitle"> Father's Details</div>
                    <div class="input-group">
                        <div class="field half-width"><label class="required">Name</label><input type="text" name="father_name" required></div>
                        <div class="field quarter-width"><label>Age</label><input type="number" name="father_age" id="age"></div>
                        <div class="field half-width"><label>Contact</label><input type="text" name="father_contact"></div>
                        <div class="field half-width"><label>Email</label><input type="email" name="father_email" placeholder="email@example.com"></div>
                        <div class="field half-width"><label>Occupation</label><input type="text" name="father_occupation"></div>
                        <div class="field half-width"><label>Education</label><input type="text" name="father_education"></div>
                    </div>

                    <div class="subtitle mt-3">Mother's Details</div>
                    <div class="input-group">
                        <div class="field half-width"><label class="required">Name</label><input type="text" name="mother_name" required></div>
                        <div class="field quarter-width"><label>Age</label><input type="number" name="mother_age" id="age"></div>
                        <div class="field half-width"><label>Contact</label><input type="text" name="mother_contact"></div>
                        <div class="field half-width"><label>Email</label><input type="email" name="mother_email" placeholder="email@example.com"></div>
                        <div class="field half-width"><label>Occupation</label><input type="text" name="mother_occupation"></div>
                        <div class="field half-width"><label>Education</label><input type="text" name="mother_education"></div>
                    </div>

                    <fieldset class="nested-fieldset mt-3">
                        <legend>Guardian (Optional)</legend>
                        <div class="input-group">
                            <div class="field half-width"><label>Name</label><input type="text" name="guardian_name"></div>
                            <div class="field quarter-width"><label>Age</label><input type="number" name="guardian_age" id="age"></div>
                            <div class="field third-width"><label>Contact</label><input type="text" name="guardian_contact"></div>
                            <div class="field third-width"><label>Email</label><input type="email" name="guardian_email"></div>

                            <div class="field quarter-width">
                                <label>Relation</label>
                                <select name="guardian_relation">
                                    <option value="">Select</option>
                                    <option value="Uncle">Uncle</option>
                                    <option value="Aunt">Aunt</option>
                                    <option value="Grandparent">Grandparent</option>
                                    <option value="Brother">Brother</option>
                                    <option value="Sister">Sister</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            
                            <div class="field third-width"><label>Occupation</label><input type="text" name="guardian_occupation"></div>
                            <div class="field half-width"><label>Education</label><input type="text" name="guardian_education"></div>
                            <div class="field full-width"><label>Address</label><input type="text" name="guardian_address" placeholder="If different from student"></div>
                        </div>
                    </fieldset>
                </fieldset>

                <fieldset>
                    <legend>III. Academic History</legend>
                    <div class="input-group">
                        <div class="field full-width"><label>Former School</label><input type="text" name="former_school"></div>
                        <div class="field quarter-width"><label>PLE Index</label><input type="text" name="ple_index"></div>
                        <div class="field quarter-width"><label>PLE Agg</label><input type="number" name="ple_agg" id="ple_agg"></div>
                        <div class="field quarter-width"><label>UCE Index</label><input type="text" name="uce_index"></div>
                        <div class="field quarter-width"><label>UCE Result</label><input type="text" name="uce_result"></div>
                    </div>
                </fieldset>

                <fieldset>
                    <legend>IV. Enrollment Details</legend>
                    <div class="input-group">
                        <div class="field quarter-width">
                            <label class="required">Admsn Year</label>
                            <input type="text" name="admission_year" value="<?php echo date('Y'); ?>" required>
                        </div>
                        <div class="field quarter-width">
                            <label class="required">Term</label>
                            <select name="term" required>
                                <option value="Term 1">Term 1</option>
                                <option value="Term 2">Term 2</option>
                                <option value="Term 3">Term 3</option>
                            </select>
                        </div>
                        <div class="field quarter-width">
                            <label class="required">Level</label>
                            <select id="level" name="level" required>
                                <option value="">Select</option>
                                <option value="pre-primary">Pre-Primary</option>
                                <option value="primary">Primary</option>
                                <option value="secondary">Secondary</option>
                            </select>
                        </div>
                        <div class="field quarter-width"><label class="required">Class</label><select id="class" name="class" required><option value="">Select</option></select></div>

                        <div class="field quarter-width">
                            <label>Stream</label>
                            <select id="stream" name="stream">
                                <option value="">Select</option>
                                <?php foreach(getStreamOptions() as $st) echo "<option value='$st'>$st</option>"; ?>
                            </select>
                        </div>
                        <div class="field quarter-width">
                            <label class="required">Residence</label>
                            <select name="residence" required>
                                <option value="Day">Day</option>
                                <option value="Boarding">Boarding</option>
                            </select>
                        </div>
                        <div class="field quarter-width">
                            <label class="required">Entry Status</label>
                            <select name="entry_status" required>
                                <option value="New">New</option>
                                <option value="Continuing">Continuing</option>
                            </select>
                        </div>
                    </div>
                </fieldset>

                <fieldset>
                    <legend>V. Photo & Extras</legend>
                    <div class="input-group">
                        <div class="field half-width">
                            <label>More Information</label>
                            <textarea name="more_info" rows="4" class="text-area-medium"></textarea>
                        </div>
                        <div class="field half-width">
                            <label>Student Photo</label>
                            <div id="admission-photo-wrapper">
                                <div class="photo-upload" id="admission-photo-container">
                                    <div id="upload-placeholder" class="upload-placeholder-content">
                                        <i class="fa fa-camera upload-icon"></i>
                                        <p class="upload-text">Click to Upload</p>
                                        <span class="upload-note">(Max 5MB)</span>
                                    </div>
                                    <input type="file" id="photo" name="photo" accept="image/*">
                                </div>
                                <img id="admission-photo-preview" class="photo-preview-side" src="" alt="Preview">
                            </div>
                        </div>
                    </div>
                </fieldset>

                <div class="button-wrapper">
                    <button type="button" id="admission-reset-btn" class="btn-primary btn-gray">Reset</button>
                    <button type="submit" class="btn-primary">Submit Admission</button>
                </div>
            </form>
        </div>
    </div>
      <div id="list-module" class="module" style="display: none;">
          <div class="viewer-container">
              <h2>View Students</h2>
             <form id="student-filter-form" class="filter-form">
                <input type="hidden" name="module" value="list"> 
                
                <div class="field-group"><label for="search-id">ID</label><input type="text" id="search-id" name="search_id" placeholder="ID..."></div>
                <div class="field-group"><label for="search-name">Name</label><input type="text" id="search-name" name="search_name" placeholder="Name..."></div>
                
                <div class="field-group"><label for="filter-level">Level</label><select id="filter-level" name="level"><option value="">All</option><option value="pre-primary">Pre-Primary</option><option value="primary">Primary</option><option value="secondary">Secondary</option></select></div>
                <div class="field-group">
                    <label for="filter-class">Class</label>
                    <select id="filter-class" name="class">
                        <option value="">All</option>
                    </select></div>
                
                <div class="field-group">
                    <label for="filter-stream">Stream</label>
                    <select id="filter-stream" name="stream">
                        <option value="">All</option>
                        <?php 
                          $streams = getStreamOptions();
                          foreach($streams as $st) echo "<option value='$st'>$st</option>"; 
                          ?>
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
                
                <div class="button-wrapper align-self-end">
                    <button type="submit" class="btn-primary">Search</button>
                    <button type="button" id="reset-filter-btn" class="btn-primary btn-gray">Reset</button>
                </div>
            </form>

              <div id="student-list-results">
                  <?php 
                      if (isset($_GET['module']) && $_GET['module'] === 'list' && is_filter_or_search_active()) {
                          include 'partial/viewstudents.php';
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

      <div id="summary-module" class="module" style="display: none;">
          <div class="viewer-container">
          <h2>Student Enrollment Summary</h2>
              <form id="summary-filter-form" class="filter-form">
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
                          for ($y = $current_year; $y >= $current_year - 5; $y--) {
                              $ay = format_academic_year($y);
                              echo "<option value='$ay'>$ay</option>";
                          }
                          ?>
                      </select>
                  </div>
                  <div class="button-wrapper">
                      <button type="submit" class="btn-primary">Generate Summary</button>
                  </div>
              </form>
              
              <div id="summary-results">
                  <?php
                  if (isset($_GET['module']) && $_GET['module'] === 'summary') {
                      include 'partial/studentsummary.php';
                  } else {
                       echo "<p style='text-align:center; padding: 40px; color: #555;'>Select filters to generate report.</p>";
                  }
                  ?>
              </div>
          </div>
      </div>
      <div id="profile-module" class="module" style="display: none;"></div>
      <div id="migrate-module" class="module" style="display: none;">
          <?php include 'partial/migrate_view.php'; ?>
      </div>

      <div id="quickedit-module" class="module" style="display: none;"></div>
      <div id="academicedit-module" class="module" style="display: none;"></div>
      <div id="searchstudent-module" class="module" style="display: none;"></div>
      <div id="studentaccounts-module" class="module" style="display: none;"></div>
      <div id="oldstudentdebt-module" class="module" style="display: none;"></div>
      <div id="oldstudentrec-module" class="module" style="display: none;"></div>
      <div id="studentcomments-module" class="module" style="display: none;"></div> 
      
      <div class="overlay" id="overlay"></div>
      <div class="settings-panel" id="settings-panel">
        <div class="settings-header">
          <h3>Settings</h3><button id="settings-close-btn" class="close-btn">&times;</button>
        </div>
        <div class="settings-item theme-toggle"><strong>Theme</strong><button id="theme-toggle-btn" class="btn btn-secondary">Switch to Dark</button></div>
      </div>