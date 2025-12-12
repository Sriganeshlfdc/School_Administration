// school_administration1/assets/scripts/student.js
console.log("STATUS: Student.js loaded.");

// =========================================================================
// 1. GLOBAL HELPERS & CONFIGURATION
// =========================================================================

const classesMap = {
    'pre-primary': ['PP.1', 'PP.2', 'PP.3'],
    'primary': ['P.1', 'P.2', 'P.3', 'P.4', 'P.5', 'P.6', 'P.7'],
    'secondary': ['S.1', 'S.2', 'S.3', 'S.4', 'S.5', 'S.6']
};

/**
 * Populates Class Dropdown based on Level selection.
 */
window.populateClassDropdown = function(levelEl, classEl, includeAll = false) {
    if (!levelEl || !classEl) return;
    
    let selectedLevel = levelEl.value ? levelEl.value.toLowerCase().trim() : '';
    let targetValue = classEl.getAttribute('data-initial-value');
    if (!targetValue) targetValue = classEl.value;

    const isEditForm = classEl.closest('#edit-mode-form') !== null;

    // 1. Reset Dropdown
    classEl.innerHTML = '';

    // 2. Add Placeholder/All Option
    if (includeAll) {
        const allOpt = document.createElement('option');
        allOpt.value = "";
        allOpt.textContent = "All Classes";
        classEl.appendChild(allOpt);
    } else if (!isEditForm) {
        const selOpt = document.createElement('option');
        selOpt.value = "";
        selOpt.textContent = "Select Class";
        classEl.appendChild(selOpt);
    }
    
    // 3. Populate Options
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
    
    // 4. Restore Selection
    if (targetValue) {
        for (let i = 0; i < classEl.options.length; i++) {
            if (classEl.options[i].value === targetValue) {
                classEl.selectedIndex = i;
                if (classEl.hasAttribute('data-initial-value')) {
                    classEl.removeAttribute('data-initial-value');
                }
                break;
            }
        }
    }
};

// --- POPUP SYSTEM WITH ANIMATIONS ---

window.showCustomAlert = function(type, title, message) {
    let modalContainer = document.getElementById('custom-alert-modal');
    if (!modalContainer) {
        modalContainer = document.createElement('div');
        modalContainer.id = 'custom-alert-modal';
        modalContainer.className = 'modal-backdrop';
        document.body.appendChild(modalContainer);
    }
    
    // UPDATED: Use CSS Variables instead of Hex codes
    const colorMap = { 
        success: 'var(--success-color)', 
        error: 'var(--danger-color)', 
        warning: 'var(--warning-color)', 
        info: 'var(--info-color)' 
    };
    
    let variantClass = type === 'error' ? 'error' : (type === 'warning' ? 'warning' : 'success');
    let iconClass = type === 'error' ? 'fa-times-circle' : (type === 'warning' ? 'fa-exclamation-triangle' : 'fa-check-circle');

    modalContainer.innerHTML = `
        <div class="modal-content confirm-modal animated-pop">
            <div class="success-header">
                <div class="confirm-icon-circle ${variantClass}" style="color: ${colorMap[type]}; font-size: 3rem; margin-bottom: 10px; animation: popIn 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);">
                    <i class="fa ${iconClass}"></i>
                </div>
            </div>
            <h4 class="modal-title" style="margin-bottom:10px;">${title}</h4>
            <div class="modal-message" style="color:var(--text-color); margin-bottom:20px;">${message}</div>
            <div class="modal-actions centered"><button class="btn-primary modal-close-btn">OK</button></div>
        </div>`;
    
    const closeBtn = modalContainer.querySelector('.modal-close-btn');
    if(closeBtn) closeBtn.onclick = function() { modalContainer.classList.remove('show'); };
    
    setTimeout(() => modalContainer.classList.add('show'), 10);
};

window.showActionConfirm = function(title, message, confirmBtnText, confirmBtnColor, callback) {
    let modal = document.getElementById('action-confirm-modal');
    if (!modal) {
        modal = document.createElement('div');
        modal.id = 'action-confirm-modal';
        modal.className = 'modal-backdrop';
        document.body.appendChild(modal);
    }
    
    // UPDATED: Added style="color: var(--warning-color)" to the icon
    modal.innerHTML = `
        <div class="modal-content confirm-modal animated-pop">
            <div class="success-header">
                <div class="confirm-icon-circle warning" style="color: var(--warning-color); font-size: 3rem; margin-bottom: 10px; animation: popIn 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);">
                    <i class="fa fa-question-circle"></i>
                </div>
            </div>
            <h4 class="modal-title">${title}</h4>
            <div class="modal-message" style="color:var(--text-color); margin-bottom:20px;">${message}</div>
            <div class="modal-actions centered" style="gap:15px; display:flex; justify-content:center;">
                <button class="btn-primary" id="confirm-modal-cancel" style="background:var(--secondary-color); color:var(--text-color-inverse);">No, Return</button>
                <button class="btn-primary" id="confirm-modal-yes" style="background:${confirmBtnColor};">${confirmBtnText}</button>
            </div>
        </div>`;
    
    const close = () => modal.classList.remove('show');
    modal.querySelector('#confirm-modal-cancel').onclick = close;
    modal.querySelector('#confirm-modal-yes').onclick = function() {
        close();
        if (callback) callback();
    };
    setTimeout(() => modal.classList.add('show'), 10);
};

