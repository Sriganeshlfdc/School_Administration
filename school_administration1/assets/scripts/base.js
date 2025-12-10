// school_administration1/assets/scripts/base.js

let isSidebarOpen = true;
let currentTheme = 'light';
let activeModule = 'dashboard';
let openMenu = null;
let isSettingsOpen = false;

// DOM Elements
const body = document.body;
const menuToggle = document.getElementById('menu-toggle');
const menuIcon = menuToggle ? menuToggle.querySelector('i') : null;
const sidebar = document.getElementById('sidebar');
const content = document.getElementById('content'); 
const settingsBtn = document.getElementById('settings-btn');
const settingsPanel = document.getElementById('settings-panel');
const settingsCloseBtn = document.getElementById('settings-close-btn');
const themeToggleBtn = document.getElementById('theme-toggle-btn');
const fullscreenBtn = document.getElementById('fullscreen-btn');
const fullscreenIcon = fullscreenBtn ? fullscreenBtn.querySelector('i') : null;
const navLinks = document.querySelectorAll('.sidebar .main-item, .sidebar .sub-menu a');
const mobileOverlay = document.getElementById('overlay');

const FULLSCREEN_STORAGE_KEY = 'montfort_is_fullscreen';

// =========================================================================
// 1. SPA ROUTING LOGIC
// =========================================================================

function handleNavigate(targetModule) {
    if (!targetModule) return;
    activeModule = targetModule;

    // A. Force Hide Dashboard Module
    const dashboard = document.getElementById('dashboard-module');
    if (dashboard) dashboard.style.display = 'none';

    // B. Hide ALL other modules
    document.querySelectorAll('.module').forEach(module => {
        module.style.display = 'none';
    });

    // C. Show Target Module
    const targetEl = document.getElementById(`${targetModule}-module`);
    
    if (targetEl) {
        targetEl.style.display = 'block';
        
        // --- Data Loading Triggers ---
        
        // 1. Student List (Load if empty)
        if (targetModule === 'list' && typeof window.loadStudentList === 'function') {
            const listContainer = document.getElementById('student-list-results');
            if (listContainer && !listContainer.hasChildNodes()) {
                window.loadStudentList();
            }
        }
        
        // 2. Summary (Always reload for fresh data)
        if (targetModule === 'summary' && typeof window.loadSummary === 'function') {
            window.loadSummary();
        }

        // 3. Profile (Handle Refresh)
        if (targetModule === 'profile') {
             const savedId = localStorage.getItem('currentStudentId');
             if (savedId) {
                 if(typeof window.loadProfileViaAjax === 'function') {
                    window.loadProfileViaAjax(savedId);
                 } else {
                    // Retry if functions aren't ready yet
                    setTimeout(() => {
                        if(typeof window.loadProfileViaAjax === 'function') window.loadProfileViaAjax(savedId);
                    }, 100);
                 }
             } else {
                 handleNavigate('list');
                 return;
             }
        }

    } else {
        // Fallback: If target not found, show dashboard
        if(dashboard) dashboard.style.display = 'block';
    }

    // D. Update URL Hash
    if(history.pushState) {
        history.pushState(null, null, '#' + targetModule);
    } else {
        window.location.hash = targetModule;
    }

    // E. Update UI Active States
    navLinks.forEach(link => {
        link.classList.remove('active');
        if (link.dataset.menu === targetModule || link.getAttribute('href') === '#' + targetModule) {
            link.classList.add('active');
            const parentMenuListItem = link.closest('li');
            if (parentMenuListItem) {
                const subMenu = parentMenuListItem.closest('.sub-menu');
                if (subMenu) {
                    subMenu.classList.add('show');
                    const parentTrigger = subMenu.previousElementSibling;
                    if (parentTrigger) parentTrigger.classList.add('active');
                }
            }
        }
    });

    // F. Mobile: Close sidebar
    if (window.innerWidth <= 768 && isSidebarOpen) { 
        toggleSidebar();
    }
}

// =========================================================================
// 2. UI LAYOUT FUNCTIONS
// =========================================================================

function toggleSidebar() {
    if(!sidebar) return;
    isSidebarOpen = !isSidebarOpen;
    
    if(window.innerWidth <= 768) { 
        sidebar.classList.toggle('open', isSidebarOpen);
        if(mobileOverlay) mobileOverlay.classList.toggle('active', isSidebarOpen);
        sidebar.classList.remove('collapsed');
        if(menuIcon) menuIcon.className = isSidebarOpen ? 'fa fa-times' : 'fa fa-bars'; 
    }
    else {
        sidebar.classList.toggle('collapsed', !isSidebarOpen);
        if(content) content.classList.toggle('collapsed', !isSidebarOpen);
        if(menuIcon) menuIcon.className = isSidebarOpen ? 'fa fa-chevron-left' : 'fa fa-bars';
    }
}

