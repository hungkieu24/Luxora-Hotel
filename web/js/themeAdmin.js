document.addEventListener('DOMContentLoaded', function() {
    initializeRoomManagement();
});



function initializeRoomManagement() {
    initializeViewToggle();
    initializeFilters();
//    initializeRoomActions();
}

function initializeViewToggle() {
    const viewButtons = document.querySelectorAll('.view-btn');
    const roomsGrid = document.getElementById('roomsGrid');
    const roomsTable = document.getElementById('roomsTable');
    
    if (!viewButtons.length || !roomsGrid || !roomsTable) return;
    
    viewButtons.forEach(button => {
        button.addEventListener('click', function() {
            const view = this.getAttribute('data-view');
            viewButtons.forEach(btn => btn.classList.remove('active'));
            this.classList.add('active');
            if (view === 'grid') {
                roomsGrid.style.display = 'grid';
                roomsTable.style.display = 'none';
            } else {
                roomsGrid.style.display = 'none';
                roomsTable.style.display = 'block';
            }
            localStorage.setItem('roomViewMode', view);
        });
    });
    
    const savedView = localStorage.getItem('roomViewMode');
    if (savedView) {
        document.querySelector(`[data-view="${savedView}"]`).click();
    }
}

function initializeFilters() {
    const statusFilter = document.getElementById('statusFilter');
    const typeFilter = document.getElementById('typeFilter');
    
    if (statusFilter) {
        statusFilter.addEventListener('change', applyFilters);
    }
    if (typeFilter) {
        typeFilter.addEventListener('change', applyFilters);
    }
}

function updateEmptyState() {
    const visibleCards = document.querySelectorAll('.room-card:not([style*="display: none"])');
    const visibleRows = document.querySelectorAll('.rooms-table tbody tr:not([style*="display: none"])');
    const emptyState = document.querySelector('.empty-state');
    if (emptyState) {
        emptyState.style.display = (visibleCards.length > 0 || visibleRows.length > 0) ? 'none' : 'block';
    }
}

function initializeRoomActions() {
    document.querySelectorAll('.room-status, .status-badge').forEach(badge => {
        badge.addEventListener('click', function(e) {
            e.stopPropagation();
            const roomElement = this.closest('.room-card, tr');
            if (roomElement) {
                showQuickStatusUpdate(roomElement);
            }
        });
    });
}

function openAddRoomModal() {
    const modal = document.getElementById('roomModal');
    const form = document.getElementById('roomForm');
    const title = document.getElementById('modalTitle');
    
    if (modal && form && title) {
        title.textContent = 'Thêm phòng mới';
        form.reset();
        document.getElementById('status').value = 'Available';
        modal.classList.add('show');
        const firstInput = form.querySelector('input');
        if (firstInput) {
            setTimeout(() => firstInput.focus(), 100);
        }
    }
}

document.addEventListener('DOMContentLoaded', function() {
    const roomForm = document.getElementById('roomForm');
    if (roomForm) {
        roomForm.addEventListener('submit', function(e) {
            e.preventDefault();
            if (validateRoomForm()) {
                const formData = new FormData(roomForm);
                const roomId = roomForm.dataset.roomId;
                const newRoom = {
                    id: roomId ? parseInt(roomId) : roomsData.length + 1,
                    room_number: formData.get('room_number'),
                    room_type: formData.get('room_type'),
                    status: formData.get('status'),
                    price: parseInt(formData.get('price')),
                    capacity: parseInt(formData.get('capacity')),
                    amenities: formData.get('amenities'),
                    description: formData.get('description'),
                    updated_at: new Date().toISOString().split('T')[0]
                };
                
                if (roomId) {
                    const index = roomsData.findIndex(r => r.id === parseInt(roomId));
                    roomsData[index] = newRoom;
                    window.AppUtils.showNotification('Cập nhật phòng thành công', 'success');
                } else {
                    roomsData.push(newRoom);
                    window.AppUtils.showNotification('Thêm phòng thành công', 'success');
                }
                
                // Update UI (thêm vào grid và table)
                updateRoomUI(newRoom, !!roomId);
                closeModal();
            }
        });
    }
});

function updateRoomUI(room, isUpdate) {
    const grid = document.getElementById('roomsGrid');
    const tableBody = document.querySelector('.rooms-table tbody');
    
    const card = document.createElement('div');
    card.className = 'room-card';
    card.setAttribute('data-status', room.status);
    card.setAttribute('data-type', room.room_type);
    card.setAttribute('data-room', room.room_number);
    card.setAttribute('data-room-id', room.id);
    card.innerHTML = `
        <div class="room-header">
            <div class="room-number">${room.room_number}</div>
            <div class="room-status status-${room.status.toLowerCase()}">${getStatusLabel(room.status)}</div>
        </div>
        <div class="room-info">
            <h4>${room.room_type}</h4>
            <div class="room-details">
                <div class="detail-item">
                    <i class="fas fa-dollar-sign"></i>
                    <span>${window.AppUtils.formatCurrency(room.price)}</span>
                </div>
                <div class="detail-item">
                    <i class="fas fa-users"></i>
                    <span>${room.capacity} người</span>
                </div>
            </div>
            ${room.amenities ? `<div class="amenities"><small>${room.amenities}</small></div>` : ''}
            ${room.description ? `<div class="description"><small>${room.description.slice(0, 100)}${room.description.length > 100 ? '...' : ''}</small></div>` : ''}
        </div>
        <div class="room-actions">
            <button class="btn btn-sm btn-secondary" onclick="editRoom(${room.id})">
                <i class="fas fa-edit"></i>
                Sửa
            </button>
            <button class="btn btn-sm btn-danger" onclick="deleteRoom(${room.id})">
                <i class="fas fa-trash"></i>
                Xóa
            </button>
        </div>
    `;
    
    const row = document.createElement('tr');
    row.setAttribute('data-status', room.status);
    row.setAttribute('data-type', room.room_type);
    row.setAttribute('data-room', room.room_number);
    row.setAttribute('data-room-id', room.id);
    row.innerHTML = `
        <td><strong>${room.room_number}</strong></td>
        <td>${room.room_type}</td>
        <td><span class="status-badge status-${room.status.toLowerCase()}">${getStatusLabel(room.status)}</span></td>
        <td>${window.AppUtils.formatCurrency(room.price)}</td>
        <td>${room.capacity} người</td>
        <td>${room.updated_at}</td>
        <td>
            <button class="btn btn-sm btn-secondary" onclick="editRoom(${room.id})">
                <i class="fas fa-edit"></i>
            </button>
            <button class="btn btn-sm btn-danger" onclick="deleteRoom(${room.id})">
                <i class="fas fa-trash"></i>
            </button>
        </td>
    `;
    
    if (isUpdate) {
        document.querySelector(`.room-card[data-room-id="${room.id}"]`)?.replaceWith(card);
        document.querySelector(`tr[data-room-id="${room.id}"]`)?.replaceWith(row);
    } else {
        grid.appendChild(card);
        tableBody.appendChild(row);
    }
    
    updateEmptyState();
    initializeRoomActions();
}

document.addEventListener('keydown', function(e) {
    if ((e.ctrlKey || e.metaKey) && e.key === 'n') {
        e.preventDefault();
        openAddRoomModal();
    }
    if (e.key === 'Escape') {
        closeModal();
    }
});

window.RoomUtils = {
    openAddRoomModal,
    editRoom,
    deleteRoom,
    closeModal,
    updateRoomStatus,
    applyFilters
};