// --- MASTER POPUP CONTROLLER ---
window.confirmAction = function(actionType, id, extraData = null) {
    // UPDATED: All colors now use CSS Variables
    const actions = {
        'quick_save': {
            title: 'Update Student?',
            message: 'Are you sure you want to save these personal details?',
            btnText: 'Yes, Update',
            color: 'var(--success-color)',
            callback: () => saveQuickRow(id)
        },
        'quick_cancel': {
            title: 'Discard Changes?',
            message: 'Unsaved changes will be lost. Discard anyway?',
            btnText: 'Yes, Discard',
            color: 'var(--danger-color)',
            callback: () => cancelQuickRow(id)
        },
        'academic_save': {
            title: 'Save Academic Records?',
            message: 'Are you sure you want to update these exam results?',
            btnText: 'Yes, Save',
            color: 'var(--success-color)',
            callback: () => saveAcademicRow(id)
        },
        'academic_cancel': {
            title: 'Cancel Editing?',
            message: 'Are you sure? Any changes made will be lost.',
            btnText: 'Yes, Return',
            color: 'var(--danger-color)',
            callback: () => cancelAcademicRow(id)
        },
        'profile_save': {
            title: 'Save Profile Changes?',
            message: 'Are you sure you want to update the student profile details?',
            btnText: 'Yes, Save',
            color: 'var(--success-color)',
            callback: () => executeProfileUpdate()
        },
        'profile_cancel': {
            title: 'Stop Editing?',
            // The message explains what happens if they click Yes
            message: 'Any unsaved changes will be lost. Do you want to return to the profile view?', 
            
            // This is the button that executes the callback (The "Yes" action)
            btnText: 'Yes, Return to Profile', 
            
            color: 'var(--danger-color)',
            
            // This function handles switching back to the Profile View
            callback: () => executeProfileCancel() 
        },
        'delete_student': {
            title: 'Delete Student?',
            message: `Are you sure you want to delete <strong>${extraData || 'this student'}</strong>? <br><span style="color:var(--danger-color); font-size:0.9em;">This action cannot be undone.</span>`,
            btnText: 'Yes, Delete',
            color: 'var(--danger-color)',
            callback: () => executeDelete(id)
        },
        'migration': {
            title: 'Confirm Migration',
            message: `
                <p>Move <strong>${extraData ? extraData.label : ''}</strong>?</p>
                <div class="migration-summary modal-details" style="margin-top:10px; padding:10px; background:var(--modal-summary-bg); border-radius:5px;">
                     <div class="summary-item" style="display:flex; justify-content:space-between;">
                        <span class="label">Destination:</span>
                        <span class="value highlight" style="font-weight:bold; color:var(--primary-color);">${extraData ? extraData.targetDetails : ''}</span>
                    </div>
                </div>`,
            btnText: 'Yes, Proceed',
            color: 'var(--info-color)',
            callback: () => executeMigration(extraData ? extraData.payload : null)
        }
    };

    const config = actions[actionType];

    if (config) {
        window.showActionConfirm(config.title, config.message, config.btnText, config.color, config.callback);
    } else {
        console.error('Action type not defined:', actionType);
    }
};

// ** COMPATIBILITY FIX: Restore this for the HTML onclick="showDeleteConfirmModal" **
window.showDeleteConfirmModal = function(id, name) {
    window.confirmAction('delete_student', id, name);
};

// =========================================================================
// 2. CORE VIEW FUNCTIONS & AUTO-FIX EVENT LISTENERS
// =========================================================================

document.addEventListener('DOMContentLoaded', () => {
    
    // --- CRITICAL AUTO-FIX: DISABLE INLINE CLICKS ---
    
    // 1. Fix Cancel Button (Find button with 'Cancel' text or inside the group)
    const cancelBtns = document.querySelectorAll('#save-cancel-group button');
    cancelBtns.forEach(btn => {
        if (btn.textContent.includes('Cancel') || btn.innerHTML.includes('fa-times-circle')) {
            // Remove the inline onclick that causes the instant return
            btn.removeAttribute('onclick'); 
            // Add identifying class if missing
            btn.classList.add('js-cancel-edit'); 
            // Clone to strip all old listeners, then replace
            const newBtn = btn.cloneNode(true);
            btn.parentNode.replaceChild(newBtn, btn);
        }
    });

    // 2. Fix Delete Button (Find button with 'Delete' text)
    const deleteBtns = document.querySelectorAll('.top-action-bar button');
    deleteBtns.forEach(btn => {
        if (btn.textContent.includes('Delete') || btn.innerHTML.includes('fa-trash')) {
            btn.removeAttribute('onclick');
            btn.classList.add('js-delete-student');
            const newBtn = btn.cloneNode(true);
            btn.parentNode.replaceChild(newBtn, btn);
        }
    });

    // --- RE-ATTACH UNIFIED LISTENERS ---
        document.addEventListener('click', function(e) {
        const cancelBtn = e.target.closest('.js-cancel-edit');
        if (cancelBtn) {
        e.preventDefault();
        // Triggers the popup defined in Step 1
        window.confirmAction('profile_cancel'); 
        return;
        }

        // 2. DELETE Button
        const deleteBtn = e.target.closest('.js-delete-student');
        if (deleteBtn) { 
            e.preventDefault(); 
            // Handles both data-id and data-ad_no for compatibility
            const id = deleteBtn.dataset.id || deleteBtn.dataset.ad_no; 
            window.confirmAction('delete_student', id, deleteBtn.dataset.name);
            return;
        }

        // 3. SAVE Button
        const saveBtn = e.target.closest('.js-save-profile');
        if (saveBtn) {
            e.preventDefault();
            window.confirmAction('profile_save');
            return;
        }

        // 4. EDIT Button
        const editBtn = e.target.closest('.js-edit-btn') || (e.target.id === 'edit-btn');
        if (editBtn) {
            e.preventDefault();
            window.togglePageEditMode('edit');
            return;
        }

        // Photo Overlay
        if (e.target.closest('.photo-edit-overlay') && !e.target.closest('[onclick]')) {
            window.triggerPhotoUpload();
        }
    });

    // Modules Init
    initQuickEditModule();
    initAcademicEditModule();
    initMigrationModule();
    
    // Photo Preview Logic
    document.addEventListener('change', function(e) {
        if (e.target && e.target.id === 'edit-photo-input') { 
            const file = e.target.files[0];
            if (file) {
                const form = e.target.closest('#edit-mode-form');
                const admissionNo = form ? form.querySelector('input[name="AdmissionNo"]').value : null;
                const formData = new FormData();
                formData.append('AdmissionNo', admissionNo);
                formData.append('photo', file);
                
                fetch('api/students/upload_temp.php', { method: 'POST', body: formData })
                .then(r => r.json())
                .then(data => {
                    if(data.success) {
                        const newSrc = data.previewUrl + '?t=' + new Date().getTime();
                        if (document.getElementById('display-photo')) document.getElementById('display-photo').src = newSrc;
                        if (document.getElementById('form-photo-preview')) document.getElementById('form-photo-preview').src = newSrc;
                        document.getElementById('temp-photo-filename').value = data.tempFileName;
                        window.togglePageEditMode('edit');
                    } else {
                        window.showCustomAlert('error', 'Upload Failed', data.message);
                    }
                });
            }
        }
    });
});

// --- HELPER FUNCTIONS ---

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

window.executeDelete = function(admissionNo) {
    fetch(`api/students/deletestudent.php?id=${admissionNo}`).then(r => r.json()).then(data => {
        document.getElementById('action-confirm-modal').classList.remove('show'); 
        if(data.success) {
            window.showCustomAlert('success', 'Deleted', 'Record deleted.');
            if(window.location.href.includes('studentprofile.php')) window.location.href = 'studentmanagement.php#list';
            else if(typeof window.loadStudentList === 'function') window.loadStudentList();
        } else {
            window.showCustomAlert('error', 'Error', data.message);
        }
    });
};

