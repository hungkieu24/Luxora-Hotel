<%-- 
    Document   : roomManage
    Created on : Jun 4, 2025, 12:59:05 AM
    Author     : thien
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manager rooms</title>
        <link rel="stylesheet" href="./css/managerStyle.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>

    <body>
        <div class="app-container">
            <!-- Sidebar (giữ nguyên như index.html) -->
            <nav class="sidebar" id="sidebar">
                <!-- ... (tương tự sidebar trong index.html, chỉ thay active class cho menu-item Quản lý Phòng) -->
                <div class="sidebar-header">

                    <button class="sidebar-toggle" id="sidebarToggle">
                        <div class="brand">
                            <i class="fas fa-building"></i>
                            <span class="brand-text">${branchname}</span>
                        </div>

                    </button>
                </div>
                <div class="sidebar-menu">
                    <a href="#" class="menu-item ">
                        <i class="fas fa-chart-line"></i>
                        <span class="menu-text">Dashboard</span>
                    </a>
                    <a href="/rooms" class="menu-item active">
                        <i class="fas fa-bed"></i>
                        <span class="menu-text">Manage room</span>
                    </a>
                    <a href="#" class="menu-item">
                        <i class="fas fa-comments"></i>
                        <span class="menu-text">Manage feedback</span>
                    </a>
                    <a href="#" class="menu-item">
                        <i class="fas fa-concierge-bell"></i>
                        <span class="menu-text">Manage service</span>
                    </a>
                    <a href="#" class="menu-item">
                        <i class="fas fa-tags"></i>
                        <span class="menu-text">Manage promotion</span>
                    </a>
                    <a href="#" class="menu-item">
                        <i class="fas fa-users"></i>
                        <span class="menu-text">Manage membership</span>
                    </a>
                    <a href="#" class="menu-item logout">
                        <i class="fas fa-sign-out-alt"></i>
                        <span class="menu-text">logout</span>
                    </a>
                </div>
            </nav>

            <!-- Main Content -->
            <main class="main-content">
                <header class="content-header">
                    <div class="header-left">
                        <h1 class="page-title">Manage room</h1>
                    </div>
                    <div class="header-right">
                        <!-- <button class="theme-toggle" id="themeToggle">
                            <i class="fas fa-moon"></i>
                        </button> -->
                        <!-- Có thể thêm một số icon như thông báo hay light or dark -->
                        <div class="user-info"> <!-- thể hiện user info -->
                            <i class="fas fa-user-circle"></i>
                            <span>${username}</span>
                        </div>
                    </div>
                </header>

                <div class="flash-messages" id="flashMessages">
                    <c:if test="${not empty error}">
                        <div class="flash-message flash-error">
                            ${error}
                            <div class="flash-close">x</div>
                        </div>
                    </c:if>
                </div>

                <div class="content-body">
                    <div class="rooms-container">
                        <div class="page-actions">
                            <!--Thanh search-->
                            <form action="searchRooms" method="get">
                                <div class="search-box">
                                    <i class="fas fa-search"></i>
                                    <input type="text" id="roomSearch" name="search" placeholder="Search rooms..." value="${param.search}" onchange="this.form.submit()">
                                </div>
                            </form>
                            <div class="view-toggle">
                                <button class="view-btn active" data-view="grid">
                                    <i class="fas fa-th"></i>
                                </button>
                                <button class="view-btn" data-view="table">
                                    <i class="fas fa-list"></i>
                                </button>
                            </div>
                            <form action="rooms" method="post" enctype="multipart/form-data" style="display: inline;">
                                <input type="hidden" name="branchId" value="${branchId}">
                                <button class="btn btn-primary" onclick="openAddRoomModal()">
                                    <i class="fas fa-plus"></i>
                                    Add new room
                                </button>
                            </form>
                        </div>
                                <!--search bằng fillter-->
                        <form action="searchRooms" method="get">
                            <div class="filters">

                                <select id="statusFilter" name="status" onchange="this.form.submit()">
                                    <option value=""> All Status</option>
                                    <option value="Available"${param.status == 'Available' ? 'selected' : ''}>Available</option>
                                    <option value="Occupied" ${param.status == 'Occupied' ? 'selected' : ''}>Occupied</option>
                                    <option value="Booked" ${param.status == 'Booked' ? 'selected' : ''}>Booked</option>
                                    <option value="Maintenance" ${param.status == 'Maintenance' ? 'selected' : ''}>Maintenance</option>
                                </select>
                                <select id="typeFilter"name="roomType" onchange="this.form.submit()">
                                    <option value="">All Room Type</option>
                                    <c:forEach var="roomtype" items="${roomtypes}">
                                        <option value="${roomtype.roomTypeID}">
                                            <c:if test="${param.roomType == roomtype.roomTypeID}">selected</c:if>
                                            ${roomtype.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </form>
                        <!-- Xem lại đoạn này để code backend -->
                        <div class="rooms-grid" id="roomsGrid" style="display: none;">
                            <c:if test="${not empty rooms}">
                                <c:forEach var="room" items="${rooms}">
                                    <div class="room-card" data-status="${room.status}" data-type="${room.roomType.name}" data-room="${room.roomNumber}"
                                         data-room-id="${room.id}">
                                        <div class="room-header">
                                            <div class="room-number">${room.roomNumber}</div>
                                            <div class="room-status status-${room.status.toLowerCase()}">${room.status}</div>
                                        </div>
                                        <div class="room-info">
                                            <h4>${room.roomType.name}</h4>
                                            <div class="room-details">
                                                <div class="detail-item">
                                                    <i class="fas fa-dollar-sign"></i>
                                                    <span>${room.roomType.base_price} VNĐ</span>
                                                </div>
                                                <div class="detail-item">
                                                    <i class="fas fa-users"></i>
                                                    <span>${room.roomType.capacity} người</span>
                                                </div>
                                            </div>
                                            <div class="amenities">
                                                <small>${room.roomType.description}</small>
                                            </div>
                                        </div>
                                        <div class="room-actions">
                                            <button class="btn btn-sm btn-secondary" onclick="editRoom(${room.id})">
                                                <i class="fas fa-edit"></i>
                                                Edit
                                            </button>
                                            <button class="btn btn-sm btn-danger" onclick="deleteRoom(${room.id})">
                                                <i class="fas fa-trash"></i>
                                                Delete
                                            </button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:if>\
                            <c:if test="empty rooms">
                                <div class="empty-state">
                                    <i class="fas fa-bed">
                                        <h3>Don't see room</h3>
                                        <p>Can you create new room</p>
                                </div>
                            </c:if>
                            <!-- Thêm các phòng mẫu khác nếu cần -->
                        </div>

                        <div class="rooms-table" id="roomsTable" ">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Room number</th>
                                        <th>Room type</th>
                                        <th>Status</th>
                                        <th>Price</th>
                                        <th>Capacity</th>
                                        <th>Image</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="room" items="${rooms}">
                                        <tr data-status="${room.status}" data-type="${room.roomType.name}" data-room="${room.roomNumber}" data-room-id="${room.id}">
                                            <!-- đoạn này sẽ lấy data từ backend -->
                                            <td><strong>${room.roomNumber}</strong></td>
                                            <td>${room.roomType.name}</td>
                                            <td><span class="status-badge status-available">${room.status}</span></td>
                                            <td>${room.roomType.base_price} VNĐ</td>
                                            <td>${room.roomType.capacity} người</td>
                                            <td>
                                                <img src="${room.imageUrl}" alt="Room Image" width="100" height="70", style="object-fit: cover; border-radius: 8px"/>
                                            </td>
                                            <td>
                                                <button class="btn btn-sm btn-secondary" onclick="editRoom(${room.id})">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="btn btn-sm btn-danger" onclick="deleteRoom(${room.id})">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <div class="modal" id="roomModal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="modalTitle">Add new room</h3>
                    <button class="modal-close" onclick="closeModal()">×</button>
                </div>
                <form id="roomForm" action="rooms" method="post" enctype="multipart/form-data">
                    <div class="modal-body">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="room_number">Room number *</label>
                                <input type="text" id="room_number" name="room_number"required>
                            </div>
                            <div class="form-group">
                                <label for="room_type">Room type *</label>
                                <select id="room_type" name="room_type" required>
                                    <option value="">Select room type</option>
                                    <c:forEach var="roomtype" items="${roomtypes}">
                                        <option value="${roomtype.roomTypeID}">${roomtype.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="status">Status *</label>
                                <select id="status" name="status" required>
                                    <option value="Available">Available</option>
                                    <option value="Occupied">Booked</option>
                                    <option value="Maintenance">Maintenance</option>
                                    <option value="Cleaning">Locked</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="capacity">Capacity *</label>
                                <input type="number" id="capacity" name="capacity" min="1" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="price">Price (VNĐ) *</label>
                            <input type="number" id="price" name="price" min="0" step="1000" required>
                        </div>
                        <div class="form-group">
                            <label for="image">Image *</label>
                            <input type="file" id="image" name="image" accept="image/*" required>
                        </div>
                        <div class="form-group">
                            <label for="description">Description</label>
                            <textarea id="description" name="description" rows="3"
                                      placeholder="Mô tả chi tiết về phòng..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i>
                            Save
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

<!--    <script src="./js/managerMain.js"></script>
    <script src="./js/managerRooms.js"></script>-->
</body>

</html>
