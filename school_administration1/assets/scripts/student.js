// school_administration1/assets/scripts/student.js

document.addEventListener('DOMContentLoaded', () => {
    console.log("STATUS: Student.js loaded.");

    // =========================================================================
    // 0. FORCE RESET ON LOAD
    // =========================================================================
    const filterFormOnLoad = document.getElementById('student-filter-form');
    if (filterFormOnLoad) {
        filterFormOnLoad.reset();
        filterFormOnLoad.setAttribute("autocomplete", "off"); // Prevent browser autofill
    }

    // =========================================================================
    // 1. DEFINE HELPER FUNCTIONS
    // =========================================================================

    const classesMap = {
        'pre-primary': ['PP.1', 'PP.2', 'PP.3'],
        'primary': ['P.1', 'P.2', 'P.3', 'P.4', 'P.5', 'P.6', 'P.7'],
        'secondary': ['S.1', 'S.2', 'S.3', 'S.4', 'S.5', 'S.6']
    };

    function populateClassDropdown(levelEl, classEl, includeAll = false) {
        if (!levelEl || !classEl) return;
        let selected = levelEl.value ? levelEl.value.toLowerCase().trim() : '';
        classEl.innerHTML = includeAll ? '<option value="">All Classes</option>' : '<option value="">Select Class</option>';
        
        if (classesMap[selected]) {
            classesMap[selected].forEach(cls => {
                const opt = document.createElement('option');
                opt.value = cls;
                opt.textContent = cls;
                classEl.appendChild(opt);
            });
        }
    }

    window.showCustomAlert = function(type, title, message) {
        let modalContainer = document.getElementById('custom-alert-modal');
        if (!modalContainer) {
            modalContainer = document.createElement('div');
            modalContainer.id = 'custom-alert-modal';
            modalContainer.className = 'modal-backdrop';
            document.body.appendChild(modalContainer);
        }

        const colorMap = { success: '#00b374', error: '#e53935', warning: 'orange', info: '#1e88e5' };
        let variantClass = type === 'error' ? 'error' : (type === 'warning' ? 'warning' : 'success');
        let iconClass = type === 'error' ? 'fa-times-circle' : (type === 'warning' ? 'fa-exclamation-triangle' : 'fa-check-circle');

        modalContainer.innerHTML = `
            <div class="modal-content confirm-modal animated-pop">
                <div class="success-header">
                    <div class="confirm-icon-circle ${variantClass}" style="color: ${colorMap[type]}; font-size: 3rem; margin-bottom: 10px;">
                        <i class="fa ${iconClass}"></i>
                    </div>
                </div>
                <h4 class="modal-title" style="margin-bottom:10px;">${title}</h4>
                <p class="modal-message">${message}</p>
                <div class="modal-actions centered">
                    <button class="btn-primary modal-close-btn">OK</button>
                </div>
            </div>
        `;
        
        const closeBtn = modalContainer.querySelector('.modal-close-btn');
        if(closeBtn) {
            closeBtn.onclick = function() {
                modalContainer.classList.remove('show');
            };
        }
        modalContainer.classList.add('show');
    };

    // =========================================================================
    // 2. ADMISSION SUBMISSION HANDLER
    // =========================================================================
    window.handleAdmission = function(e) {
        e.preventDefault();
        
        const form = e.target;
        const formData = new FormData(form);
        const btn = form.querySelector('button[type="submit"]');
        
        if(btn) {
            btn.disabled = true;
            btn.textContent = "Processing...";
        }

        fetch('api/students/admission.php', {
            method: 'POST',
            body: formData
        })
        .then(r => r.json())
        .then(data => {
            if(data.success) {
                window.showCustomAlert('success', 'Admission Complete', data.message);
                form.reset(); 
            } else {
                window.showCustomAlert('error', 'Admission Failed', data.message);
            }
        })
        .catch(err => {
            console.error(err);
            window.showCustomAlert('error', 'Network Error', 'Check console for details.');
        })
        .finally(() => {
            if(btn) {
                btn.disabled = false;
                btn.textContent = "Submit Application";
            }
        });
    };

    // =========================================================================
    // 3. PHOTO UPLOAD LOGIC
    // =========================================================================
    const photoInput = document.getElementById('photo');
    const photoWrapper = document.getElementById('admission-photo-wrapper');
    const previewImg = document.getElementById('admission-photo-preview');
    const placeholder = document.getElementById('upload-placeholder');
    const admissionForm = document.getElementById('admission-form');

    function resetPhotoUI() {
        if (photoWrapper) photoWrapper.classList.remove('has-file');
        if (previewImg) {
            previewImg.src = '';
            previewImg.style.display = 'none';
        }
        if (placeholder) {
            placeholder.style.display = ''; 
        }
    }

    if (photoInput && photoWrapper && previewImg) {
        photoInput.addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(evt) {
                    previewImg.src = evt.target.result;
                    previewImg.style.display = 'block'; 
                    photoWrapper.classList.add('has-file');
                    if(placeholder) placeholder.style.display = 'none';
                }
                reader.readAsDataURL(file);
            } else {
                resetPhotoUI();
            }
        });
    }

    if (admissionForm) {
        admissionForm.addEventListener('reset', function() {
            setTimeout(resetPhotoUI, 10);
        });
    }

    // =========================================================================
    // 4. LIST & SEARCH LOGIC (FIXED)
    // =========================================================================

    window.loadStudentList = function(e) {
        if (e) e.preventDefault();
        
        const container = document.getElementById('student-list-results');
        const form = document.getElementById('student-filter-form');
        
        if(!container || !form) return;

        // --- STRICT FILTER CHECK ---
        const formData = new FormData(form);
        let hasFilter = false;
        
        // Loop through entries to check for REAL values
        for (const [key, value] of formData.entries()) {
            // FIX: Ignore the hidden 'module' field which always has value 'list'
            if (key === 'module') continue; 
            
            if (value && value.trim() !== "") {
                hasFilter = true;
                break;
            }
        }

        // If no filter is selected, STOP everything.
        if (!hasFilter) {
            // Clear any previous results
            container.innerHTML = `
                <div style="text-align:center; padding: 60px 20px; color: #777;">
                    <i class="fa fa-search" style="font-size: 3rem; color: #ddd; margin-bottom: 15px;"></i>
                    <p style="font-size: 1.1rem;">Please select a <strong>Level</strong>, <strong>Class</strong>, or enter a <strong>Name/ID</strong> to view students.</p>
                </div>`;
            
            // Only show alert if the user explicitly clicked the Search button
            if (e) {
                window.showCustomAlert('warning', 'Selection Required', 'Please select at least one filter option before searching.');
            }
            return; 
        }

        // If validation passes, proceed
        let params = new URLSearchParams(formData).toString();
        
        container.innerHTML = '<div style="text-align:center;padding:40px;"><i class="fa fa-spinner fa-spin fa-3x" style="color:var(--primary-color);"></i><p>Searching...</p></div>';

        fetch(`modules/students/partial/viewstudents.php?${params}`)
        .then(r => r.text())
        .then(html => { container.innerHTML = html; })
        .catch(err => {
            container.innerHTML = '<p class="error">Failed to connect to server.</p>';
        });
    };

    window.loadSummary = function(e) {
        if (e) e.preventDefault();
        const container = document.getElementById('summary-results');
        const form = document.getElementById('summary-filter-form');
        if(!container) return;

        let params = "";
        if(form) params = new URLSearchParams(new FormData(form)).toString();

        container.innerHTML = '<div style="text-align:center;padding:40px;"><i class="fa fa-spinner fa-spin fa-3x" style="color:var(--primary-color);"></i><p>Calculating...</p></div>';

        fetch(`modules/students/partial/studentsummary.php?${params}`)
        .then(r => r.text())
        .then(html => {
            container.innerHTML = html;
            initSummaryTabs(container);
        })
        .catch(err => container.innerHTML = '<p class="error">Failed to load summary.</p>');
    };

    function initSummaryTabs(context) {
        const tabs = context.querySelectorAll('.tab-button');
        if (!tabs.length) return;
        tabs.forEach(btn => {
            btn.addEventListener('click', function() {
                const group = this.closest('.summary-tabs') || this.closest('.sub-tab-navigation');
                const parentContainer = this.closest('.summary-container') || this.closest('.tab-content');
                if(group) group.querySelectorAll('.tab-button, .sub-tab-button').forEach(t => t.classList.remove('active'));
                if(parentContainer) {
                    parentContainer.querySelectorAll('.tab-content, .sub-tab-content').forEach(c => {
                        if(c.parentElement === parentContainer || c.parentElement.parentElement === parentContainer) {
                            c.style.display = 'none';
                            c.classList.remove('active');
                        }
                    });
                }
                this.classList.add('active');
                const targetId = this.dataset.tab || this.dataset.subTab;
                const targetContent = document.getElementById(targetId);
                if(targetContent) {
                    targetContent.style.display = 'block';
                    targetContent.classList.add('active');
                    const subNav = targetContent.querySelector('.sub-tab-navigation');
                    if(subNav && !targetContent.querySelector('.sub-tab-content.active')) {
                        const firstSub = subNav.querySelector('.sub-tab-button');
                        if(firstSub) firstSub.click();
                    }
                }
            });
        });
    }

    // --- Profile & Edit ---
    window.loadProfileViaAjax = function(studentId) {
        localStorage.setItem('currentStudentId', studentId); 
        document.querySelectorAll('.module').forEach(m => m.style.display = 'none');
        const pMod = document.getElementById('profile-module');
        if(pMod) {
            pMod.style.display = 'block';
            pMod.innerHTML = '<div style="text-align:center;padding:50px;"><i class="fa fa-spinner fa-spin fa-3x" style="color:var(--primary-color);"></i><br>Loading Profile...</div>';
            if(history.pushState) history.pushState(null, null, '#profile');

            fetch(`api/students/get_student_profile.php?id=${studentId}`)
            .then(r => r.text())
            .then(html => { pMod.innerHTML = html; })
            .catch(err => { pMod.innerHTML = '<div class="error-message">Failed to load profile.</div>'; });
        }
    };

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

        fetch('api/students/edit_student.php', { method: 'POST', body: formData })
        .then(r => r.json())
        .then(data => {
            if (data.success) {
                window.showCustomAlert('success', 'Update Successful', 'Student details updated.');
                const id = formData.get('StudentID');
                loadProfileViaAjax(id); 
            } else {
                window.showCustomAlert('error', 'Update Failed', data.message || 'Unknown error.');
            }
        })
        .catch(error => {
            console.error(error);
            window.showCustomAlert('error', 'Network Error', 'Failed to connect.');
        });
    };

    // --- Delete ---
    window.showDeleteConfirmModal = function(studentId, studentName) {
        let modal = document.getElementById('custom-alert-modal');
        if(!modal) {
            modal = document.createElement('div');
            modal.id = 'custom-alert-modal';
            modal.className = 'modal-backdrop';
            document.body.appendChild(modal);
        }
        modal.innerHTML = `
            <div class="modal-content confirm-modal animated-pop">
                <div class="success-header">
                    <div class="confirm-icon-circle error" style="color: #e53935; font-size: 3rem;"><i class="fa fa-trash"></i></div>
                </div>
                <h4 class="modal-title">Delete Student?</h4>
                <p class="modal-message">Delete <strong>${studentName}</strong>? <span style="color:red;">Cannot be undone.</span></p>
                <div class="modal-actions centered" style="display: flex; justify-content: center; gap: 15px;">
                    <button class="btn-primary" style="background:#ccc; color:#333;" onclick="document.getElementById('custom-alert-modal').classList.remove('show')">Cancel</button>
                    <button class="btn-primary" style="background:var(--danger-color);" onclick="executeDelete(${studentId})">Delete</button>
                </div>
            </div>
        `;
        modal.classList.add('show');
    };

    window.executeDelete = function(studentId) {
        fetch(`api/students/deletestudent.php?id=${studentId}`)
        .then(r => r.json())
        .then(data => {
            document.getElementById('custom-alert-modal').classList.remove('show');
            if(data.success) {
                window.showCustomAlert('success', 'Deleted', 'Record deleted.');
                if(typeof window.loadStudentList === 'function') window.loadStudentList();
                else window.location.hash = 'list';
            } else {
                window.showCustomAlert('error', 'Error', data.message);
            }
        })
        .catch(err => {
            window.showCustomAlert('error', 'Network Error', err.message);
        });
    };

    // --- Print ---
    window.printStudentProfile = function(studentId) {
        const printUrl = `modules/students/print_student.php?id=${studentId}`;
        let existingFrame = document.getElementById('print-frame');
        if (existingFrame) document.body.removeChild(existingFrame);

        const iframe = document.createElement('iframe');
        iframe.id = 'print-frame';
        iframe.style.position = 'fixed'; 
        iframe.style.right = '0';
        iframe.style.bottom = '0';
        iframe.style.width = '0';
        iframe.style.height = '0';
        iframe.style.border = '0';
        iframe.src = printUrl;
        document.body.appendChild(iframe);

        iframe.onload = function() {
            setTimeout(() => {
                try {
                    iframe.contentWindow.focus();
                    iframe.contentWindow.print();
                } catch(e) { console.error("Print Error:", e); }
            }, 500);
        };
    };

    // --- Migration Module Logic ---
    function initMigrationModule() {
        const migSourceLevel = document.getElementById('mig-source-level');
        const migSourceClass = document.getElementById('mig-source-class');
        const migTargetLevel = document.getElementById('mig-target-level');
        const migTargetClass = document.getElementById('mig-target-class');
        
        if (migSourceLevel && migSourceClass) {
            migSourceLevel.addEventListener('change', () => populateClassDropdown(migSourceLevel, migSourceClass));
        }
        if (migTargetLevel && migTargetClass) {
            migTargetLevel.addEventListener('change', () => populateClassDropdown(migTargetLevel, migTargetClass));
        }

        const btnFetch = document.getElementById('btn-fetch-students');
        if (btnFetch) btnFetch.addEventListener('click', fetchMigrationStudents);

        const selectAll = document.getElementById('mig-select-all');
        if (selectAll) {
            selectAll.addEventListener('change', function() {
                document.querySelectorAll('.mig-checkbox').forEach(cb => cb.checked = this.checked);
                updateSelectionCount();
            });
        }

        const btnSelected = document.getElementById('btn-migrate-selected');
        if (btnSelected) {
            btnSelected.addEventListener('click', () => {
                const selected = Array.from(document.querySelectorAll('.mig-checkbox:checked')).map(cb => cb.value);
                if (selected.length === 0) return window.showCustomAlert('warning', 'No Selection', 'Please select at least one student.');
                initiateMigration(selected, `${selected.length} Selected Students`);
            });
        }

        const btnClass = document.getElementById('btn-migrate-class');
        if (btnClass) {
            btnClass.addEventListener('click', () => {
                const allCheckboxes = document.querySelectorAll('.mig-checkbox');
                if (allCheckboxes.length === 0) return window.showCustomAlert('warning', 'No Data', 'Fetch students first.');
                const allIds = Array.from(allCheckboxes).map(cb => cb.value);
                initiateMigration(allIds, 'Entire Class');
            });
        }

        const btnConfirm = document.getElementById('mig-confirm-proceed-btn');
        if(btnConfirm) btnConfirm.addEventListener('click', executeMigration);
        
        ['mig-confirm-cancel-btn', 'mig-success-close-btn'].forEach(id => {
            const btn = document.getElementById(id);
            if(btn) btn.addEventListener('click', () => {
                document.querySelectorAll('.modal-backdrop').forEach(m => m.classList.remove('show'));
            });
        });
        
        if (window.location.hash === '#profile') {
            const savedId = localStorage.getItem('currentStudentId');
            if (savedId) setTimeout(() => window.loadProfileViaAjax(savedId), 50);
            else { if (typeof handleNavigate === 'function') handleNavigate('list'); }
        }
    }

    function fetchMigrationStudents() {
        const level = document.getElementById('mig-source-level').value;
        const cls = document.getElementById('mig-source-class').value;
        const stream = document.getElementById('mig-source-stream').value;
        const year = document.getElementById('mig-source-year').value;
        const tableBody = document.querySelector('#migration-table tbody');
        const resultsArea = document.getElementById('migration-results-area');

        if (!level || !cls) return window.showCustomAlert('warning', 'Missing Selection', 'Select Source Level and Class.');

        resultsArea.style.display = 'block';
        tableBody.innerHTML = '<tr><td colspan="7" style="text-align:center;"><i class="fa fa-spinner fa-spin"></i> Loading...</td></tr>';

        const url = `api/students/fetch_students_migration.php?level=${encodeURIComponent(level)}&class=${encodeURIComponent(cls)}&stream=${encodeURIComponent(stream)}&year=${encodeURIComponent(year)}`;

        fetch(url)
        .then(r => r.json())
        .then(data => {
            if (data.success) {
                tableBody.innerHTML = '';
                if (data.data.length === 0) {
                    tableBody.innerHTML = '<tr><td colspan="7" style="text-align:center;">No students found matching criteria.</td></tr>';
                } else {
                    data.data.forEach(s => {
                        const photo = s.PhotoPath || 'static/images/default_profile.png';
                        const row = `
                            <tr>
                                <td style="text-align:center;"><input type="checkbox" class="mig-checkbox" value="${s.StudentID}"></td>
                                <td><img src="${photo}" class="student-photo-thumb" style="width:30px;height:30px;"></td>
                                <td>${s.Name} ${s.Surname}</td>
                                <td>${s.Class} ${s.Stream||''}</td>
                                <td>${s.AcademicYear}</td>
                                <td><button class="btn-action view-btn mig-single-btn" data-id="${s.StudentID}" data-name="${s.Name}">Move</button></td>
                            </tr>
                        `;
                        tableBody.insertAdjacentHTML('beforeend', row);
                    });
                    document.querySelectorAll('.mig-checkbox').forEach(cb => cb.addEventListener('change', updateSelectionCount));
                    document.querySelectorAll('.mig-single-btn').forEach(btn => btn.addEventListener('click', function() {
                        initiateMigration([this.dataset.id], this.dataset.name);
                    }));
                }
                updateSelectionCount();
            } else {
                tableBody.innerHTML = `<tr><td colspan="7" style="color:red;text-align:center;">Error: ${data.message}</td></tr>`;
            }
        })
        .catch(err => {
            tableBody.innerHTML = '<tr><td colspan="7" style="color:red;text-align:center;">Network Error</td></tr>';
        });
    }

    function updateSelectionCount() {
        const count = document.querySelectorAll('.mig-checkbox:checked').length;
        const disp = document.getElementById('selection-count');
        if(disp) disp.textContent = count;
    }

    let pendingMigrationPayload = null;

    function initiateMigration(ids, label) {
        const tYear = document.getElementById('mig-target-year').value;
        const tLevel = document.getElementById('mig-target-level').value;
        const tClass = document.getElementById('mig-target-class').value;
        const tTerm = document.getElementById('mig-target-term').value;
        const tStream = document.getElementById('mig-target-stream').value;

        if(!tYear || !tLevel || !tClass) return window.showCustomAlert('warning', 'Destination?', 'Please select Target Year, Level and Class.');

        pendingMigrationPayload = {
            student_ids: ids, target_year: tYear, target_term: tTerm,
            target_level: tLevel, target_class: tClass, target_stream: tStream
        };

        const modal = document.getElementById('migration-confirm-modal');
        document.getElementById('mig-confirm-message').innerHTML = `Move Student <strong> ${label} (Stu id : ${ids})</strong> to <strong>${tClass} ${tStream||''} (${tTerm}, ${tYear})</strong>?`;
        document.getElementById('mig-confirm-dest').textContent = `${tLevel} - ${tClass}`;
        modal.classList.add('show');
    }

    function executeMigration() {
        const btn = document.getElementById('mig-confirm-proceed-btn');
        if(btn) { btn.disabled = true; btn.textContent = "Processing..."; }

        fetch('api/students/migrate_backend.php', {
            method: 'POST', headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(pendingMigrationPayload)
        })
        .then(r => r.json())
        .then(data => {
            const confirmModal = document.getElementById('migration-confirm-modal');
            if(confirmModal) confirmModal.classList.remove('show');

            if(data.success) {
                document.getElementById('mig-success-count').textContent = pendingMigrationPayload.student_ids.length;
                document.getElementById('mig-success-target').textContent = `${pendingMigrationPayload.target_class} ${pendingMigrationPayload.target_stream}`;
                document.getElementById('mig-success-period').textContent = `${pendingMigrationPayload.target_term}, ${pendingMigrationPayload.target_year}`;
                document.getElementById('migration-success-modal').classList.add('show');
                fetchMigrationStudents();
                const selAll = document.getElementById('mig-select-all');
                if(selAll) selAll.checked = false;
                updateSelectionCount();
            } else {
                window.showCustomAlert('error', 'Migration Failed', data.message);
            }
        })
        .catch(err => {
            const confirmModal = document.getElementById('migration-confirm-modal');
            if(confirmModal) confirmModal.classList.remove('show');
            window.showCustomAlert('error', 'Error', err.message);
        })
        .finally(() => {
            if(btn) { btn.disabled = false; btn.textContent = "Confirm"; }
        });
    }

    // =========================================================================
    // 5. EVENT BINDING
    // =========================================================================

    // Bind Admission Form
    if (admissionForm) {
        admissionForm.addEventListener('submit', window.handleAdmission);
    }
    
    // Bind Reset Button
    const resetBtn = document.getElementById('admission-reset-btn');
    if(resetBtn) {
        resetBtn.addEventListener('click', () => {
            if(admissionForm) admissionForm.reset();
        });
    }

    // Handle Search Form Submission (Prevent Page Reload)
    const filterForm = document.getElementById('student-filter-form');
    if (filterForm) {
        filterForm.addEventListener('submit', function(e) {
            e.preventDefault(); 
            window.loadStudentList(e); // Pass event 'e' to enable the alert
        });
    }

    // Handle Delete Button Click in List (Event Delegation)
    document.addEventListener('click', function(e) {
        const deleteBtn = e.target.closest('.js-delete-student');
        if (deleteBtn) {
            e.preventDefault();
            const studentId = deleteBtn.dataset.id;
            const studentName = deleteBtn.dataset.name;
            window.showDeleteConfirmModal(studentId, studentName);
        }
    });

    // Dropdowns
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
    }
    
    // Reset Handler logic
    if (resetFilterBtn) {
        resetFilterBtn.addEventListener('click', () => {
            const form = document.getElementById('student-filter-form');
            if(form) form.reset(); 
            
            // Manually reset dependent dropdowns
            const filterClass = document.getElementById('filter-class');
            if(filterClass) filterClass.innerHTML = '<option value="">All</option>';

            // Clear the results area and show instructions
            const container = document.getElementById('student-list-results');
            if(container) {
                container.innerHTML = `
                <div style="text-align:center; padding: 60px 20px; color: #777;">
                    <i class="fa fa-search" style="font-size: 3rem; color: #ddd; margin-bottom: 15px;"></i>
                    <p style="font-size: 1.1rem;">Please select a <strong>Level</strong>, <strong>Class</strong>, or enter a <strong>Name/ID</strong> to view students.</p>
                </div>`;
            }
        });
    }

    // Edit Profile Photo Trigger
    document.addEventListener('change', function(e) {
        if (e.target && e.target.id === 'edit-photo') {
            if (e.target.files && e.target.files[0]) {
                const reader = new FileReader();
                reader.onload = function(evt) {
                    const displayPhoto = document.getElementById('display-photo');
                    if (displayPhoto) displayPhoto.src = evt.target.result;
                    window.togglePageEditMode('edit');
                }
                reader.readAsDataURL(e.target.files[0]);
            }
        }
    });

    initMigrationModule();

    // =========================================================================
    // 6. PHOTO EDIT FIXES
    // =========================================================================

    window.triggerPhotoUpload = function() {
        const fileInput = document.getElementById('edit-photo');
        if (fileInput) {
            fileInput.click();
        } else {
            console.error("Error: File input #edit-photo not found.");
        }
    };

    document.addEventListener('click', function(e) {
        if (e.target.closest('.photo-edit-overlay')) {
            if (!e.target.closest('[onclick]')) {
                window.triggerPhotoUpload();
            }
        }
    });

    document.addEventListener('change', function(e) {
        if (e.target && e.target.id === 'edit-photo') {
            if (e.target.files && e.target.files[0]) {
                const reader = new FileReader();
                reader.onload = function(evt) {
                    const displayPhoto = document.getElementById('display-photo');
                    if (displayPhoto) displayPhoto.src = evt.target.result;
                    
                    if (typeof window.togglePageEditMode === 'function') {
                        window.togglePageEditMode('edit');
                    }
                }
                reader.readAsDataURL(e.target.files[0]);
            }
        }
    });
});