window.togglePageEditMode = function(mode) {
    const viewContent = document.getElementById('view-mode-content');
    const editForm = document.getElementById('edit-mode-form');
    const editBtn = document.getElementById('edit-btn'); 
    const saveCancelGroup = document.getElementById('save-cancel-group');
    const imgContainer = document.querySelector('.profile-image-container'); 

    if (!viewContent || !editForm) return;

    if (mode === 'edit') {
        viewContent.style.display = 'none';
        editForm.style.display = 'block'; 
        if(editBtn) editBtn.style.display = 'none';
        if(saveCancelGroup) saveCancelGroup.style.display = 'flex';
        if(imgContainer) imgContainer.classList.add('editable-mode'); 
    } else {
        viewContent.style.display = 'block'; 
        editForm.style.display = 'none';
        if(editBtn) editBtn.style.display = 'inline-flex';
        if(saveCancelGroup) saveCancelGroup.style.display = 'none';
        if(imgContainer) imgContainer.classList.remove('editable-mode');
    }
};

window.executeProfileUpdate = function() {
    const form = document.getElementById('edit-mode-form');
    if (!form) return;
    const formData = new FormData(form);
    formData.append('action', 'update');

    fetch('api/students/edit_student.php', { method: 'POST', body: formData })
    .then(r => r.json())
    .then(data => {
        if (data.success) {
            window.showCustomAlert('success', 'Update Successful', 'Student details updated.');
            document.getElementById('temp-photo-filename').value = '';
            window.loadProfileViaAjax(formData.get('AdmissionNo')); 
        } else {
            window.showCustomAlert('error', 'Update Failed', data.message);
        }
    });
};

window.executeProfileCancel = function() {
    const tempFile = document.getElementById('temp-photo-filename').value;
    const admissionNo = document.querySelector('input[name="AdmissionNo"]').value;

    if (tempFile && admissionNo) {
        const formData = new FormData();
        formData.append('action', 'delete_temp');
        formData.append('fileName', tempFile);
        formData.append('AdmissionNo', admissionNo);
        fetch('api/students/edit_student.php', { method: 'POST', body: formData });
        
        // Reset UI
        document.getElementById('temp-photo-filename').value = '';
        const originalSrc = document.getElementById('original-photo-src').value;
        if (document.getElementById('display-photo')) document.getElementById('display-photo').src = originalSrc;
        document.getElementById('edit-photo-input').value = '';
    }
    window.togglePageEditMode('view');
};

// =========================================================================
// 2. CORE VIEW FUNCTIONS
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

window.executeDelete = function(admissionNo) {
    fetch(`api/students/deletestudent.php?id=${admissionNo}`).then(r => r.json()).then(data => {
        document.getElementById('action-confirm-modal').classList.remove('show'); 
        if(data.success) {
            window.showCustomAlert('success', 'Deleted', 'Record deleted.');
            if(window.location.href.includes('studentprofile.php')) window.location.href = 'studentmanagement.php#list';
            else if(typeof window.loadStudentList === 'function') window.loadStudentList();
        } else {
            window.showCustomAlert('error', 'Error', data.message);
        }
    });
};

