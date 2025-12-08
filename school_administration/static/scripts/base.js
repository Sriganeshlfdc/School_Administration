let isSidebarOpen = true;
let currentTheme = 'light';
let activeModule = 'dashboard';
let openMenu = null;
let isSettingsOpen = false;
const body = document.body;
const menuToggle = document.getElementById('menu-toggle');
const menuIcon = menuToggle ? menuToggle.querySelector('i'):null;
const sidebar = document.getElementById('sidebar');
const mainItems= document.querySelectorAll('.main-item');
const content = document.getElementById('content'); 
const moduleDisplay = document.getElementById('moduleDisplay'); 

const settingsBtn =document.getElementById('settings-btn');
const settingsPanel =document.getElementById('settings-panel');
const settingsCloseBtn =document.getElementById('settings-close-btn');

const themeToggleBtn =document.getElementById('theme-toggle-btn');
const fullscreenBtn=document.getElementById('fullscreen-btn');
const fullscreenIcon = fullscreenBtn ? fullscreenBtn.querySelector('i') : null;

const navLinks = document.querySelectorAll('.sidebar .main-item , .sidebar .sub-menu a');
const mobileOverlay = document.getElementById('overlay');

// NEW: Constant for storage key for fullscreen persistence
const FULLSCREEN_STORAGE_KEY = 'montfort_is_fullscreen';

function toggleSidebar() {
    if(!sidebar) return;
    isSidebarOpen = !isSidebarOpen;
    
    if(window.innerWidth <= 768) { 
        sidebar.classList.toggle('open',isSidebarOpen);
        if(mobileOverlay) mobileOverlay.classList.toggle('active',isSidebarOpen);
        sidebar.classList.remove('collapsed');
        
        // FIX: Toggle the icon based on the new state (fa-times for close)
        if(menuIcon) {
            menuIcon.className = isSidebarOpen ? 'fa fa-times' : 'fa fa-bars'; 
        }
    }
    else {
        // Desktop logic (already correct)
        sidebar.classList.toggle('collapsed', !isSidebarOpen);
        if(content) content.classList.toggle('collapsed', !isSidebarOpen);
        if(menuIcon) menuIcon.className = isSidebarOpen? 'fa fa-chevron-left' : 'fa fa-bars';
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
            // PERSISTENCE: Save state on success
            localStorage.setItem(FULLSCREEN_STORAGE_KEY, 'true');
        }).catch(err => {
            console.error("Failed to enter fullscreen:", err);
        });
        fullscreenIcon.className = 'fa-solid fa-compress';
    } else {
        if (document.exitFullscreen) {
            document.exitFullscreen().then(() => {
                // PERSISTENCE: Clear state on exit
                localStorage.removeItem(FULLSCREEN_STORAGE_KEY);
            }).catch(err => {
                console.error("Failed to exit fullscreen:", err);
            });
            fullscreenIcon.className = 'fa-solid fa-expand';
        }
    }
}

// NEW: Function to restore fullscreen state on page load
function restoreFullscreen() {
    // Only attempt to restore if the state is marked as true in local storage
    if (localStorage.getItem(FULLSCREEN_STORAGE_KEY) === 'true') {
        // We use a small delay here to ensure the browser registers the click event handler
        // before the automatic re-entry request, which sometimes allows it to work.
        setTimeout(() => {
             document.documentElement.requestFullscreen().then(() => {
                if (fullscreenIcon) {
                     fullscreenIcon.className = 'fa-solid fa-compress';
                }
            }).catch(err => {
                console.warn("Fullscreen state was persisted but failed to restore on load. Clearing state.", err);
                // If restore fails, ensure local storage and icon are reset
                localStorage.removeItem(FULLSCREEN_STORAGE_KEY);
                if (fullscreenIcon) {
                     fullscreenIcon.className = 'fa-solid fa-expand';
                }
            });
        }, 100);
    }
}


function handleNavigate(targetModule){
    if (!targetModule) return;
    activeModule = targetModule;

    // --- MODULE DISPLAY LOGIC ---
    const allModules = document.querySelectorAll('.module');
    // Modules use the ID format: [hash]-module (e.g., #list -> list-module)
    const targetModuleId = `${targetModule}-module`; 
    
    // 1. Hide all modules
    allModules.forEach(module => {
        module.style.display = 'none';
    });

    // 2. Show the target module
    const moduleToShow = document.getElementById(targetModuleId);
    if (moduleToShow) {
        moduleToShow.style.display = 'block'; 
    } else {
        console.warn(`Module container element not found for hash: #${targetModule}`);
    }
    // --- END MODULE DISPLAY LOGIC ---

    if(history.pushState) {
        history.pushState(null,null,'#' + targetModule);
    } else {
        window.location.hash = targetModule;
    }
    if(moduleDisplay) {
        moduleDisplay.textContent= `#${targetModule}`;
    }
    navLinks.forEach(link => {
        link.classList.remove('active');

        // Check for direct data-menu link
        if(link.dataset.menu === targetModule){
            link.classList.add('active');
        }
        
        // Handle sub-menu navigation links
        const linkId =link.id;
        let linkMod = null;
        if(linkId === 'addstudent') linkMod ='admission'; 
        if(linkId === 'viewstudent') linkMod ='list'; // Maps 'viewstudent' link to '#list' hash
        if(['summary','quickedit','academicedit', 'searchstudent', 'studentaccounts', 'oldstudentdebt', 'oldstudentrec', 'migrate'].includes(linkId)){ 
            linkMod = linkId
        }

        if(linkMod && linkMod === targetModule){
            link.classList.add('active');
            // Corrected logic to find the parent accordion header and open it
            const parentMenuListItem = link.closest('li');
            if (parentMenuListItem) {
                // Find the main-item button (which is the previous sibling of the .sub-menu)
                const parentMenu = parentMenuListItem.closest('.sub-menu').previousElementSibling; 
                if(parentMenu) {
                    parentMenu.classList.add('active');
                    // Also ensure the submenu opens
                    const subMenu = parentMenu.nextElementSibling;
                    if (subMenu) {
                        // FIX: Use classList for persistence across hash changes
                        subMenu.classList.add('show');
                        openMenu = subMenu;
                    }
                }
            }
        }
    });
    // Use 768px for consistency in mobile width check
    if (window.innerWidth <= 768 && isSidebarOpen) { 
        toggleSidebar();
    }
}

