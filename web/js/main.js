document.addEventListener('DOMContentLoaded', function() {
    initializeSidebar();
    initializeTheme();
    initializeFlashMessages();
    initializeModals();
});

function initializeSidebar() {
    const sidebar = document.getElementById('sidebar');
    const sidebarToggle = document.getElementById('sidebarToggle');
    
    if (sidebarToggle && sidebar) {
        sidebarToggle.addEventListener('click', function() {
            sidebar.classList.toggle('collapsed');
            localStorage.setItem('sidebarCollapsed', sidebar.classList.contains('collapsed'));
        });
        
        const savedState = localStorage.getItem('sidebarCollapsed');
        if (savedState === 'true') {
            sidebar.classList.add('collapsed');
        }
    }
    
    const mediaQuery = window.matchMedia('(max-width: 768px)');
    handleMobileView(mediaQuery);
    mediaQuery.addEventListener('change', handleMobileView);
}

function handleMobileView(mediaQuery) {
    const sidebar = document.getElementById('sidebar');
    if (!sidebar) return;
    
    if (mediaQuery.matches) {
        sidebar.classList.add('mobile');
        document.querySelector('.main-content').addEventListener('click', function() {
            sidebar.classList.remove('show');
        });
        document.getElementById('sidebarToggle').addEventListener('click', function(e) {
            e.stopPropagation();
            sidebar.classList.toggle('show');
        });
    } else {
        sidebar.classList.remove('mobile', 'show');
    }
}

function initializeTheme() {
    const themeToggle = document.getElementById('themeToggle');
    if (themeToggle) {
        themeToggle.addEventListener('click', function() {
            toggleTheme();
        });
        const savedTheme = localStorage.getItem('theme');
        if (savedTheme) {
            document.documentElement.setAttribute('data-theme', savedTheme);
            updateThemeIcon(savedTheme);
        }
    }
}

function toggleTheme() {
    const currentTheme = document.documentElement.getAttribute('data-theme') || 'light';
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', newTheme);
    localStorage.setItem('theme', newTheme);
    updateThemeIcon(newTheme);
    if (window.DashboardUtils) {
        window.DashboardUtils.updateChartsForTheme(newTheme);
    }
}

function updateThemeIcon(theme) {
    const themeToggle = document.getElementById('themeToggle');
    if (themeToggle) {
        const icon = themeToggle.querySelector('i');
        if (icon) {
            icon.className = theme === 'dark' ? 'fas fa-sun' : 'fas fa-moon';
        }
    }
}

function initializeFlashMessages() {
    const flashMessages = document.querySelectorAll('.flash-message');
    flashMessages.forEach(function(message) {
        const closeBtn = message.querySelector('.flash-close');
        if (closeBtn) {
            closeBtn.addEventListener('click', function() {
                hideFlashMessage(message);
            });
        }
        setTimeout(function() {
            hideFlashMessage(message);
        }, 5000);
    });
}

function hideFlashMessage(message) {
    if (message && message.parentNode) {
        message.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
        message.style.opacity = '0';
        message.style.transform = 'translateX(100%)';
        setTimeout(function() {
            if (message.parentNode) {
                message.remove();
            }
        }, 300);
    }
}

function initializeModals() {
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('modal')) {
            closeModal(e.target);
        }
    });
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            const openModal = document.querySelector('.modal.show');
            if (openModal) {
                closeModal(openModal);
            }
        }
    });
    document.querySelectorAll('.modal-close').forEach(function(button) {
        button.addEventListener('click', function() {
            const modal = button.closest('.modal');
            if (modal) {
                closeModal(modal);
            }
        });
    });
}

function closeModal(modal) {
    if (typeof modal === 'string') {
        modal = document.getElementById(modal);
    }
    if (modal) {
        modal.classList.remove('show');
        const form = modal.querySelector('form');
        if (form) {
            form.reset();
        }
    }
}

function openModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.classList.add('show');
        const firstInput = modal.querySelector('input:not([type="hidden"]), select, textarea');
        if (firstInput) {
            setTimeout(() => firstInput.focus(), 100);
        }
    }
}

function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND',
        minimumFractionDigits: 0
    }).format(amount);
}

function formatDate(date) {
    if (typeof date === 'string') {
        date = new Date(date);
    }
    return new Intl.DateTimeFormat('vi-VN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit'
    }).format(date);
}

function formatDateTime(date) {
    if (typeof date === 'string') {
        date = new Date(date);
    }
    return new Intl.DateTimeFormat('vi-VN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
    }).format(date);
}

function confirmDelete(message = 'Bạn có chắc chắn muốn xóa?') {
    return confirm(message);
}

function showLoading(element) {
    if (typeof element === 'string') {
        element = document.querySelector(element);
    }
    if (element) {
        element.disabled = true;
        const originalText = element.textContent;
        element.setAttribute('data-original-text', originalText);
        element.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
    }
}

function hideLoading(element) {
    if (typeof element === 'string') {
        element = document.querySelector(element);
    }
    if (element) {
        element.disabled = false;
        const originalText = element.getAttribute('data-original-text');
        if (originalText) {
            element.textContent = originalText;
            element.removeAttribute('data-original-text');
        }
    }
}

function validateEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}

function validatePhone(phone) {
    const re = /^[0-9\-\+\s\(\)]+$/;
    return re.test(phone) && phone.length >= 10;
}

function validateRequired(value) {
    return value && value.trim().length > 0;
}

function createSearchFilter(searchInput, items, searchFields) {
    if (!searchInput || !items) return;
    searchInput.addEventListener('input', function() {
        const searchTerm = this.value.toLowerCase().trim();
        items.forEach(function(item) {
            let shouldShow = !searchTerm;
            searchFields.forEach(function(field) {
                const value = item.getAttribute(field);
                if (value && value.toLowerCase().includes(searchTerm)) {
                    shouldShow = true;
                }
            });
            item.style.display = shouldShow ? '' : 'none';
        });
    });
}

function createSelectFilter(selectElement, items, dataAttribute) {
    if (!selectElement || !items) return;
    selectElement.addEventListener('change', function() {
        const selectedValue = this.value;
        items.forEach(function(item) {
            const itemValue = item.getAttribute(dataAttribute);
            const shouldShow = !selectedValue || itemValue === selectedValue;
            item.style.display = shouldShow ? '' : 'none';
        });
    });
}

function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `flash-message flash-${type}`;
    notification.innerHTML = `
        <i class="fas fa-${getNotificationIcon(type)}"></i>
        ${message}
        <button class="flash-close">×</button>
    `;
    const container = document.querySelector('.flash-messages') || document.querySelector('.content-body');
    if (container) {
        if (container.classList.contains('content-body')) {
            const flashContainer = document.createElement('div');
            flashContainer.className = 'flash-messages';
            container.insertBefore(flashContainer, container.firstChild);
            flashContainer.appendChild(notification);
        } else {
            container.appendChild(notification);
        }
        const closeBtn = notification.querySelector('.flash-close');
        if (closeBtn) {
            closeBtn.addEventListener('click', function() {
                hideFlashMessage(notification);
            });
        }
        setTimeout(function() {
            hideFlashMessage(notification);
        }, 5000);
    }
}

function getNotificationIcon(type) {
    switch (type) {
        case 'success': return 'check-circle';
        case 'error': return 'exclamation-triangle';
        case 'warning': return 'exclamation-triangle';
        case 'info': return 'info-circle';
        default: return 'info-circle';
    }
}

window.AppUtils = {
    closeModal,
    openModal,
    formatCurrency,
    formatDate,
    formatDateTime,
    confirmDelete,
    showLoading,
    hideLoading,
    validateEmail,
    validatePhone,
    validateRequired,
    createSearchFilter,
    createSelectFilter,
    showNotification
};