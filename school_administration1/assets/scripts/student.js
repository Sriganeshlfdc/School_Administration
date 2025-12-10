// school_administration1/assets/scripts/student.js

console.log("STATUS: Student.js loaded.");

// =========================================================================
// 1. GLOBAL HELPERS
// =========================================================================

const classesMap = {
    'pre-primary': ['PP.1', 'PP.2', 'PP.3'],
    'primary': ['P.1', 'P.2', 'P.3', 'P.4', 'P.5', 'P.6', 'P.7'],
    'secondary': ['S.1', 'S.2', 'S.3', 'S.4', 'S.5', 'S.6']
};

/**
 * Populates Class Dropdown.
 * - Edit Mode: Hides "Select Class" placeholder.
 * - Admission/Migration: Shows "Select Class" placeholder.
 */
window.populateClassDropdown = function(levelEl, classEl, includeAll = false) {
    if (!levelEl || !classEl) return;
    
    let selectedLevel = levelEl.value ? levelEl.value.toLowerCase().trim() : '';
    let targetValue = classEl.getAttribute('data-initial-value');
    if (!targetValue) targetValue = classEl.value;

    const isEditForm = classEl.closest('#edit-mode-form') !== null;

    // Set Placeholder based on context
    if (includeAll) {
        classEl.innerHTML = '<option value="">All Classes</option>';
    } else if (isEditForm) {
        // EDIT MODE: No "Select Class" option
        classEl.innerHTML = ''; 
    } else {
        // ADMISSION MODE: "Select Class" option
        classEl.innerHTML = '<option value="">Select Class</option>';
    }
    
    if (classesMap[selectedLevel]) {
        classesMap[selectedLevel].forEach(cls => {
            const opt = document.createElement('option');
            opt.value = cls;
            opt.textContent = cls;
            classEl.appendChild(opt);
        });
    } else if (!includeAll && !isEditForm) {
        classEl.innerHTML = '<option value="">Select Level First</option>';
    }
    
    // Restore previous selection if valid
    if (targetValue) {
        let found = false;
        for (let i = 0; i < classEl.options.length; i++) {
            if (classEl.options[i].value === targetValue) {
                classEl.selectedIndex = i;
                found = true;
                break;
            }
        }
        if (found && classEl.hasAttribute('data-initial-value')) {
            classEl.removeAttribute('data-initial-value');
        }
    }
};

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
            <div class="success-header"><div class="confirm-icon-circle ${variantClass}" style="color: ${colorMap[type]}; font-size: 3rem; margin-bottom: 10px;"><i class="fa ${iconClass}"></i></div></div>
            <h4 class="modal-title" style="margin-bottom:10px;">${title}</h4>
            <p class="modal-message">${message}</p>
            <div class="modal-actions centered"><button class="btn-primary modal-close-btn">OK</button></div>
        </div>`;
    
    const closeBtn = modalContainer.querySelector('.modal-close-btn');
    if(closeBtn) closeBtn.onclick = function() { modalContainer.classList.remove('show'); };
    modalContainer.classList.add('show');
};

// --- NEW HELPER: Generic Confirmation Modal ---
window.showActionConfirm = function(title, message, confirmBtnText, confirmBtnColor, callback) {
    let modal = document.getElementById('action-confirm-modal');
    if (!modal) {
        modal = document.createElement('div');
        modal.id = 'action-confirm-modal';
        modal.className = 'modal-backdrop';
        document.body.appendChild(modal);
    }
    
    // Rebuild modal content
    modal.innerHTML = `
        <div class="modal-content confirm-modal animated-pop">
            <div class="success-header">
                <div class="confirm-icon-circle warning" style="color: orange; font-size: 3rem; margin-bottom: 10px;">
                    <i class="fa fa-question-circle"></i>
                </div>
            </div>
            <h4 class="modal-title">${title}</h4>
            <p class="modal-message">${message}</p>
            <div class="modal-actions centered" style="gap:15px; display:flex; justify-content:center;">
                <button class="btn-primary" id="confirm-modal-cancel" style="background:#ccc; color:#333;">No, Return</button>
                <button class="btn-primary" id="confirm-modal-yes" style="background:${confirmBtnColor};">${confirmBtnText}</button>
            </div>
        </div>`;
    
    const close = () => modal.classList.remove('show');
    
    // Attach Listeners
    modal.querySelector('#confirm-modal-cancel').onclick = close;
    modal.querySelector('#confirm-modal-yes').onclick = function() {
        close();
        if (callback) callback();
    };
    
    // Show Modal
    setTimeout(() => modal.classList.add('show'), 10);
};

// =========================================================================
// 2. CORE LOGIC
// =========================================================================

window.initEditProfileDropdowns = function() {
    const editLevel = document.getElementById('i-level');
    const editClass = document.getElementById('i-class');
    if (editLevel && editClass) {
        const newLevel = editLevel.cloneNode(true);
        editLevel.parentNode.replaceChild(newLevel, editLevel);
        window.populateClassDropdown(newLevel, editClass, false);
        newLevel.addEventListener('change', () => window.populateClassDropdown(newLevel, editClass));
    }
};

window.loadProfileViaAjax = function(studentId) {
    // 1. Save ID so base.js can find it on refresh
    localStorage.setItem('currentStudentId', studentId); 
    
    // 2. Update URL to #profile without refreshing
    if (window.location.hash !== '#profile') {
        history.pushState(null, null, '#profile'); 
    }

    document.querySelectorAll('.module').forEach(m => m.style.display = 'none');
    const pMod = document.getElementById('profile-module');
    if(pMod) {
        pMod.style.display = 'block';
        pMod.innerHTML = '<div style="text-align:center;padding:50px;"><i class="fa fa-spinner fa-spin fa-3x" style="color:var(--primary-color);"></i><br>Loading Profile...</div>';
        
        fetch(`api/students/get_student_profile.php?id=${studentId}`)
        .then(r => r.text())
        .then(html => { 
            pMod.innerHTML = html;
            window.initEditProfileDropdowns(); 
        });
    }
};

window.togglePageEditMode = function(mode) {
    const viewContent = document.getElementById('view-mode-content');
    const editForm = document.getElementById('edit-mode-form');
    const editBtn = document.getElementById('edit-btn'); 
    const saveCancelGroup = document.getElementById('save-cancel-group');
    
    // Select the image container
    const imgContainer = document.querySelector('.profile-image-container'); 

    if (!viewContent || !editForm) return;

    if (mode === 'edit') {
        viewContent.style.display = 'none';
        editForm.style.display = 'block'; 
        if(editBtn) editBtn.style.display = 'none';
        if(saveCancelGroup) saveCancelGroup.style.display = 'flex';
        
        // Enable photo editing visuals
        if(imgContainer) imgContainer.classList.add('editable-mode'); 

    } else {
        viewContent.style.display = 'block'; 
        editForm.style.display = 'none';
        if(editBtn) editBtn.style.display = 'inline-flex';
        if(saveCancelGroup) saveCancelGroup.style.display = 'none';
        
        // Disable photo editing visuals
        if(imgContainer) imgContainer.classList.remove('editable-mode');
    }
};

window.triggerPhotoUpload = function() {
    const fileInput = document.getElementById('edit-photo-input'); 
    if (fileInput) fileInput.click();
};

window.submitEditForm = function() {
    // 1. Validate Form First
    const form = document.getElementById('edit-mode-form');
    if (!form) return;
    if (!form.checkValidity()) {
        form.reportValidity(); // Show browser validation errors if any
        return;
    }

    // 2. Ask for Confirmation
    window.showActionConfirm(
        'Save Changes?', 
        'Are you sure you want to save these changes to the student profile?', 
        'Yes, Save', 
        '#00b374', // Green color
        function() {
            // 3. Proceed with Save
            const formData = new FormData(form);
            formData.append('action', 'update');

            fetch('api/students/edit_student.php', { method: 'POST', body: formData })
            .then(r => r.json())
            .then(data => {
                if (data.success) {
                    window.showCustomAlert('success', 'Update Successful', 'Student details updated.');
                    const tempInput = document.getElementById('temp-photo-filename');
                    if (tempInput) tempInput.value = '';
                    
                    const id = formData.get('StudentID');
                    window.loadProfileViaAjax(id); 
                } else {
                    window.showCustomAlert('error', 'Update Failed', data.message);
                }
            })
            .catch(error => {
                console.error(error);
                window.showCustomAlert('error', 'Network Error', 'Failed to connect.');
            });
        }
    );
};

window.handleAdmission = function(e) {
    e.preventDefault();
    const form = e.target;
    const formData = new FormData(form);
    const btn = form.querySelector('button[type="submit"]');
    if(btn) { btn.disabled = true; btn.textContent = "Processing..."; }

    fetch('api/students/admission.php', { method: 'POST', body: formData })
    .then(r => r.json())
    .then(data => {
        if(data.success) {
            window.showCustomAlert('success', 'Admission Complete', data.message);
            form.reset(); 
        } else {
            window.showCustomAlert('error', 'Admission Failed', data.message);
        }
    })
    .catch(err => { window.showCustomAlert('error', 'Network Error', 'Check console.'); })
    .finally(() => { if(btn) { btn.disabled = false; btn.textContent = "Submit Application"; } });
};

// =========================================================================
// 3. EVENT LISTENERS
// =========================================================================

document.addEventListener('DOMContentLoaded', () => {
    
    // Admission Form Logic
    const admissionForm = document.getElementById('admission-form');
    if (admissionForm) {
        admissionForm.addEventListener('submit', window.handleAdmission);
        
        admissionForm.addEventListener('reset', () => {
            setTimeout(() => {
                const previewImg = document.getElementById('admission-photo-preview');
                const photoWrapper = document.getElementById('admission-photo-wrapper');
                const placeholder = document.getElementById('upload-placeholder');
                
                if (previewImg) {
                    previewImg.src = ''; 
                    previewImg.style.display = 'none'; 
                }
                if (photoWrapper) photoWrapper.classList.remove('has-file');
                if (placeholder) placeholder.style.display = 'flex';
                
                const pInput = document.getElementById('photo');
                if(pInput) pInput.value = '';
            }, 50);
        });
    }
    
    const resetAdmBtn = document.getElementById('admission-reset-btn');
    if(resetAdmBtn) resetAdmBtn.addEventListener('click', () => { if(admissionForm) admissionForm.reset(); });

    const admLevel = document.getElementById('level');
    const admClass = document.getElementById('class');
    if (admLevel && admClass) {
        admLevel.addEventListener('change', () => window.populateClassDropdown(admLevel, admClass));
    }
    
    // Admission Photo Preview
    const photoInput = document.getElementById('photo');
    if (photoInput) {
        photoInput.addEventListener('change', function(e) {
            const file = e.target.files[0];
            const previewImg = document.getElementById('admission-photo-preview');
            const wrapper = document.getElementById('admission-photo-wrapper');
            const placeholder = document.getElementById('upload-placeholder');
            if (file && previewImg) {
                const reader = new FileReader();
                reader.onload = function(evt) {
                    previewImg.src = evt.target.result;
                    previewImg.style.display = 'block'; 
                    if(wrapper) wrapper.classList.add('has-file');
                    if(placeholder) placeholder.style.display = 'none';
                }
                reader.readAsDataURL(file);
            }
        });
    }

    // Filter Logic
    const filterForm = document.getElementById('student-filter-form');
    if (filterForm) filterForm.addEventListener('submit', (e) => { e.preventDefault(); window.loadStudentList(e); });
    
    const filterLevel = document.getElementById('filter-level');
    const filterClass = document.getElementById('filter-class');
    const resetFilterBtn = document.getElementById('reset-filter-btn');
    
    if (filterLevel && filterClass) {
        filterLevel.addEventListener('change', () => window.populateClassDropdown(filterLevel, filterClass, true));
    }
    
    if (resetFilterBtn) {
        resetFilterBtn.addEventListener('click', () => {
            const form = document.getElementById('student-filter-form');
            if(form) form.reset(); 
            if(filterClass) filterClass.innerHTML = '<option value="">All</option>';
            const container = document.getElementById('student-list-results');
            if(container) container.innerHTML = `<div style="text-align:center; padding: 60px 20px; color: #777;"><i class="fa fa-search" style="font-size: 3rem; color: #ddd; margin-bottom: 15px;"></i><p>Use filters to find students.</p></div>`;
        });
    }

    // Edit Profile Photo Upload Logic
    document.addEventListener('change', function(e) {
        if (e.target && e.target.id === 'edit-photo-input') { 
            const file = e.target.files[0];
            if (file) {
                const formData = new FormData();
                
                // Robust ID Lookup
                const form = e.target.closest('#edit-mode-form');
                const studentIdInput = form ? form.querySelector('input[name="StudentID"]') : null;
                const studentId = studentIdInput ? studentIdInput.value : null;

                if (studentId) {
                    formData.append('StudentID', studentId);
                } else {
                    window.showCustomAlert('error', 'Configuration Error', 'Could not locate Student ID in the edit form.');
                    console.error("Debug: Form found?", !!form, "Input found?", !!studentIdInput, "Value:", studentId);
                    return; 
                }

                formData.append('photo', file);

                // Send to upload_temp.php
                fetch('api/students/upload_temp.php', { method: 'POST', body: formData })
                .then(r => r.json())
                .then(data => {
                    if(data.success) {
                        const newSrc = data.previewUrl;
                        const displayPhoto = document.getElementById('display-photo');
                        const formPreview = document.getElementById('form-photo-preview');
                        
                        const timestamp = new Date().getTime();
                        if (displayPhoto) displayPhoto.src = newSrc + '?t=' + timestamp;
                        if (formPreview) formPreview.src = newSrc + '?t=' + timestamp;
                        
                        const tempInput = document.getElementById('temp-photo-filename');
                        if (tempInput) tempInput.value = data.tempFileName;
                        
                        window.togglePageEditMode('edit');
                    } else {
                        window.showCustomAlert('error', 'Upload Failed', data.message);
                    }
                })
                .catch(err => {
                    console.error("Upload error", err);
                    window.showCustomAlert('error', 'Network Error', 'Check console for details.');
                });
            }
        }
    });

    document.addEventListener('click', function(e) {
        if (e.target.closest('.photo-edit-overlay') && !e.target.closest('[onclick]')) {
            window.triggerPhotoUpload();
        }
        
        // --- CANCEL LOGIC WITH CONFIRMATION ---
        if (e.target.closest('#save-cancel-group') && e.target.innerText.includes('Cancel')) {
            e.preventDefault(); 
            
            window.showActionConfirm(
                'Discard Changes?', 
                'Are you sure? Any unsaved changes (including new photos) will be lost.', 
                'Yes, Discard', 
                '#e53935', // Red color
                function() {
                    const tempInput = document.getElementById('temp-photo-filename');
                    const tempFile = tempInput ? tempInput.value : '';
                    
                    const form = document.getElementById('edit-mode-form');
                    const studentIdInput = form ? form.querySelector('input[name="StudentID"]') : null;
                    const studentId = studentIdInput ? studentIdInput.value : null;

                    if (tempFile && studentId) {
                        const formData = new FormData();
                        formData.append('action', 'delete_temp');
                        formData.append('fileName', tempFile);
                        formData.append('StudentID', studentId);

                        fetch('api/students/edit_student.php', { method: 'POST', body: formData });
                        
                        tempInput.value = '';
                        const originalSrc = document.getElementById('original-photo-src').value;
                        const displayPhoto = document.getElementById('display-photo');
                        const formPreview = document.getElementById('form-photo-preview');
                        if (displayPhoto) displayPhoto.src = originalSrc;
                        if (formPreview) formPreview.src = originalSrc;
                        const fileInput = document.getElementById('edit-photo-input');
                        if (fileInput) fileInput.value = '';
                    }
                    window.togglePageEditMode('view');
                }
            );
        }
        
        const deleteBtn = e.target.closest('.js-delete-student');
        if (deleteBtn) { e.preventDefault(); window.showDeleteConfirmModal(deleteBtn.dataset.id, deleteBtn.dataset.name); }
    });

    initMigrationModule();
});

// =========================================================================
// 4. OTHER UTILITIES
// =========================================================================

window.loadStudentList = function(e) {
    if (e) e.preventDefault();
    const container = document.getElementById('student-list-results');
    const form = document.getElementById('student-filter-form');
    if(!container || !form) return;
    const formData = new FormData(form);
    
    let hasFilter = false;
    for (const [key, value] of formData.entries()) { if (key !== 'module' && value.trim() !== "") hasFilter = true; }
    if (!hasFilter) {
        container.innerHTML = '<div style="text-align:center; padding: 60px 20px; color: #777;"><i class="fa fa-search" style="font-size: 3rem; color: #ddd; margin-bottom: 15px;"></i><p>Please select a filter.</p></div>';
        return;
    }
    let params = new URLSearchParams(formData).toString();
    container.innerHTML = '<div style="text-align:center;padding:40px;"><i class="fa fa-spinner fa-spin fa-3x" style="color:var(--primary-color);"></i><p>Searching...</p></div>';
    fetch(`modules/students/partial/viewstudents.php?${params}`).then(r => r.text()).then(html => container.innerHTML = html);
};

window.loadSummary = function(e) {
    if (e) e.preventDefault();
    const container = document.getElementById('summary-results');
    const form = document.getElementById('summary-filter-form');
    if(!container) return;
    let params = form ? new URLSearchParams(new FormData(form)).toString() : "";
    container.innerHTML = '<div style="text-align:center;padding:40px;"><i class="fa fa-spinner fa-spin fa-3x" style="color:var(--primary-color);"></i><p>Calculating...</p></div>';
    fetch(`modules/students/partial/studentsummary.php?${params}`).then(r => r.text()).then(html => {
        container.innerHTML = html;
        window.initSummaryTabs(container);
    });
};

window.initSummaryTabs = function(context) {
    const mainTabs = context.querySelectorAll('.summary-tabs .tab-button');
    if (mainTabs.length) {
        mainTabs.forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                const container = this.closest('.tabbed-details-container');
                if (!container) return;
                const tabGroup = this.closest('.summary-tabs');
                tabGroup.querySelectorAll('.tab-button').forEach(b => b.classList.remove('active'));
                const allContents = container.querySelectorAll('.tab-content');
                allContents.forEach(content => {
                    if (content.parentElement === container) { content.style.display = 'none'; content.classList.remove('active'); }
                });
                this.classList.add('active');
                const targetId = this.dataset.tab;
                const targetContent = document.getElementById(targetId);
                if (targetContent) { targetContent.style.display = 'block'; targetContent.classList.add('active'); }
            });
        });
    }
    const subTabs = context.querySelectorAll('.sub-tab-navigation .sub-tab-button');
    if (subTabs.length) {
        subTabs.forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                const container = this.closest('.tab-content'); 
                const group = this.closest('.sub-tab-navigation');
                if(group) group.querySelectorAll('.sub-tab-button').forEach(b => b.classList.remove('active'));
                if(container) { container.querySelectorAll('.sub-tab-content').forEach(c => { c.style.display = 'none'; c.classList.remove('active'); }); }
                this.classList.add('active');
                const targetId = this.dataset.subTab;
                const targetContent = document.getElementById(targetId);
                if (targetContent) { targetContent.style.display = 'block'; targetContent.classList.add('active'); }
            });
        });
    }
};

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
            <div class="success-header"><div class="confirm-icon-circle error" style="color: #e53935; font-size: 3rem;"><i class="fa fa-trash"></i></div></div>
            <h4 class="modal-title">Delete Student?</h4>
            <p class="modal-message">Delete <strong>${studentName}</strong>? <span style="color:red;">Cannot be undone.</span></p>
            <div class="modal-actions centered" style="gap:15px; display:flex; justify-content:center;">
                <button class="btn-primary" style="background:#ccc; color:#333;" onclick="document.getElementById('custom-alert-modal').classList.remove('show')">Cancel</button>
                <button class="btn-primary" style="background:var(--danger-color);" onclick="executeDelete(${studentId})">Delete</button>
            </div>
        </div>`;
    modal.classList.add('show');
};