function handleAccordion(e){
    
    const item = e.currentTarget;
    const subMenu = item.nextElementSibling;
    
    // Determine if the sidebar is currently collapsed on a desktop screen
    const isDesktopCollapsed = (window.innerWidth > 768 && !isSidebarOpen);
    
    // 1. Handle direct links (Dashboard/Logout - which are wrapped in <a>)
    if(item.tagName === 'A') {
        // If the item itself is an anchor tag wrapping a button, we don't handle accordion logic here.
        // The browser handles the page navigation.
        
        // NEW FEATURE: Expand sidebar when a collapsed icon is clicked, then let the navigation proceed
        // NOTE: This logic targets the nested <button> within the <a>
        const nestedButton = item.querySelector('.main-item');
        if (nestedButton && isDesktopCollapsed) {
            toggleSidebar();
        }

        mainItems.forEach (i => i.classList.remove('active'));
        item.querySelector('.main-item').classList.add('active');
        // Let the browser handle the navigation via href
        return;
    }
    
    // 2. Handle Accordion Items (buttons with data-menu)
    if (subMenu) {
         // NEW FEATURE: Expand sidebar when a collapsed icon is clicked
        if (isDesktopCollapsed) {
            toggleSidebar(); 
            // Do not return here, allow the logic below to run to open the submenu immediately after expanding.
        }

        // Check if another menu is open and close it
        if (openMenu && openMenu !== subMenu) {
            // FIX: Use classList.remove instead of style.display
            openMenu.classList.remove('show'); 
        }
        
        // Toggle the current submenu
        if(subMenu.classList.contains('show')) {
             // FIX: Use classList.remove instead of style.display
            subMenu.classList.remove('show');
            openMenu = null;
        } else {
             // FIX: Use classList.add instead of style.display
            subMenu.classList.add('show');
            openMenu =subMenu;
        }

    } else {
        // Handle direct navigation for buttons without sub-menu (like Log Out on non-main pages)
        handleNavigate(item.dataset.menu);
        mainItems.forEach (i => i.classList.remove('active'));
        item.classList.add('active');
    }
}

document.addEventListener('DOMContentLoaded', () => {
    // Adding safety checks to prevent errors if elements are null
    if (menuToggle) menuToggle.addEventListener('click',toggleSidebar);
    if (mobileOverlay) mobileOverlay.addEventListener('click',toggleSidebar);
    if (settingsBtn) settingsBtn.addEventListener('click', toggleSettings);
    if (settingsCloseBtn) settingsCloseBtn.addEventListener('click', toggleSettings);
    if (themeToggleBtn) themeToggleBtn.addEventListener('click', toggleTheme);
    
    // FIX: Only bind toggleFullscreen to the fullscreen button itself
    if (fullscreenBtn) fullscreenBtn.addEventListener('click', toggleFullscreen);

    // FIX: Attach event listener to the <a> tag for Dashboard
    navLinks.forEach(link => {
        // If it's a link wrapper around a button (like Dashboard) or a submenu link
        if (link.tagName === 'A' || link.classList.contains('main-item')) {
            link.addEventListener('click', handleAccordion);
        }
    });
    
    // Initial sidebar state setup 
    if(sidebar) {
        // Use 768px for consistent mobile breakpoint
        if(window.innerWidth <= 768) { 
            isSidebarOpen =false;
            sidebar.classList.remove('open');
            sidebar.classList.add('collapsed'); 
            // FIX: Set initial icon to fa-bars (closed)
            if (menuIcon) menuIcon.className ='fa fa-bars' ;
        }
        else {
            isSidebarOpen = true;
            sidebar.classList.remove('collapsed');
            if (content) content.classList.remove('collapsed');
            if (menuIcon) menuIcon.className = 'fa fa-chevron-left';
        }
    }
    
    // Initial navigation handling
    const hash = window.location.hash.substring(1);
    if(hash) {
        handleNavigate(hash);
    } else {
        // Default to 'dashboard' if no hash is set.
        handleNavigate('dashboard');
    }

    // Use the *new* hash value on change
    window.addEventListener('hashchange', ()=> {
        const newHash = window.location.hash.substring(1);
        handleNavigate(newHash);
    });
    
    // NEW: Restore fullscreen state on page load
    restoreFullscreen();
});