window.printStudentProfile = function(admissionNo) {
    const printUrl = `modules/students/print_student.php?ad_no=${admissionNo}`;
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

window.toggleStudentHistory = function(admissionNo) {
    const wrapper = document.getElementById('history-content-wrapper');
    const tbody = document.getElementById('history-table-body');
    const emptyMsg = document.getElementById('history-empty-msg');
    if (wrapper.style.display === 'block') { wrapper.style.display = 'none'; return; }
    wrapper.style.display = 'block';
    tbody.innerHTML = '<tr><td colspan="7" style="text-align:center; padding:20px;"><i class="fa fa-spinner fa-spin"></i> Loading...</td></tr>';
    if(emptyMsg) emptyMsg.style.display = 'none';

    fetch(`api/students/get_student_history.php?id=${admissionNo}`)
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

// =========================================================================
// 3. QUICK EDIT MODULE LOGIC (INLINE EDITING)
// =========================================================================

let currentQuickEditPage = 1;

function initQuickEditModule() {
    const qeLevel = document.getElementById('qe-level');
    const qeClass = document.getElementById('qe-class');
    const qeForm = document.getElementById('quick-edit-filter-form');
    
    if (qeLevel && qeClass) {
        qeLevel.addEventListener('change', () => window.populateClassDropdown(qeLevel, qeClass, true));
        window.populateClassDropdown(qeLevel, qeClass, true);
    }

    if (qeForm) {
        qeForm.addEventListener('submit', (e) => {
            e.preventDefault();
            currentQuickEditPage = 1; 
            loadQuickEditData(currentQuickEditPage);
        });
    }

    const prevBtn = document.getElementById('qe-prev-btn');
    const nextBtn = document.getElementById('qe-next-btn');
    if (prevBtn) prevBtn.addEventListener('click', () => { if (currentQuickEditPage > 1) loadQuickEditData(--currentQuickEditPage); });
    if (nextBtn) nextBtn.addEventListener('click', () => { loadQuickEditData(++currentQuickEditPage); });

    if (document.getElementById('qe-table-body')) {
        loadQuickEditData(1);
    }
}

window.loadQuickEditData = function(page) {
    currentQuickEditPage = page;
    const form = document.getElementById('quick-edit-filter-form');
    if (!form) return;

    const limit = document.getElementById('qe-limit').value;
    const tbody = document.getElementById('qe-table-body');
    const params = new URLSearchParams(new FormData(form));
    
    params.append('page', page);
    params.append('limit', limit);

    tbody.innerHTML = '<tr><td colspan="10" style="text-align:center; padding:20px;"><i class="fa fa-spinner fa-spin"></i> Loading...</td></tr>';

    fetch(`api/students/fetch_quick_edit.php?${params.toString()}`)
    .then(r => r.json())
    .then(data => {
        if (data.success) {
            renderQuickEditTable(data);
            updateQuickEditPagination(data);
        } else {
            tbody.innerHTML = `<tr><td colspan="10" class="text-center" style="color:red;">Error: ${data.message}</td></tr>`;
        }
    })
    .catch(err => {
        console.error(err);
        tbody.innerHTML = '<tr><td colspan="10" class="text-center" style="color:red;">Connection Error</td></tr>';
    });
};

function renderQuickEditTable(data) {
    const tbody = document.getElementById('qe-table-body');
    tbody.innerHTML = '';

    if (!data.data || data.data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="10" class="text-center" style="padding:20px;">No records found.</td></tr>';
        return;
    }

    data.data.forEach(row => {
        const tr = document.createElement('tr');
        tr.id = `row-${row.AdmissionNo}`;
        tr.dataset.original = JSON.stringify(row);
        
        tr.innerHTML = `
            <td><strong>${row.AdmissionNo}</strong></td>
            <td class="cell-name">${row.Name} ${row.Surname}</td>
            <td class="cell-lin">${row.LIN || '-'}</td>
            <td class="cell-gender">${row.Gender}</td>
            <td class="cell-class">${row.Class}</td>
            <td class="cell-stream">${row.Stream || ''}</td>
            <td class="cell-residence">${row.Residence}</td>
            <td class="cell-entry">${row.EntryStatus}</td>
            <td class="cell-contact">${row.Contact || ''}</td>
            <td class="cell-paycode">${row.PayCode || '-'}</td>
            <td class="action-cell">
                <button class="btn-action view-btn" onclick="editQuickRow(${row.AdmissionNo})">
                    <i class="fa fa-pencil"></i> Edit
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

function updateQuickEditPagination(data) {
    const prevBtn = document.getElementById('qe-prev-btn');
    const nextBtn = document.getElementById('qe-next-btn');
    const pageNumbers = document.getElementById('qe-page-numbers');
    const info = document.getElementById('qe-pagination-info');

    const start = (data.page - 1) * data.limit + 1;
    const end = Math.min(start + data.limit - 1, data.total);
    info.textContent = `Showing ${start}-${end} of ${data.total}`;

    if(prevBtn) prevBtn.disabled = data.page <= 1;
    if(nextBtn) nextBtn.disabled = data.page >= data.total_pages;

    if(pageNumbers) {
        pageNumbers.innerHTML = '';
        const totalPages = data.total_pages;
        const current = parseInt(data.page);
        
        let pagesToShow = [];
        if (totalPages <= 7) {
            pagesToShow = Array.from({length: totalPages}, (_, i) => i + 1);
        } else {
            if (current <= 4) pagesToShow = [1, 2, 3,'...', totalPages];
            else if (current >= totalPages - 3) pagesToShow = [1, '...', totalPages - 4, totalPages - 3, totalPages - 2, totalPages - 1, totalPages];
            else pagesToShow = [1, '...', current - 1, current, current + 1, '...', totalPages];
        }

        pagesToShow.forEach(p => {
        const btn = document.createElement('button');
        const isActive = p === current;

        btn.className = `btn-primary`;
        btn.style.maxWidth = '20px'; 
        btn.style.padding = '5px';
        btn.style.boxShadow = 'none';
        btn.style.margin = '0 2px'; 

        if (isActive) {
            btn.style.background = 'var(--primary-color)'; 
            btn.style.color = 'var(--card-bg)';
        } else {
            btn.style.background = 'none';
        }

        btn.textContent = p;

        if (p === '...') {
            btn.disabled = true;
            btn.style.background = 'transparent';
            btn.style.color = 'var(--text-color)';
            btn.style.border = 'none';
        } else {
            if (!isActive) {
                btn.onclick = () => loadQuickEditData(p);
            }
        }
        pageNumbers.appendChild(btn);
    });
    }
}

// Inline Editing Functions
window.editQuickRow = function(id) {
    const row = document.getElementById(`row-${id}`);
    if (!row) return;

    const data = JSON.parse(row.dataset.original);
    
    // Name (Split)
    row.querySelector('.cell-name').innerHTML = `
        <input type="text" id="edit-name-${id}" value="${data.Name}" style="width:80px; padding:4px;" placeholder="Name">
        <input type="text" id="edit-surname-${id}" value="${data.Surname}" style="width:80px; padding:4px;" placeholder="Surname">
    `;
    row.querySelector('.cell-lin').innerHTML = `
        <input type="text" id="edit-lin-${id}" value="${data.LIN || ''}" style="padding:4px; width:70px;" placeholder="LIN">
    `;
    // Gender
    row.querySelector('.cell-gender').innerHTML = `
        <select id="edit-gender-${id}" style="padding:4px;">
            <option value="Male" ${data.Gender === 'Male' ? 'selected' : ''}>Male</option>
            <option value="Female" ${data.Gender === 'Female' ? 'selected' : ''}>Female</option>
        </select>
    `;

    // Class
    let classOpts = '';
    ['PP.1','PP.2','PP.3','P.1','P.2','P.3','P.4','P.5','P.6','P.7','S.1','S.2','S.3','S.4','S.5','S.6'].forEach(c => {
        classOpts += `<option value="${c}" ${data.Class === c ? 'selected' : ''}>${c}</option>`;
    });
    row.querySelector('.cell-class').innerHTML = `<select id="edit-class-${id}" style="padding:4px; width:70px;">${classOpts}</select>`;
    // Stream
    let streamOpts = '<option value="">-</option>';
    ['A','B','C','D','E'].forEach(s => {
        streamOpts += `<option value="${s}" ${data.Stream === s ? 'selected' : ''}>${s}</option>`;
    });
    row.querySelector('.cell-stream').innerHTML = `<select id="edit-stream-${id}" style="padding:4px;">${streamOpts}</select>`;

    // Residence
    row.querySelector('.cell-residence').innerHTML = `
        <select id="edit-residence-${id}" style="padding:4px;">
            <option value="Day" ${data.Residence === 'Day' ? 'selected' : ''}>Day</option>
            <option value="Boarding" ${data.Residence === 'Boarding' ? 'selected' : ''}>Boarding</option>
        </select>
    `;

    // Entry Status
    row.querySelector('.cell-entry').innerHTML = `
        <select id="edit-entry-${id}" style="padding:4px;">
            <option value="New" ${data.EntryStatus === 'New' ? 'selected' : ''}>New</option>
            <option value="Continuing" ${data.EntryStatus === 'Continuing' ? 'selected' : ''}>Continuing</option>
        </select>
    `;

    // Contact
    row.querySelector('.cell-contact').innerHTML = `
        <input type="text" id="edit-contact-${id}" value="${data.Contact || ''}" style="width:120px; padding:4px;">
    `;

    // Buttons - MODIFIED TO USE MASTER POPUP
    row.querySelector('.action-cell').innerHTML = `
        <div style="display:flex; gap:4px;">
            <button class="btn-action btn-success" onclick="confirmAction('quick_save', ${id})" style="background:var(--success-color); color:white; padding:4px 8px;" title="Save">
                <i class="fa fa-save"></i>
            </button>
            <button class="btn-action btn-gray" onclick="confirmAction('quick_cancel', ${id})" style="background:#888; color:white; padding:4px 8px;" title="Cancel">
                <i class="fa fa-times"></i>
            </button>
        </div>
    `;
};

window.cancelQuickRow = function(id) {
    const row = document.getElementById(`row-${id}`);
    if (!row) return;
    
    const data = JSON.parse(row.dataset.original);
    
    row.querySelector('.cell-name').textContent = `${data.Name} ${data.Surname}`;
    row.querySelector('.cell-lin').innerHTML = `${data.LIN || ''}`;
    row.querySelector('.cell-gender').textContent = data.Gender;
    row.querySelector('.cell-class').textContent = data.Class;
    row.querySelector('.cell-stream').textContent = data.Stream || '';
    row.querySelector('.cell-residence').textContent = data.Residence;
    row.querySelector('.cell-entry').textContent = data.EntryStatus;
    row.querySelector('.cell-contact').textContent = data.Contact || '';
    
    row.querySelector('.action-cell').innerHTML = `
        <button class="btn-action view-btn" onclick="editQuickRow(${data.AdmissionNo})">
            <i class="fa fa-pencil"></i> Edit
        </button>
    `;
};

window.saveQuickRow = function(id) {
    const row = document.getElementById(`row-${id}`);
    
    // Collect Data
    const payload = new FormData();
    payload.append('AdmissionNo', id);
    payload.append('Name', document.getElementById(`edit-name-${id}`).value);
    payload.append('Surname', document.getElementById(`edit-surname-${id}`).value);
    payload.append('LIN', document.getElementById(`edit-lin-${id}`).value);
    payload.append('Gender', document.getElementById(`edit-gender-${id}`).value);
    payload.append('Class', document.getElementById(`edit-class-${id}`).value);
    payload.append('Stream', document.getElementById(`edit-stream-${id}`).value);
    payload.append('Residence', document.getElementById(`edit-residence-${id}`).value);
    payload.append('EntryStatus', document.getElementById(`edit-entry-${id}`).value);
    payload.append('Contact', document.getElementById(`edit-contact-${id}`).value);

    const btnGroup = row.querySelector('.action-cell');
    btnGroup.innerHTML = '<i class="fa fa-spinner fa-spin" style="color:var(--primary-color);"></i>';

    fetch('api/students/update_quick_edit.php', { method: 'POST', body: payload })
    .then(r => r.json())
    .then(resp => {
        if(resp.success) {
            // Update local backup
            const oldData = JSON.parse(row.dataset.original);
            const newData = {
                ...oldData,
                Name: payload.get('Name'),
                Surname: payload.get('Surname'),
                LIN: payload.get('LIN'),
                Gender: payload.get('Gender'),
                Class: payload.get('Class'),
                Stream: payload.get('Stream'),
                Residence: payload.get('Residence'),
                EntryStatus: payload.get('EntryStatus'),
                Contact: payload.get('Contact')
            };
            row.dataset.original = JSON.stringify(newData);
            cancelQuickRow(id);
            window.showCustomAlert('success', 'Saved', 'Changes saved successfully.');
        } else {
            window.showCustomAlert('error', 'Save Failed', resp.message);
            cancelQuickRow(id); 
            editQuickRow(id); 
        }
    })
    .catch(err => {
        console.error(err);
        window.showCustomAlert('error', 'Network Error', 'Could not save changes.');
        row.querySelector('.action-cell').innerHTML = `<button class="btn-action view-btn" onclick="editQuickRow(${id})"><i class="fa fa-pencil"></i> Edit</button>`;
    });
};

// =========================================================================
// 4. ACADEMIC EDIT MODULE LOGIC
// =========================================================================

let currentAcademicPage = 1;

function initAcademicEditModule() {
    const aeLevel = document.getElementById('ae-level');
    const aeClass = document.getElementById('ae-class');
    const aeForm = document.getElementById('academic-edit-filter-form');
    
    // Auto-populate classes if level changes
    if (aeLevel && aeClass) {
        aeLevel.addEventListener('change', () => window.populateClassDropdown(aeLevel, aeClass, true));
        window.populateClassDropdown(aeLevel, aeClass, true); // Run once on load
    }
    if (aeForm) {
        aeForm.addEventListener('submit', (e) => {
            e.preventDefault();
            currentAcademicPage = 1; 
            // FIX: Use correct variable
            loadAcademicEditData(currentAcademicPage);
        }); 
    }
    const pBtn = document.getElementById('ae-prev-btn');
    const nBtn = document.getElementById('ae-next-btn');
    if(pBtn) pBtn.addEventListener('click', () => {if(currentAcademicPage > 1) loadAcademicEditData(currentAcademicPage - 1);});
    if(nBtn) nBtn.addEventListener('click', () => {loadAcademicEditData(currentAcademicPage + 1);});
    
   if(document.getElementById('ae-table-body')){
    loadAcademicEditData(1);
   }
}

window.loadAcademicEditData = function(page) {
    currentAcademicPage = page;
    const form = document.getElementById('academic-edit-filter-form');
    if (!form) return;
    const limit=document.getElementById('ae-limit').value;
    const tbody = document.getElementById('ae-table-body');
    const params = new URLSearchParams(new FormData(form));
    params.append('page', page);
    params.append('limit', limit); 

    tbody.innerHTML = '<tr><td colspan="10" class="text-center" style="padding:20px;"><i class="fa fa-spinner fa-spin"></i> Loading Academics...</td></tr>';

    fetch(`api/students/fetch_academic_edit.php?${params.toString()}`)
    .then(r => r.json())
    .then(data => {
        if (data.success) {
            renderAcademicEditTable(data);
            updateAcademicPagination(data);
        } else {
            tbody.innerHTML = `<tr><td colspan="10" class="text-center" style="color:red;">Error: ${data.message}</td></tr>`;
        }
    })
    .catch(err => {
        console.error(err);
        tbody.innerHTML = '<tr><td colspan="10" class="text-center" style="color:red;">Connection Error</td></tr>';
    });
};

function renderAcademicEditTable(data) {
    const tbody = document.getElementById('ae-table-body');
    tbody.innerHTML = '';

    if (!data.data || data.data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="10" class="text-center" style="padding:20px;">No records found.</td></tr>';
        return;
    }

    data.data.forEach(row => {
        const tr = document.createElement('tr');
        tr.id = `ac-row-${row.AdmissionNo}`;
        tr.dataset.original = JSON.stringify(row);
        
        tr.innerHTML = `
            <td><strong>${row.AdmissionNo}</strong></td>
            <td>${row.Name} ${row.Surname}</td>
            <td class="cell-lin">${row.LIN || '-'}</td>
            <td class="cell-stream">${row.Stream || '-'}</td>
            <td class="cell-comb">${row.Combination || '-'}</td>
            <td class="cell-ple-idx">${row.PLEIndexNumber || ''}</td>
            <td class="cell-ple-agg">${row.PLEAggregate || ''}</td>
            <td class="cell-uce-idx">${row.UCEIndexNumber || ''}</td>
            <td class="cell-uce-res">${row.UCEResult || ''}</td>
            <td class="action-cell">
                <button class="btn-action view-btn" onclick="editAcademicRow(${row.AdmissionNo})">
                    <i class="fa fa-pencil"></i> Edit
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

function updateAcademicPagination(data) {
    const prevBtn = document.getElementById('ae-prev-btn');
    const nextBtn = document.getElementById('ae-next-btn');
    const pageNumbers = document.getElementById('ae-page-numbers');
    const info = document.getElementById('ae-pagination-info');
    
    // FIX: Fallback if data.limit is missing
    const limit = data.limit || parseInt(document.getElementById('ae-limit').value); 

    const start = (data.page - 1) * limit + 1;
    const end = Math.min(start + limit - 1, data.total);
    info.textContent = `Showing ${start}-${end} of ${data.total}`;

    if(prevBtn) prevBtn.disabled = data.page <= 1;
    if(nextBtn) nextBtn.disabled = data.page >= data.total_pages;

    if(pageNumbers) {
        pageNumbers.innerHTML = '';
        const totalPages = data.total_pages;
        const current = parseInt(data.page);
        
        let pagesToShow = [];
        if (totalPages <= 7) {
            pagesToShow = Array.from({length: totalPages}, (_, i) => i + 1);
        } else {
            if (current <= 4) pagesToShow = [1, 2, 3,'...', totalPages];
            else if (current >= totalPages - 3) pagesToShow = [1, '...', totalPages - 4, totalPages - 3, totalPages - 2, totalPages - 1, totalPages];
            else pagesToShow = [1, '...', current - 1, current, current + 1, '...', totalPages];
        }

        pagesToShow.forEach(p => {
        const btn = document.createElement('button');
        const isActive = p === current;

        btn.className = `btn-primary`;
        btn.style.maxWidth = '20px'; 
        btn.style.padding = '5px';
        btn.style.boxShadow = 'none';
        btn.style.margin = '0 2px'; 

        if (isActive) {
            btn.style.background = 'var(--primary-color)'; 
            btn.style.color = 'var(--card-bg)';
        } else {
            btn.style.background = 'none';
        }

        btn.textContent = p;

        if (p === '...') {
            btn.disabled = true;
            btn.style.background = 'transparent';
            btn.style.color = 'var(--text-color)';
            btn.style.border = 'none';
        } else {
            if (!isActive) {
                btn.onclick = () => loadAcademicEditData(p);
            }
        }
        pageNumbers.appendChild(btn);
    });
    }
}

function initSearchModule() {
    const searchInput = document.getElementById('global-student-search');
    const resultsContainer = document.getElementById('global-search-results');

    if (searchInput) {
        let timeout = null;
        searchInput.focus(); // Auto-focus

        searchInput.addEventListener('input', function(e) {
            const query = e.target.value.trim();
            
            clearTimeout(timeout);
            timeout = setTimeout(() => {
                if (query.length > 1) {
                    performGlobalSearch(query, resultsContainer);
                } else {
                    resultsContainer.innerHTML = '';
                }
            }, 300); // 300ms debounce
        });
    }
}

function performGlobalSearch(query, container) {
    // Inject loading HTML
    container.innerHTML = `
        <div class="search-loading-state">
            <i class="fa fa-spinner fa-spin search-loading-icon"></i>
        </div>`;

    fetch(`api/students/search_global.php?query=${encodeURIComponent(query)}`)
    .then(r => r.json())
    .then(data => {
        container.innerHTML = '';
        
        if (data.success && data.data.length > 0) {
            data.data.forEach(s => {
                const card = document.createElement('div');
                card.className = 'search-result-card';
                
                // Click navigates to profile
                card.onclick = () => window.loadProfileViaAjax(s.AdmissionNo);

                // Construct HTML with classes (No inline styles)
                card.innerHTML = `
                    <img src="${s.PhotoPath}" class="search-card-photo" alt="Student" onerror="this.src='static/images/default_profile.png'">
                    <div class="search-card-info">
                        <div class="search-card-header">
                            <span class="highlight-label">NAME:</span> ${s.Name} ${s.Surname} | 
                            <span class="highlight-label">CLASS:</span> ${s.Class} | 
                            <span class="highlight-label">STREAM:</span> ${s.Stream || '-'} | 
                            <span class="highlight-label">TERM:</span> ${s.Term}
                        </div>
                        <div class="search-card-details">
                            <span class="highlight-label">PARENT:</span> ${s.ParentDisplay} | 
                            <span class="highlight-label">CONTACT:</span> ${s.ContactDisplay}
                        </div>
                        <div class="search-card-address">
                            <span class="highlight-label">ADDRESS:</span> ${s.FormattedAddress}
                        </div>
                    </div>
                `;
                container.appendChild(card);
            });
        } else {
            container.innerHTML = `
                <div class="search-empty-state">
                    <p class="search-empty-text">No students found matching "${query}".</p>
                </div>`;
        }
    })
    .catch(err => {
        console.error(err);
        container.innerHTML = `
            <div class="search-empty-state">
                <p class="search-error-text">Error loading results. Check connection.</p>
            </div>`;
    });
}

// --- EDITING LOGIC ---

window.editAcademicRow = function(id) {
    const row = document.getElementById(`ac-row-${id}`);
    if (!row) return;
    const data = JSON.parse(row.dataset.original);

    // 1. LIN
    row.querySelector('.cell-lin').innerHTML = `<input type="text" id="ac-lin-${id}" value="${data.LIN || ''}" style="width:100px; padding:4px;">`;

    // 2. Stream
    const streams = ['A','B','C','D','E'];
    let strOpts = `<option value="">-</option>`;
    streams.forEach(s => strOpts += `<option value="${s}" ${data.Stream === s ? 'selected' : ''}>${s}</option>`);
    row.querySelector('.cell-stream').innerHTML = `<select id="ac-stream-${id}" style="padding:4px;">${strOpts}</select>`;

    // 3. Combination
    const combs = ['PEM/ICT', 'PCM/ICT', 'MEG/ICT', 'BEM/ICT', 'PCB/SUBMATH', 'BCM/ICT', 'HEG/ICT', 'DEG/ICT', 'HEL/ICT'];
    let combOpts = `<option value="">Select</option>`;
    combs.forEach(c => combOpts += `<option value="${c}" ${data.Combination === c ? 'selected' : ''}>${c}</option>`);
    row.querySelector('.cell-comb').innerHTML = `<select id="ac-comb-${id}" style="padding:4px; width:110px;">${combOpts}</select>`;

    // 4. PLE Index & Agg
    row.querySelector('.cell-ple-idx').innerHTML = `<input type="text" id="ac-ple-idx-${id}" value="${data.PLEIndexNumber || ''}" style="width:120px; padding:4px;">`;
    row.querySelector('.cell-ple-agg').innerHTML = `<input type="number" id="ac-ple-agg-${id}" value="${data.PLEAggregate || ''}" style="width:50px; padding:4px;">`;

    // 5. UCE Index & Result
    row.querySelector('.cell-uce-idx').innerHTML = `<input type="text" id="ac-uce-idx-${id}" value="${data.UCEIndexNumber || ''}" style="width:120px; padding:4px;">`;
    row.querySelector('.cell-uce-res').innerHTML = `<input type="text" id="ac-uce-res-${id}" value="${data.UCEResult || ''}" style="width:80px; padding:4px;">`;

    // Buttons - MODIFIED TO USE MASTER POPUP
    row.querySelector('.action-cell').innerHTML = `
        <div style="display:flex; gap:4px;">
            <button class="btn-action btn-success" onclick="confirmAction('academic_save', ${id})" title="Save">
                <i class="fa fa-save"></i>
            </button>
            <button class="btn-action btn-gray" onclick="confirmAction('academic_cancel', ${id})" title="Cancel">
                <i class="fa fa-times"></i>
            </button>
        </div>
    `;
};

window.cancelAcademicRow = function(id) {
    const row = document.getElementById(`ac-row-${id}`);
    if (!row) return;
    const data = JSON.parse(row.dataset.original);

    // Restore text
    row.querySelector('.cell-lin').textContent = data.LIN || '-';
    row.querySelector('.cell-stream').textContent = data.Stream || '-';
    row.querySelector('.cell-comb').textContent = data.Combination || '-';
    row.querySelector('.cell-ple-idx').textContent = data.PLEIndexNumber || '';
    row.querySelector('.cell-ple-agg').textContent = data.PLEAggregate || '';
    row.querySelector('.cell-uce-idx').textContent = data.UCEIndexNumber || '';
    row.querySelector('.cell-uce-res').textContent = data.UCEResult || '';

    // Restore Edit Button
    row.querySelector('.action-cell').innerHTML = `
        <button class="btn-action view-btn" onclick="editAcademicRow(${id})">
            <i class="fa fa-pencil"></i> Edit
        </button>
    `;
};

window.saveAcademicRow = function(id) {
    const row = document.getElementById(`ac-row-${id}`);
    
    const payload = new FormData();
    payload.append('AdmissionNo', id);
    payload.append('LIN', document.getElementById(`ac-lin-${id}`).value);
    payload.append('Stream', document.getElementById(`ac-stream-${id}`).value);
    payload.append('Combination', document.getElementById(`ac-comb-${id}`).value);
    payload.append('PLEIndexNumber', document.getElementById(`ac-ple-idx-${id}`).value);
    payload.append('PLEAggregate', document.getElementById(`ac-ple-agg-${id}`).value);
    payload.append('UCEIndexNumber', document.getElementById(`ac-uce-idx-${id}`).value);
    payload.append('UCEResult', document.getElementById(`ac-uce-res-${id}`).value);

    // Show loading
    row.querySelector('.action-cell').innerHTML = '<i class="fa fa-spinner fa-spin" style="color:var(--primary-color);"></i>';

    fetch('api/students/update_academic_edit.php', { method: 'POST', body: payload })
    .then(r => r.json())
    .then(resp => {
        if(resp.success) {
            // Update local data object
            const oldData = JSON.parse(row.dataset.original);
            const newData = {
                ...oldData,
                LIN: payload.get('LIN'),
                Stream: payload.get('Stream'),
                Combination: payload.get('Combination'),
                PLEIndexNumber: payload.get('PLEIndexNumber'),
                PLEAggregate: payload.get('PLEAggregate'),
                UCEIndexNumber: payload.get('UCEIndexNumber'),
                UCEResult: payload.get('UCEResult')
            };
            row.dataset.original = JSON.stringify(newData);
            cancelAcademicRow(id); 
            window.showCustomAlert('success', 'Saved', 'Academic details updated.');
        } else {
            window.showCustomAlert('error', 'Error', resp.message);
            cancelAcademicRow(id);
        }
    })
    .catch(err => {
        console.error(err);
        window.showCustomAlert('error', 'Error', 'Connection failed.');
        row.querySelector('.action-cell').innerHTML = `
            <button class="btn-action view-btn" onclick="editAcademicRow(${id})">
                <i class="fa fa-pencil"></i> Edit
            </button>
        `;
    });
};
// =========================================================================
// 5. PROFILE & ADMISSION LOGIC
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

window.loadProfileViaAjax = function(admissionNo) {
    localStorage.setItem('currentStudentId', admissionNo); 
    if (window.location.hash !== '#profile') {
        history.pushState(null, null, '#profile'); 
    }
    document.querySelectorAll('.module').forEach(m => m.style.display = 'none');
    const pMod = document.getElementById('profile-module');
    if(pMod) {
        pMod.style.display = 'block';
        pMod.innerHTML = '<div style="text-align:center;padding:50px;"><i class="fa fa-spinner fa-spin fa-3x" style="color:var(--primary-color);"></i><br>Loading Profile...</div>';
        fetch(`api/students/get_student_profile.php?id=${admissionNo}`)
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
    const imgContainer = document.querySelector('.profile-image-container'); 

    if (!viewContent || !editForm) return;

    if (mode === 'edit') {
        viewContent.style.display = 'none';
        editForm.style.display = 'block'; 
        if(editBtn) editBtn.style.display = 'none';
        if(saveCancelGroup) saveCancelGroup.style.display = 'flex';
        if(imgContainer) imgContainer.classList.add('editable-mode'); 
    } else {
        viewContent.style.display = 'block'; 
        editForm.style.display = 'none';
        if(editBtn) editBtn.style.display = 'inline-flex';
        if(saveCancelGroup) saveCancelGroup.style.display = 'none';
        if(imgContainer) imgContainer.classList.remove('editable-mode');
    }
};

window.triggerPhotoUpload = function() {
    const fileInput = document.getElementById('edit-photo-input'); 
    if (fileInput) fileInput.click();
};

// --- PROFILE EDIT HELPER FUNCTIONS FOR MASTER POPUP ---

window.executeProfileUpdate = function() {
    const form = document.getElementById('edit-mode-form');
    if (!form) return;

    const formData = new FormData(form);
    formData.append('action', 'update');

    fetch('api/students/edit_student.php', { method: 'POST', body: formData })
    .then(r => r.json())
    .then(data => {
        if (data.success) {
            window.showCustomAlert('success', 'Update Successful', 'Student details updated.');
            const tempInput = document.getElementById('temp-photo-filename');
            if (tempInput) tempInput.value = '';
            const id = formData.get('AdmissionNo');
            window.loadProfileViaAjax(id); 
        } else {
            window.showCustomAlert('error', 'Update Failed', data.message);
        }
    })
    .catch(error => { 
        console.error(error);
        window.showCustomAlert('error', 'Network Error', 'Failed to connect.'); 
    });
};

window.executeProfileCancel = function() {
    const tempInput = document.getElementById('temp-photo-filename');
    const tempFile = tempInput ? tempInput.value : '';
    const form = document.getElementById('edit-mode-form');
    const studentIdInput = form ? form.querySelector('input[name="AdmissionNo"]') : null;
    const admissionNo = studentIdInput ? studentIdInput.value : null;

    if (tempFile && admissionNo) {
        const formData = new FormData();
        formData.append('action', 'delete_temp');
        formData.append('fileName', tempFile);
        formData.append('AdmissionNo', admissionNo);
        fetch('api/students/edit_student.php', { method: 'POST', body: formData });
        
        // Reset UI
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
};

window.submitEditForm = function() {
    const form = document.getElementById('edit-mode-form');
    if (!form) return;
    
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }

    // Call Master Popup
    window.confirmAction('profile_save');
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

// school_administration1/assets/scripts/student.js

// ... (Keep existing code from top until "EVENT LISTENERS" section) ...

// =========================================================================
// 6. EVENT LISTENERS
// =========================================================================

document.addEventListener('DOMContentLoaded', () => {
    
    // Admission Logic
    const admissionForm = document.getElementById('admission-form');
    if (admissionForm) {
        admissionForm.addEventListener('submit', window.handleAdmission);
        admissionForm.addEventListener('reset', () => {
            setTimeout(() => {
                const previewImg = document.getElementById('admission-photo-preview');
                const photoWrapper = document.getElementById('admission-photo-wrapper');
                const placeholder = document.getElementById('upload-placeholder');
                if (previewImg) { previewImg.src = ''; previewImg.style.display = 'none'; }
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

    // Edit Profile Photo Logic
    document.addEventListener('change', function(e) {
        if (e.target && e.target.id === 'edit-photo-input') { 
            const file = e.target.files[0];
            if (file) {
                const formData = new FormData();
                const form = e.target.closest('#edit-mode-form');
                const studentIdInput = form ? form.querySelector('input[name="AdmissionNo"]') : null;
                const admissionNo = studentIdInput ? studentIdInput.value : null;

                if (admissionNo) formData.append('AdmissionNo', admissionNo);
                else {
                    window.showCustomAlert('error', 'Configuration Error', 'Could not locate Student ID.');
                    return; 
                }

                formData.append('photo', file);
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
                .catch(err => { window.showCustomAlert('error', 'Network Error', 'Check console.'); });
            }
        }
    });

    // --- UNIFIED CLICK HANDLER FOR BUTTONS ---
    document.addEventListener('click', function(e) {
        // Photo Overlay Click
        if (e.target.closest('.photo-edit-overlay') && !e.target.closest('[onclick]')) {
            window.triggerPhotoUpload();
        }
        
        // 1. EDIT Button
        const editBtn = e.target.closest('.js-edit-btn');
        if (editBtn) {
            e.preventDefault();
            window.togglePageEditMode('edit');
        }

        // 2. SAVE Button
        const saveBtn = e.target.closest('.js-save-profile');
        if (saveBtn) {
            e.preventDefault();
            window.confirmAction('profile_save');
        }

        // 3. CANCEL Button (Fixed Logic)
        const cancelBtn = e.target.closest('.js-cancel-edit');
        if (cancelBtn) {
            e.preventDefault();
            window.confirmAction('profile_cancel');
        }
        
        // 4. DELETE Button (Fixed Logic)
        const deleteBtn = e.target.closest('.js-delete-student');
        if (deleteBtn) { 
            e.preventDefault(); 
            // Use dataset.id because HTML now has data-id="..."
            window.confirmAction('delete_student', deleteBtn.dataset.id, deleteBtn.dataset.name);
        }
    });

    // --- INITIALIZE MODULES ---
    initQuickEditModule();
    initAcademicEditModule();
    initMigrationModule();
    initSearchModule();
});


// =========================================================================
// 7. MIGRATION UTILITIES
// =========================================================================

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
    
    // Removed old modal listeners
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
                    const row = `<tr><td style="text-align:center;"><input type="checkbox" class="mig-checkbox" value="${s.AdmissionNo}"></td><td><img src="${photo}" class="student-photo-thumb"></td><td>${s.Name} ${s.Surname}</td><td>${s.Class} ${s.Stream||''}</td><td>${s.AcademicYear}</td><td><button class="btn-action view-btn mig-single-btn" data-id="${s.AdmissionNo}" data-name="${s.Name}">Move</button></td></tr>`;
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

// --- MIGRATION HELPERS MODIFIED TO USE MASTER POPUP ---

function initiateMigration(ids, label) {
    const tYear = document.getElementById('mig-target-year').value;
    const tLevel = document.getElementById('mig-target-level').value;
    const tClass = document.getElementById('mig-target-class').value;
    const tTerm = document.getElementById('mig-target-term').value;
    const tStream = document.getElementById('mig-target-stream').value;

    if(!tYear || !tLevel || !tClass) return window.showCustomAlert('warning', 'Destination?', 'Please select Target Year, Level and Class.');

    const payload = {
        student_ids: ids, target_year: tYear, target_term: tTerm,
        target_level: tLevel, target_class: tClass, target_stream: tStream
    };
    
    // Call Master Popup
    window.confirmAction('migration', null, { 
        label: label, 
        targetDetails: `${tLevel} - ${tClass} (${tYear})`,
        payload: payload 
    });
}

function executeMigration(payload) {
    fetch('api/students/migrate_backend.php', {
        method: 'POST', 
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify(payload)
    })
    .then(r => r.json())
    .then(data => {
        if(data.success) {
            // FIX: Format Class and Stream nicely
            // If stream is empty, just show Class. If stream exists, show "Class Stream" (e.g., P.3 A)
            const classDisplay = data.target_class || '-';
            const streamDisplay = data.target_stream ? ` ${data.target_stream}` : ''; 
            
            const successMsg = `
                <div class="migration-summary" style="text-align:center; background-color:#f8f9fa; padding:15px; border-radius:8px; border:1px solid #eee;">
                    <div style="display:flex; flex-direction:column; justify-content:center; margin-bottom:10px;">
                        <span style="color:#666; font-size:0.9em;">Total Students</span>
                        <span style="font-weight:bold; font-size:1.4em; color:#28a745;">${data.count || '0'}</span>
                    </div>
                    
                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:10px; text-align:left; font-size:0.95em;">
                        <div style="background:white; padding:8px; border-radius:4px; border:1px solid #ddd;">
                            <span style="color:#888; font-size:0.8em; display:block;">New Class</span>
                            <span style="font-weight:bold; color:#333;">${classDisplay}${streamDisplay}</span>
                        </div>
                        <div style="background:white; padding:8px; border-radius:4px; border:1px solid #ddd;">
                            <span style="color:#888; font-size:0.8em; display:block;">Academic Year</span>
                            <span style="font-weight:bold; color:#333;">${data.target_year || 'N/A'}</span>
                        </div>
                    </div>
                </div>
            `;
            
            window.showCustomAlert('success', 'Migration Successful', successMsg);
            
            // Refresh list if function exists
            if(typeof fetchMigrationStudents === 'function') {
                fetchMigrationStudents();
            }
        } else {
            window.showCustomAlert('error', 'Migration Failed', data.message);
        }
    })
    .catch(err => { 
        console.error(err);
        window.showCustomAlert('error', 'Error', 'An unexpected error occurred. Check console.'); 
    });
}