function toggleSettings() {
    isSettingsOpen = !isSettingsOpen;
    if (settingsPanel) settingsPanel.classList.toggle('show');
}

function toggleTheme() {
    body.classList.remove(currentTheme + '-theme');
    currentTheme = (currentTheme === 'light') ? 'dark' : 'light';
    body.classList.add(currentTheme + '-theme');
    if (themeToggleBtn) themeToggleBtn.textContent = (currentTheme === 'light') ? 'Switch to Dark' : 'Switch to Light';
}

function toggleFullscreen() {
    if (!fullscreenIcon) return; 
    if (!document.fullscreenElement) {
        document.documentElement.requestFullscreen().then(() => {
            localStorage.setItem(FULLSCREEN_STORAGE_KEY, 'true');
        }).catch(err => console.error("Fullscreen error:", err));
        fullscreenIcon.className = 'fa-solid fa-compress';
    } else {
        if (document.exitFullscreen) {
            document.exitFullscreen().then(() => {
                localStorage.removeItem(FULLSCREEN_STORAGE_KEY);
            }).catch(err => console.error("Fullscreen exit error:", err));
            fullscreenIcon.className = 'fa-solid fa-expand';
        }
    }
}

function restoreFullscreen() {
    if (localStorage.getItem(FULLSCREEN_STORAGE_KEY) === 'true') {
        setTimeout(() => {
             document.documentElement.requestFullscreen().then(() => {
                if (fullscreenIcon) fullscreenIcon.className = 'fa-solid fa-compress';
            }).catch(() => {
                localStorage.removeItem(FULLSCREEN_STORAGE_KEY);
                if (fullscreenIcon) fullscreenIcon.className = 'fa-solid fa-expand';
            });
        }, 100);
    }
}

function handleAccordion(e){
    e.preventDefault();
    const item = e.currentTarget;
    const subMenu = item.nextElementSibling;
    const isDesktopCollapsed = (window.innerWidth > 768 && !isSidebarOpen);
    
    if (subMenu && subMenu.classList.contains('sub-menu')) {
        if (isDesktopCollapsed) toggleSidebar(); 
        if (openMenu && openMenu !== subMenu) openMenu.classList.remove('show'); 
        
        if(subMenu.classList.contains('show')) {
            subMenu.classList.remove('show');
            openMenu = null;
        } else {
            subMenu.classList.add('show');
            openMenu = subMenu;
        }
    } else {
        if (item.dataset.menu) handleNavigate(item.dataset.menu);
        else if (item.hasAttribute('href')) {
            const href = item.getAttribute('href');
            if (href && href.startsWith('#')) handleNavigate(href.substring(1));
        }
    }
}

// =========================================================================
// 3. INITIALIZATION
// =========================================================================

document.addEventListener('DOMContentLoaded', () => {
    if (menuToggle) menuToggle.addEventListener('click', toggleSidebar);
    if (mobileOverlay) mobileOverlay.addEventListener('click', toggleSidebar);
    if (settingsBtn) settingsBtn.addEventListener('click', toggleSettings);
    if (settingsCloseBtn) settingsCloseBtn.addEventListener('click', toggleSettings);
    if (themeToggleBtn) themeToggleBtn.addEventListener('click', toggleTheme);
    if (fullscreenBtn) fullscreenBtn.addEventListener('click', toggleFullscreen);

    navLinks.forEach(link => link.addEventListener('click', handleAccordion));
    
    if(sidebar) {
        if(window.innerWidth <= 768) { 
            isSidebarOpen = false;
            sidebar.classList.remove('open');
            sidebar.classList.add('collapsed'); 
            if (menuIcon) menuIcon.className = 'fa fa-bars';
        } else {
            isSidebarOpen = true;
            sidebar.classList.remove('collapsed');
            if (content) content.classList.remove('collapsed');
            if (menuIcon) menuIcon.className = 'fa fa-chevron-left';
        }
    }
    
    restoreFullscreen();

    // Fix: Immediately check hash and navigate
    const hash = window.location.hash.substring(1);
    
    // Explicitly hide dashboard if we are going somewhere else on load
    if (hash && hash !== 'dashboard') {
        const dash = document.getElementById('dashboard-module');
        if(dash) dash.style.display = 'none';
    }

    handleNavigate(hash || 'dashboard');

    window.addEventListener('hashchange', () => {
        const newHash = window.location.hash.substring(1);
        handleNavigate(newHash);
    });
});