window.executeDelete = function(studentId) {
    fetch(`api/students/deletestudent.php?id=${studentId}`).then(r => r.json()).then(data => {
        document.getElementById('custom-alert-modal').classList.remove('show');
        if(data.success) {
            window.showCustomAlert('success', 'Deleted', 'Record deleted.');
            if(window.location.href.includes('studentprofile.php')) window.location.href = 'studentmanagement.php#list';
            else if(typeof window.loadStudentList === 'function') window.loadStudentList();
        } else {
            window.showCustomAlert('error', 'Error', data.message);
        }
    });
};

window.printStudentProfile = function(studentId) {
    const printUrl = `modules/students/print_student.php?id=${studentId}`;
    let existingFrame = document.getElementById('print-frame');
    if (existingFrame) document.body.removeChild(existingFrame);
    const iframe = document.createElement('iframe');
    iframe.id = 'print-frame';
    iframe.style.position = 'fixed'; 
    iframe.style.right = '0'; iframe.style.bottom = '0';
    iframe.style.width = '0'; iframe.style.height = '0'; iframe.style.border = '0';
    iframe.src = printUrl;
    document.body.appendChild(iframe);
    iframe.onload = function() {
        setTimeout(() => { try { iframe.contentWindow.focus(); iframe.contentWindow.print(); } catch(e) { console.error("Print Error:", e); } }, 500);
    };
};

