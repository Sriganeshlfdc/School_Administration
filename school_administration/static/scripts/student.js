document.addEventListener('DOMContentLoaded', () => {
    console.log("STATUS: Student.js loaded.");

    // =========================================================================
    // 1. DATA CONSTANTS
    // =========================================================================
    const classes = {
        'pre-primary' : ['PP.1', 'PP.2', 'PP.3'],
        'primary': ['P.1', 'P.2', 'P.3', 'P.4', 'P.5', 'P.6', 'P.7'],
        'secondary': ['S.1', 'S.2', 'S.3', 'S.4', 'S.5', 'S.6']
    };

    // =========================================================================
    // 2. HELPER FUNCTIONS & STANDARDIZED POPUPS
    // =========================================================================

    function setModalValue(id, value, isInput = true) {
        const element = document.getElementById(id);
        if (element) {
            const formattedValue = (value === null || value === undefined) ? '' : value;
            if (isInput) {
                element.value = formattedValue;
            } else {
                element.textContent = formattedValue;
            }
        }
    }

    function closeModal(targetModal) {
        if (targetModal) targetModal.classList.remove('show');
    }

    function populateClassDropdown(levelEl, classEl, includeAll = false) {
        if (!levelEl || !classEl) return;
        
        let selected = levelEl.value ? levelEl.value.toLowerCase().trim() : '';
        classEl.innerHTML = includeAll ? '<option value="">All Classes</option>' : '<option value="">Select Class</option>';
        
        if (classes[selected]) {
            classes[selected].forEach(cls => {
                const opt = document.createElement('option');
                opt.value = cls;
                opt.textContent = cls;
                classEl.appendChild(opt);
            });
        }
    }

    // --- STANDARDIZED POPUP LOGIC ---

    function getOrCreateModalContainer() {
        let container = document.getElementById('custom-alert-modal');
        if (!container) {
            container = document.createElement('div');
            container.id = 'custom-alert-modal';
            container.className = 'modal-backdrop';
            document.body.appendChild(container);
            
            container.addEventListener('click', (e) => {
                if (e.target === container) closeModal(container);
            });
        }
        return container;
    }

    /**
     * Global Custom Alert Function
     * Uses CSS classes for styling instead of inline styles.
     */
    window.showCustomAlert = function(type, title, message) {
        const modalContainer = getOrCreateModalContainer();

        let variantClass = 'info';
        let iconClass = 'fa-info';

        if (type === 'success') { 
            variantClass = 'success';
            iconClass = 'fa-check';
        } else if (type === 'error') { 
            variantClass = 'error';
            iconClass = 'fa-times';
        } else if (type === 'warning') { 
            variantClass = 'warning';
            iconClass = 'fa-exclamation';
        }

        // Clean HTML with classes
        modalContainer.innerHTML = `
            <div class="modal-content confirm-modal animated-pop">
                <div class="success-header">
                    <div class="confirm-icon-circle ${variantClass}">
                        <i class="fa ${iconClass}"></i>
                    </div>
                </div>
                <h4 class="modal-title">${title}</h4>
                <p class="modal-message">${message}</p>
                <div class="modal-actions centered">
                    <button class="btn-primary modal-close-btn ${variantClass}">OK</button>
                </div>
            </div>
        `;

        const btn = modalContainer.querySelector('.modal-close-btn');
        if (btn) btn.onclick = () => closeModal(modalContainer);

        modalContainer.classList.add('show');
    };

    /**
     * Standardized Delete Confirmation Function
     */
    window.showDeleteConfirmModal = function(studentId, studentName) {
        const modalContainer = getOrCreateModalContainer();

        modalContainer.innerHTML = `
            <div class="modal-content confirm-modal animated-pop">
                <div class="success-header">
                    <div class="confirm-icon-circle error">
                        <i class="fa fa-trash"></i>
                    </div>
                </div>
                <h4 class="modal-title">Confirm Permanent Deletion</h4>
                <p class="modal-message">
                    Are you sure you want to delete <strong>${studentName}</strong> (ID: ${studentId})?<br>
                    <span class="warning-text">This action cannot be undone.</span>
                </p>
                <div class="modal-actions centered">
                    <button class="btn-primary modal-cancel-btn">Cancel</button>
                    <button id="dynamic-delete-btn" class="btn-primary modal-delete-btn">Delete Record</button>
                </div>
            </div>
        `;

        const cancelBtn = modalContainer.querySelector('.modal-cancel-btn');
        const deleteBtn = modalContainer.querySelector('#dynamic-delete-btn');

        if(cancelBtn) cancelBtn.onclick = () => closeModal(modalContainer);
        if(deleteBtn) deleteBtn.onclick = () => {
            window.location.href = `deletestudent.php?id=${studentId}`;
        };

        modalContainer.classList.add('show');
        return false;
    };

    // =========================================================================
    // 3. DROPDOWN INITIALIZATION
    // =========================================================================

    const admLevel = document.getElementById('level');
    const admClass = document.getElementById('class');
    if (admLevel && admClass) {
        admLevel.addEventListener('change', () => populateClassDropdown(admLevel, admClass));
    }

    const filterLevel = document.getElementById('filter-level');
    const filterClass = document.getElementById('filter-class');
    const resetFilterBtn = document.getElementById('reset-filter-btn');
    
    if (filterLevel && filterClass) {
        filterLevel.addEventListener('change', () => populateClassDropdown(filterLevel, filterClass, true));
        if (filterLevel.value) populateClassDropdown(filterLevel, filterClass, true);
    }

    if (resetFilterBtn) {
        resetFilterBtn.addEventListener('click', () => {
            window.location.href = window.location.pathname + '#list';
            window.location.reload();
        });
    }

    const profileLevel = document.getElementById('i-level');
    const profileClass = document.getElementById('i-class');

    if (profileLevel && profileClass) {
        profileLevel.addEventListener('change', () => {
             populateClassDropdown(profileLevel, profileClass);
        });

        const currentClassValue = profileClass.getAttribute('data-current'); 
        populateClassDropdown(profileLevel, profileClass);
        
        if (currentClassValue) {
            let found = false;
            for (let i = 0; i < profileClass.options.length; i++) {
                if (profileClass.options[i].value === currentClassValue) {
                    profileClass.selectedIndex = i;
                    found = true;
                    break;
                }
            }
            if (!found) {
                const opt = document.createElement('option');
                opt.value = currentClassValue;
                opt.textContent = currentClassValue + " (Legacy)";
                opt.selected = true;
                profileClass.appendChild(opt);
            }
        }
    }

    // =========================================================================
    // 4. MODAL & UI LOGIC
    // =========================================================================

    const detailsModal = document.getElementById('details-modal');
    const detailsCloseBtn = document.getElementById('details-close-btn');
    const customAlertModal = document.getElementById('custom-alert-modal');
    
    if (detailsCloseBtn) detailsCloseBtn.addEventListener('click', () => closeModal(detailsModal));

    [customAlertModal, detailsModal].forEach(modal => {
        if (modal) {
            modal.addEventListener('click', (e) => {
                if (e.target === modal) closeModal(modal);
            });
        }
    });

    const urlParams = new URLSearchParams(window.location.search);
    const status = urlParams.get('status');
    const idParam = urlParams.get('id');
    const msgParam = urlParams.get('msg');

    function cleanUrl() {
        if (history.replaceState) {
            const clean = window.location.pathname + window.location.hash;
            history.replaceState(null, '', clean);
        }
    }

    if (status === 'success' && idParam) {
        window.showCustomAlert('success', 'Operation Successful', `Student ID <strong>${idParam}</strong> has been processed.`);
        cleanUrl();
    } else if (status === 'delete_success' && idParam) {
        window.showCustomAlert('success', 'Deletion Successful', `Student ID <strong>${idParam}</strong> has been successfully deleted.`);
        cleanUrl();
    } else if (status === 'delete_error') {
        const safeMsg = msgParam ? decodeURIComponent(msgParam).replace(/</g, "&lt;") : "Unknown error";
        window.showCustomAlert('error', 'Operation Failed', `Error: ${safeMsg}`);
        cleanUrl();
    }

    // =========================================================================
    // 5. TABLE ACTIONS & VIEW PROFILE AJAX
    // =========================================================================
    
    const studentListResults = document.getElementById('student-list-results');
    if (studentListResults) {
        studentListResults.addEventListener('click', function(e) {
            const profileBtn = e.target.closest('.profile-trigger-btn');
            const editBtn = e.target.closest('.edit-btn');
            const deleteBtn = e.target.closest('.delete-btn');

            if (profileBtn) {
                e.preventDefault();
                const studentId = profileBtn.dataset.id;
                loadProfileViaAjax(studentId);
            } else if (editBtn) {
                e.preventDefault();
                const studentId = editBtn.dataset.id;
                const studentName = editBtn.dataset.name || 'Student';
                openEditModal(studentId, studentName);
            } else if (deleteBtn) {
                const sId = deleteBtn.dataset.id;
                const row = deleteBtn.closest('tr');
                const name = row ? row.cells[1].querySelector('strong').textContent : 'Student'; 
                window.showDeleteConfirmModal(sId, name);
            }
        });
    }

    function loadProfileViaAjax(studentId) {
        const profileModule = document.getElementById('profile-module');
        if(!profileModule && document.getElementById('list-module')) {
            window.location.href = `studentprofile.php?id=${studentId}`;
            return;
        }
        
        if (profileModule) {
            window.location.hash = 'profile'; 
            profileModule.innerHTML = '<div style="text-align:center; padding:50px;"><h2>Loading Profile...</h2><i class="fa fa-spinner fa-spin fa-3x"></i></div>';
            document.querySelectorAll('.module').forEach(m => m.style.display = 'none');
            profileModule.style.display = 'block';

            fetch(`get_student_profile.php?id=${studentId}`)
                .then(response => response.text())
                .then(html => {
                    profileModule.innerHTML = html;
                })
                .catch(err => {
                    console.error(err);
                    profileModule.innerHTML = '<p class="error">Failed to load profile.</p>';
                });
        }
    }

    function openEditModal(studentId, name) {
        if (!detailsModal) return;
        const nameSpan = document.getElementById('modal-student-name');
        if(nameSpan) nameSpan.textContent = "Loading...";
        
        fetch(`get_student.php?id=${studentId}`)
            .then(res => res.json())
            .then(response => {
                if (response.success) {
                    const data = response.data;
                    if(nameSpan) nameSpan.textContent = data.Name + ' ' + data.Surname;
                    setModalValue('modal-StudentID', data.StudentID);
                    
                    const photoImg = document.getElementById('detail-photo-img');
                    if(photoImg) photoImg.src = data.PhotoPath ? data.PhotoPath : 'static/images/default_profile.png';

                    setModalValue('modal-Name', data.Name);
                    setModalValue('modal-Surname', data.Surname);
                    setModalValue('modal-DOB', data.DateOfBirth);
                    setModalValue('modal-Gender', data.Gender);
                    setModalValue('modal-Address', data.Address);
                    setModalValue('detail-level', data.Level, false);
                    setModalValue('detail-class', data.Class, false);
                    setModalValue('detail-term', data.Term, false);
                    setModalValue('modal-GuardianName', data.GuardianName);
                    setModalValue('modal-ContactPrimary', data.ContactPrimary);
                    setModalValue('modal-GuardianNotes', data.GuardianNotes);
                    
                    detailsModal.classList.add('show');
                } else {
                    window.showCustomAlert('error', 'Error', response.message || 'Failed to fetch details');
                }
            })
            .catch(err => {
                console.error(err);
                window.showCustomAlert('error', 'Network Error', 'Could not connect to server.');
            });
    }

    // =========================================================================
    // 6. EDIT FORM SUBMISSION & TOGGLE
    // =========================================================================
    
    window.togglePageEditMode = function(mode) {
        const viewContent = document.getElementById('view-mode-content');
        const editForm = document.getElementById('edit-mode-form');
        const editBtn = document.getElementById('edit-btn'); 
        const saveCancelGroup = document.getElementById('save-cancel-group');
        
        if (!viewContent || !editForm) return;

        if (mode === 'edit') {
            viewContent.style.display = 'none';
            editForm.style.display = 'block'; 
            if(editBtn) editBtn.style.display = 'none';
            if(saveCancelGroup) saveCancelGroup.style.display = 'flex';
        } else {
            viewContent.style.display = 'block'; 
            editForm.style.display = 'none';
            if(editBtn) editBtn.style.display = 'inline-flex';
            if(saveCancelGroup) saveCancelGroup.style.display = 'none';
        }
    };

    window.submitEditForm = function() {
        const form = document.getElementById('edit-mode-form');
        if (!form) return;
        const formData = new FormData(form);

        fetch('edit_student.php', { method: 'POST', body: formData })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                window.showCustomAlert('success', 'Update Successful', 'Student details updated.');
                setTimeout(() => window.location.reload(), 1000); 
            } else {
                window.showCustomAlert('error', 'Update Failed', data.message || 'Unknown error.');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            window.showCustomAlert('error', 'Network Error', 'Failed to connect.');
        });
    };

    function handleEditSubmit(e, statusElementId) {
        e.preventDefault();
        const form = e.target;
        const saveStatus = document.getElementById(statusElementId);
        if (saveStatus) { saveStatus.textContent = 'Saving...'; saveStatus.style.color = 'blue'; }

        fetch(form.action, { method: 'POST', body: new FormData(form) })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                if (saveStatus) { saveStatus.textContent = 'Saved!'; saveStatus.style.color = 'green'; }
                if (detailsModal && detailsModal.classList.contains('show')) closeModal(detailsModal);
                
                window.showCustomAlert('success', 'Updated', 'Student details updated successfully.');
                
                const filterForm = document.getElementById('student-filter-form');
                if (filterForm) filterForm.submit(); 
            } else {
                const msg = data.message || 'Unknown error';
                if (saveStatus) { saveStatus.textContent = 'Error: ' + msg; saveStatus.style.color = 'red'; }
                else { window.showCustomAlert('error', 'Update Failed', msg); }
            }
        })
        .catch(err => {
            console.error(err);
            if (saveStatus) { saveStatus.textContent = 'Network Error'; saveStatus.style.color = 'red'; }
        });
    }

    document.addEventListener('submit', function(e) {
        if (e.target && e.target.id === 'editStudentForm') {
            handleEditSubmit(e, 'editMessage');
        }
    });

    // =========================================================================
    // 7. SUMMARY TABS & PHOTO
    // =========================================================================

    function switchSummaryTab(targetTab) {
        const tabs = document.querySelectorAll('.summary-tabs .tab-button');
        const contents = document.querySelectorAll('.summary-container .tab-content');
        if (!tabs.length) return;
        tabs.forEach(t => t.classList.remove('active'));
        contents.forEach(c => c.classList.remove('active'));
        const activeBtn = document.querySelector(`.summary-tabs .tab-button[data-tab="${targetTab}"]`);
        const activeContent = document.getElementById(targetTab);
        if (activeBtn) activeBtn.classList.add('active');
        if (activeContent) activeContent.classList.add('active');
        
        if (activeContent && activeContent.querySelector('.sub-tab-navigation')) {
             const firstSubBtn = activeContent.querySelector('.sub-tab-button');
             if(firstSubBtn) switchSubTab(firstSubBtn.dataset.subTab);
        }
    }

    function switchSubTab(targetSubTab) {
        const subTabs = document.querySelectorAll('.sub-tab-navigation .sub-tab-button');
        const subContents = document.querySelectorAll('.sub-tab-content');
        if (!subTabs.length) return;
        subTabs.forEach(t => t.classList.remove('active'));
        subContents.forEach(c => c.classList.remove('active'));
        const activeBtn = document.querySelector(`.sub-tab-navigation .sub-tab-button[data-sub-tab="${targetSubTab}"]`);
        const activeContent = document.getElementById(targetSubTab);
        if (activeBtn) activeBtn.classList.add('active');
        if (activeContent) activeContent.classList.add('active');
    }

    const summaryTabs = document.querySelectorAll('.summary-tabs .tab-button');
    if(summaryTabs.length > 0) summaryTabs.forEach(btn => btn.addEventListener('click', function() { switchSummaryTab(this.dataset.tab); }));

    const subSummaryTabs = document.querySelectorAll('.sub-tab-navigation .sub-tab-button');
    if(subSummaryTabs.length > 0) subSummaryTabs.forEach(btn => btn.addEventListener('click', function() { switchSubTab(this.dataset.subTab); }));

    window.triggerPhotoUpload = function() {
        const fileInput = document.getElementById('edit-photo');
        if (fileInput) fileInput.click();
    };
    const photoInput = document.getElementById('edit-photo');
    if (photoInput) {
        photoInput.addEventListener('change', function(e) {
            if (e.target.files && e.target.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const displayPhoto = document.getElementById('display-photo');
                    if (displayPhoto) displayPhoto.src = e.target.result;
                    window.togglePageEditMode('edit');
                }
                reader.readAsDataURL(e.target.files[0]);
            }
        });
    }

    // =========================================================================
    // 9. MIGRATION MODULE LOGIC
    // =========================================================================

    const migSourceLevel = document.getElementById('mig-source-level');
    const migSourceClass = document.getElementById('mig-source-class');
    const migSourceStream = document.getElementById('mig-source-stream');
    const migSourceYear = document.getElementById('mig-source-year');
    
    const migTargetLevel = document.getElementById('mig-target-level');
    const migTargetClass = document.getElementById('mig-target-class');
    
    const btnFetchStudents = document.getElementById('btn-fetch-students');
    const btnMigrateClass = document.getElementById('btn-migrate-class'); 
    const btnMigrateSelected = document.getElementById('btn-migrate-selected'); 
    
    const migResultsArea = document.getElementById('migration-results-area');
    const migTableBody = document.querySelector('#migration-table tbody');
    const migSelectAll = document.getElementById('mig-select-all');
    const selectionCountDisplay = document.getElementById('selection-count');

    let pendingMigrationData = null;

    if (migSourceLevel && migSourceClass) {
        migSourceLevel.addEventListener('change', () => populateClassDropdown(migSourceLevel, migSourceClass));
    }
    if (migTargetLevel && migTargetClass) {
        migTargetLevel.addEventListener('change', () => populateClassDropdown(migTargetLevel, migTargetClass));
    }

    if (btnFetchStudents) {
        btnFetchStudents.addEventListener('click', () => {
            const level = migSourceLevel.value;
            const cls = migSourceClass.value;
            const stream = migSourceStream ? migSourceStream.value : '';
            const year = migSourceYear ? migSourceYear.value : '';

            if (!level || !cls) {
                window.showCustomAlert('warning', 'Missing Selection', 'Please select Source Level and Class.');
                return;
            }

            migResultsArea.style.display = 'block';
            migTableBody.innerHTML = '<tr><td colspan="7" style="text-align:center; padding: 20px;"><i class="fa fa-spinner fa-spin fa-2x" style="color:var(--primary-color);"></i><p>Loading records...</p></td></tr>';

            const url = `fetch_students_migration.php?level=${encodeURIComponent(level)}&class=${encodeURIComponent(cls)}&stream=${encodeURIComponent(stream)}&year=${encodeURIComponent(year)}`;

            fetch(url)
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        migTableBody.innerHTML = ''; 
                        if (data.data.length === 0) {
                            migTableBody.innerHTML = '<tr><td colspan="7" style="text-align:center; padding: 20px;">No students found matching these criteria.</td></tr>';
                        } else {
                            data.data.forEach(s => {
                                const photoUrl = s.PhotoPath ? s.PhotoPath : 'static/images/default_profile.png';
                                const row = `
                                    <tr>
                                        <td style="text-align: center;">
                                            <input type="checkbox" class="mig-checkbox" value="${s.StudentID}">
                                        </td>
                                        <td><img src="${photoUrl}" alt="Photo" class="student-photo-thumb"></td>
                                        <td>
                                            <strong>${s.Name} ${s.Surname}</strong><br>
                                            <span style="font-size:0.85em; color:var(--text-color-light);">ID: ${s.StudentID}</span>
                                        </td>
                                        <td>${s.Level} - ${s.Class}</td>
                                        <td>${s.Stream || '-'}</td>
                                        <td>${s.AcademicYear}</td>
                                        <td>
                                            <button class="btn-action view-btn mig-single-btn" 
                                                data-id="${s.StudentID}" 
                                                data-name="${s.Name} ${s.Surname}"
                                                style="font-size:0.8em; padding: 5px 10px;">
                                                <i class="fa fa-share"></i> Migrate
                                            </button>
                                        </td>
                                    </tr>
                                `;
                                migTableBody.insertAdjacentHTML('beforeend', row);
                            });
                            bindMigrationEvents();
                        }
                    } else {
                        migTableBody.innerHTML = `<tr><td colspan="7" style="text-align:center; color:red;">Error: ${data.message}</td></tr>`;
                    }
                    updateSelectionCount();
                })
                .catch(err => {
                    console.error(err);
                    migTableBody.innerHTML = '<tr><td colspan="7" style="text-align:center; color:red;">Network Error</td></tr>';
                });
        });
    }

    function bindMigrationEvents() {
        const checkboxes = document.querySelectorAll('.mig-checkbox');
        checkboxes.forEach(cb => cb.addEventListener('change', updateSelectionCount));

        const singleBtns = document.querySelectorAll('.mig-single-btn');
        singleBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                const id = this.dataset.id;
                const name = this.dataset.name;
                initiateMigration([id], `Student: ${name}`);
            });
        });
    }

    function updateSelectionCount() {
        if(selectionCountDisplay) {
            const count = document.querySelectorAll('.mig-checkbox:checked').length;
            selectionCountDisplay.textContent = count;
        }
    }

    if (migSelectAll) {
        migSelectAll.addEventListener('change', function() {
            const checkboxes = document.querySelectorAll('.mig-checkbox');
            checkboxes.forEach(cb => cb.checked = this.checked);
            updateSelectionCount();
        });
    }

    if (btnMigrateSelected) {
        btnMigrateSelected.addEventListener('click', () => {
            const selected = Array.from(document.querySelectorAll('.mig-checkbox:checked')).map(cb => cb.value);
            if (selected.length === 0) {
                window.showCustomAlert('warning', 'No Selection', 'Please select at least one student.');
                return;
            }
            initiateMigration(selected, `${selected.length} Selected Students`);
        });
    }

    if (btnMigrateClass) {
        btnMigrateClass.addEventListener('click', () => {
            const allCheckboxes = document.querySelectorAll('.mig-checkbox');
            if (allCheckboxes.length === 0) {
                window.showCustomAlert('warning', 'No Data', 'Fetch students first.');
                return;
            }
            allCheckboxes.forEach(cb => cb.checked = true);
            updateSelectionCount();
            const allIds = Array.from(allCheckboxes).map(cb => cb.value);
            initiateMigration(allIds, 'Entire Class');
        });
    }

    const migConfirmModal = document.getElementById('migration-confirm-modal');
    const migSuccessModal = document.getElementById('migration-success-modal');
    
    const btnConfirmProceed = document.getElementById('mig-confirm-proceed-btn');
    const btnConfirmCancel = document.getElementById('mig-confirm-cancel-btn');
    const btnSuccessClose = document.getElementById('mig-success-close-btn');

    [btnConfirmCancel, btnSuccessClose].forEach(btn => {
        if(btn) btn.addEventListener('click', () => {
            if(migConfirmModal) migConfirmModal.classList.remove('show');
            if(migSuccessModal) migSuccessModal.classList.remove('show');
        });
    });

    if(btnConfirmProceed) {
        btnConfirmProceed.addEventListener('click', () => {
            if(pendingMigrationData) {
                executeMigration(pendingMigrationData);
            }
        });
    }

    function initiateMigration(studentIds, subjectName) {
        const targetYear = document.getElementById('mig-target-year').value;
        const targetTerm = document.getElementById('mig-target-term').value;
        const targetLevelVal = document.getElementById('mig-target-level').value;
        const targetClassVal = document.getElementById('mig-target-class').value;
        const targetStream = document.getElementById('mig-target-stream').value;

        if (!targetYear || !targetTerm || !targetLevelVal || !targetClassVal) {
            window.showCustomAlert('warning', 'Invalid Destination', 'Please select all "Migrate To" fields.');
            return;
        }

        pendingMigrationData = {
            student_ids: studentIds,
            target_year: targetYear,
            target_term: targetTerm,
            target_level: targetLevelVal,
            target_class: targetClassVal,
            target_stream: targetStream
        };

        const msgEl = document.getElementById('mig-confirm-message');
        const destEl = document.getElementById('mig-confirm-dest');
        
        if(msgEl) msgEl.innerHTML = `Are you sure you want to migrate <strong>${subjectName}</strong>?`;
        if(destEl) destEl.textContent = `${targetClassVal} (${targetStream ? 'Stream '+targetStream : 'No Stream'}) - ${targetTerm}, ${targetYear}`;

        if(migConfirmModal) migConfirmModal.classList.add('show');
    }

    function executeMigration(dataPayload) {
        if(btnConfirmProceed) {
            btnConfirmProceed.textContent = "Processing...";
            btnConfirmProceed.disabled = true;
        }

        fetch('migrate_backend.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(dataPayload)
        })
        .then(res => res.json())
        .then(data => {
            if(btnConfirmProceed) {
                btnConfirmProceed.textContent = "Confirm";
                btnConfirmProceed.disabled = false;
            }
            if(migConfirmModal) migConfirmModal.classList.remove('show');

            if (data.success) {
                const targetStr = `${dataPayload.target_level} - ${dataPayload.target_class}`;
                const periodStr = `${dataPayload.target_term}, ${dataPayload.target_year}`;
                
                const countEl = document.getElementById('mig-success-count');
                if(countEl) countEl.textContent = dataPayload.student_ids.length;
                
                const targetEl = document.getElementById('mig-success-target');
                if(targetEl) targetEl.textContent = targetStr;
                
                const periodEl = document.getElementById('mig-success-period');
                if(periodEl) periodEl.textContent = periodStr;
                
                if(migSuccessModal) migSuccessModal.classList.add('show');
                
                btnFetchStudents.click();
                if(migSelectAll) migSelectAll.checked = false;
                updateSelectionCount();
            } else {
                window.showCustomAlert('error', 'Migration Failed', data.message);
            }
        })
        .catch(err => {
            console.error(err);
            if(btnConfirmProceed) {
                btnConfirmProceed.textContent = "Confirm";
                btnConfirmProceed.disabled = false;
            }
            if(migConfirmModal) migConfirmModal.classList.remove('show');
            window.showCustomAlert('error', 'Network Error', 'Failed to connect to server.');
        });
    }
});