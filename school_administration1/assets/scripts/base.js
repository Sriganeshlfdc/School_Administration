// school_administration1/assets/scripts/base.js

let isSidebarOpen = true;
let currentTheme = 'light';
let activeModule = 'dashboard';
let openMenu = null;
let isSettingsOpen = false;

const body = document.body;
const menuToggle = document.getElementById('menu-toggle');
const menuIcon = menuToggle ? menuToggle.querySelector('i') : null;
const sidebar = document.getElementById('sidebar');
const content = document.getElementById('content'); 
const moduleDisplay = document.getElementById('moduleDisplay'); 

const settingsBtn = document.getElementById('settings-btn');
const settingsPanel = document.getElementById('settings-panel');
const settingsCloseBtn = document.getElementById('settings-close-btn');

const themeToggleBtn = document.getElementById('theme-toggle-btn');
const fullscreenBtn = document.getElementById('fullscreen-btn');
const fullscreenIcon = fullscreenBtn ? fullscreenBtn.querySelector('i') : null;

const navLinks = document.querySelectorAll('.sidebar .main-item, .sidebar .sub-menu a');
const mobileOverlay = document.getElementById('overlay');

// Constant for storage key for fullscreen persistence
const FULLSCREEN_STORAGE_KEY = 'montfort_is_fullscreen';

// =========================================================================
// 1. SPA ROUTING LOGIC
// =========================================================================

function handleNavigate(targetModule) {
    if (!targetModule) return;
    activeModule = targetModule;

    // 1. Hide all modules
    document.querySelectorAll('.module').forEach(module => {
        module.style.display = 'none';
    });

    // 2. Show the target module container
    // Matches IDs like "admission-module", "list-module", "dashboard-module"
    const targetEl = document.getElementById(`${targetModule}-module`);
    if (targetEl) {
        targetEl.style.display = 'block';
        
        // 3. Lazy Load Data triggers (Interacts with functions in student.js)
        // Check if the function exists on window before calling
        if (targetModule === 'list' && typeof window.loadStudentList === 'function') {
            const listContainer = document.getElementById('student-list-results');
            // Load if empty or to ensure fresh data
            if (listContainer && !listContainer.hasChildNodes()) {
                window.loadStudentList();
            }
        }
        if (targetModule === 'summary' && typeof window.loadSummary === 'function') {
            const summaryContainer = document.getElementById('summary-results');
            if (summaryContainer && !summaryContainer.hasChildNodes()) {
                window.loadSummary();
            }
        }
    } else {
        console.warn(`Module container #${targetModule}-module not found.`);
    }

    // 4. Update Browser History (without reload)
    if(history.pushState) {
        history.pushState(null, null, '#' + targetModule);
    } else {
        window.location.hash = targetModule;
    }

    // 5. Update UI Active States in Sidebar
    navLinks.forEach(link => {
        link.classList.remove('active');

        // Check for direct data-menu link or href match
        // Also handle the case where the link might be inside the li
        if (link.dataset.menu === targetModule || link.getAttribute('href') === '#' + targetModule) {
            link.classList.add('active');
            
            // Handle Accordion State (Expand parent submenu)
            const parentMenuListItem = link.closest('li');
            if (parentMenuListItem) {
                const subMenu = parentMenuListItem.closest('.sub-menu');
                if (subMenu) {
                    subMenu.classList.add('show');
                    // Highlight the parent trigger
                    const parentTrigger = subMenu.previousElementSibling;
                    if (parentTrigger) parentTrigger.classList.add('active');
                }
            }
        }
    });

    // Mobile specific: Close sidebar on navigation
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
        
        if(menuIcon) {
            menuIcon.className = isSidebarOpen ? 'fa fa-times' : 'fa fa-bars'; 
        }
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
        }).catch(err => console.error("Failed to enter fullscreen:", err));
        fullscreenIcon.className = 'fa-solid fa-compress';
    } else {
        if (document.exitFullscreen) {
            document.exitFullscreen().then(() => {
                localStorage.removeItem(FULLSCREEN_STORAGE_KEY);
            }).catch(err => console.error("Failed to exit fullscreen:", err));
            fullscreenIcon.className = 'fa-solid fa-expand';
        }
    }
}

function restoreFullscreen() {
    if (localStorage.getItem(FULLSCREEN_STORAGE_KEY) === 'true') {
        setTimeout(() => {
             document.documentElement.requestFullscreen().then(() => {
                if (fullscreenIcon) fullscreenIcon.className = 'fa-solid fa-compress';
            }).catch(err => {
                console.warn("Fullscreen restore failed (user interaction required). Clearing state.", err);
                localStorage.removeItem(FULLSCREEN_STORAGE_KEY);
                if (fullscreenIcon) fullscreenIcon.className = 'fa-solid fa-expand';
            });
        }, 100);
    }
}

function handleAccordion(e){
    // 1. Prevent default scroll jump behavior
    e.preventDefault();

    // Determine if the clicked element is a link or a menu toggle
    const item = e.currentTarget;
    const subMenu = item.nextElementSibling;
    
    const isDesktopCollapsed = (window.innerWidth > 768 && !isSidebarOpen);
    
    // CASE A: It is a Sub-Menu Toggle (has a sibling .sub-menu)
    if (subMenu && subMenu.classList.contains('sub-menu')) {
        
        if (isDesktopCollapsed) {
            toggleSidebar(); // Auto-expand sidebar if collapsed
        }

        // Close other open menus
        if (openMenu && openMenu !== subMenu) {
            openMenu.classList.remove('show'); 
        }
        
        // Toggle current menu
        if(subMenu.classList.contains('show')) {
            subMenu.classList.remove('show');
            openMenu = null;
        } else {
            subMenu.classList.add('show');
            openMenu = subMenu;
        }
    } 
    // CASE B: It is a direct link (Dashboard or Sub-menu Item)
    else {
        // Priority 1: Check for data-menu attribute (used by main items like Dashboard)
        if (item.dataset.menu) {
            handleNavigate(item.dataset.menu);
        } 
        // Priority 2: Check for href attribute (used by sub-menu links like #admission)
        else if (item.hasAttribute('href')) {
            const href = item.getAttribute('href');
            if (href && href.startsWith('#')) {
                // Remove the '#' and navigate
                const target = href.substring(1);
                handleNavigate(target);
            }
        }
    }
}

// =========================================================================
// 3. INITIALIZATION
// =========================================================================

document.addEventListener('DOMContentLoaded', () => {
    // Event Listeners
    if (menuToggle) menuToggle.addEventListener('click', toggleSidebar);
    if (mobileOverlay) mobileOverlay.addEventListener('click', toggleSidebar);
    if (settingsBtn) settingsBtn.addEventListener('click', toggleSettings);
    if (settingsCloseBtn) settingsCloseBtn.addEventListener('click', toggleSettings);
    if (themeToggleBtn) themeToggleBtn.addEventListener('click', toggleTheme);
    if (fullscreenBtn) fullscreenBtn.addEventListener('click', toggleFullscreen);

    // Sidebar Links & Accordion
    navLinks.forEach(link => {
        // Attach listener to both <a> (if wrapper) or .main-item
        link.addEventListener('click', handleAccordion);
    });
    
    // Initialize Sidebar State
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
    
    // Attempt to restore fullscreen preference
    restoreFullscreen();

    // Handle Initial Routing based on URL Hash
    const hash = window.location.hash.substring(1);
    handleNavigate(hash || 'dashboard');

    // Listen for browser back/forward buttons
    window.addEventListener('hashchange', () => {
        const newHash = window.location.hash.substring(1);
        handleNavigate(newHash);
    });
});