window.toggleStudentHistory = function(studentId) {
    const wrapper = document.getElementById('history-content-wrapper');
    const tbody = document.getElementById('history-table-body');
    const emptyMsg = document.getElementById('history-empty-msg');
    if (wrapper.style.display === 'block') { wrapper.style.display = 'none'; return; }
    wrapper.style.display = 'block';
    tbody.innerHTML = '<tr><td colspan="7" style="text-align:center; padding:20px;"><i class="fa fa-spinner fa-spin"></i> Loading...</td></tr>';
    if(emptyMsg) emptyMsg.style.display = 'none';

    fetch(`api/students/get_student_history.php?id=${studentId}`)
    .then(response => response.json())
    .then(data => {
        tbody.innerHTML = ''; 
        if (data.success && data.data.length > 0) {
            data.data.forEach(row => {
                const tr = document.createElement('tr');
                tr.innerHTML = `<td style="font-weight:600; color:#1e88e5;">${row.DateMoved}</td><td>${row.AcademicYear}</td><td>${row.Term}</td><td>${row.Class}</td><td>${row.Stream ? row.Stream : '-'}</td><td>${row.Residence}</td><td><span class="badge">${row.EntryStatus}</span></td>`;
                tbody.appendChild(tr);
            });
        } else {
            if (data.success) { if(emptyMsg) emptyMsg.style.display = 'block'; }
            else { tbody.innerHTML = `<tr><td colspan="7" style="color:red; text-align:center;">Error: ${data.message}</td></tr>`; }
        }
    })
    .catch(err => {
        console.error(err);
        tbody.innerHTML = '<tr><td colspan="7" style="color:red; text-align:center;">Failed to load history.</td></tr>';
    });
};

function initMigrationModule() {
    const migSourceLevel = document.getElementById('mig-source-level');
    const migSourceClass = document.getElementById('mig-source-class');
    const migTargetLevel = document.getElementById('mig-target-level');
    const migTargetClass = document.getElementById('mig-target-class');

    if (migSourceLevel && migSourceClass) {
        migSourceLevel.addEventListener('change', () => window.populateClassDropdown(migSourceLevel, migSourceClass));
    }
    if (migTargetLevel && migTargetClass) {
        migTargetLevel.addEventListener('change', () => window.populateClassDropdown(migTargetLevel, migTargetClass));
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

    fetch(`api/students/fetch_students_migration.php?level=${encodeURIComponent(level)}&class=${encodeURIComponent(cls)}&stream=${encodeURIComponent(stream)}&year=${encodeURIComponent(year)}`)
    .then(r => r.json())
    .then(data => {
            if (data.success) {
                tableBody.innerHTML = '';
                if(data.data.length === 0) { tableBody.innerHTML = '<tr><td colspan="7" style="text-align:center;">No students found.</td></tr>'; return; }
                data.data.forEach(s => {
                    const photo = s.PhotoPath || 'static/images/default_profile.png';
                    const row = `<tr><td style="text-align:center;"><input type="checkbox" class="mig-checkbox" value="${s.StudentID}"></td><td><img src="${photo}" class="student-photo-thumb" style="width:30px;"></td><td>${s.Name} ${s.Surname}</td><td>${s.Class} ${s.Stream||''}</td><td>${s.AcademicYear}</td><td><button class="btn-action view-btn mig-single-btn" data-id="${s.StudentID}" data-name="${s.Name}">Move</button></td></tr>`;
                    tableBody.insertAdjacentHTML('beforeend', row);
                });
                document.querySelectorAll('.mig-checkbox').forEach(cb => cb.addEventListener('change', updateSelectionCount));
                document.querySelectorAll('.mig-single-btn').forEach(btn => btn.addEventListener('click', function() { initiateMigration([this.dataset.id], this.dataset.name); }));
            } else {
                tableBody.innerHTML = `<tr><td colspan="7" style="color:red;text-align:center;">Error: ${data.message}</td></tr>`;
            }
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
            window.showCustomAlert('success', 'Migration Successful', data.message);
            fetchMigrationStudents();
        } else {
            window.showCustomAlert('error', 'Migration Failed', data.message);
        }
    })
    .catch(err => { window.showCustomAlert('error', 'Error', err.message); })
    .finally(() => { if(btn) { btn.disabled = false; btn.textContent = "Confirm"; } });
}