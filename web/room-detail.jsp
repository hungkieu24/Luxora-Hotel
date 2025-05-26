<%-- 
    Document   : room-detail
    Created on : 26 thg 5, 2025, 01:02:04
    Author     : pc
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room Detail - ${room.roomNumber}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .room-image {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 10px;
        }
        .status-Available { color: #28a745; }
        .status-Booked { color: #dc3545; }
        .status-Maintenance { color: #ffc107; }
        .status-Locked { color: #17a2b8; }
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-edit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        .btn-delete {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            border: none;
        }
        .btn-status {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            border: none;
        }
        .info-badge {
            background: #e3f2fd;
            color: #1976d2;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            display: inline-block;
            margin: 0.25rem;
        }
    </style>
</head>
<body class="bg-light">
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="#">
                <i class="fas fa-hotel"></i> Hotel Management
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="rooms">All Rooms</a>
                <a class="nav-link" href="dashboard">Dashboard</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <!-- Alert Messages -->
        <c:if test="${param.message == 'updated'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle"></i> Room updated successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <c:if test="${param.message == 'statusUpdated'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle"></i> Room status updated successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Room Detail Card -->
        <div class="row">
            <div class="col-lg-8">
                <div class="card shadow-sm">
                    <div class="card-header">
                        <h4 class="mb-0">
                            <i class="fas fa-bed"></i> Room ${room.roomNumber} Details
                        </h4>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <c:choose>
                                    <c:when test="${not empty room.imageUrl}">
                                        <img src="${room.imageUrl}" alt="Room ${room.roomNumber}" class="room-image">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="room-image bg-light d-flex align-items-center justify-content-center">
                                            <i class="fas fa-image fa-3x text-muted"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <h5 class="text-primary">Room Information</h5>
                                    <div class="info-badge">
                                        <i class="fas fa-door-open"></i> Room Number: ${room.roomNumber}
                                    </div>
                                    <div class="info-badge">
                                        <i class="fas fa-building"></i> Branch ID: ${room.branchId}
                                    </div>
                                    <div class="info-badge">
                                        <i class="fas fa-bed"></i> Room Type ID: ${room.roomTypeId}
                                    </div>
                                </div>
                                
                                <div class="mb-4">
                                    <strong>Status:</strong>
                                    <span class="status-${room.status}">
                                        <i class="fas fa-circle"></i> 
                                        <c:choose>
                                            <c:when test="${room.status == 'Available'}">Available</c:when>
                                            <c:when test="${room.status == 'Booked'}">Booked</c:when>
                                            <c:when test="${room.status == 'Maintenance'}">Under Maintenance</c:when>
                                            <c:when test="${room.status == 'Locked'}">Locked</c:when>
                                            <c:otherwise>${room.status}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>

                                <div class="mb-3">
                                    <h6>Quick Status Update:</h6>
                                    <div class="btn-group-vertical w-100" role="group">
                                        <button type="button" class="btn btn-sm btn-outline-success mb-1" 
                                                onclick="updateStatus('Available')">
                                            <i class="fas fa-check"></i> Set Available
                                        </button>
                                        <button type="button" class="btn btn-sm btn-outline-danger mb-1" 
                                                onclick="updateStatus('Booked')">
                                            <i class="fas fa-user"></i> Booked
                                        </button>
                                        <button type="button" class="btn btn-sm btn-outline-warning mb-1" 
                                                onclick="updateStatus('Maintenance')">
                                            <i class="fas fa-tools"></i> Set Maintenance
                                        </button>
                                        <button type="button" class="btn btn-sm btn-outline-info" 
                                                onclick="updateStatus('Locked')">
                                            <i class="fas fa-broom"></i> Locked
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action Panel -->
            <div class="col-lg-4">
                <div class="card shadow-sm">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-cogs"></i> Actions
                        </h5>
                    </div>
                    <div class="card-body">
                        <button type="button" class="btn btn-edit btn-lg w-100 mb-3 text-white" 
                                data-bs-toggle="modal" data-bs-target="#editRoomModal">
                            <i class="fas fa-edit"></i> Edit Room
                        </button>
                        
                        <button type="button" class="btn btn-delete btn-lg w-100 mb-3 text-white" 
                                data-bs-toggle="modal" data-bs-target="#deleteRoomModal">
                            <i class="fas fa-trash"></i> Delete Room
                        </button>
                        
                        <hr>
                        
                        <div class="d-grid gap-2">
                            <a href="rooms" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left"></i> Back to Rooms
                            </a>
                            <a href="bookings?roomId=${room.id}" class="btn btn-outline-info">
                                <i class="fas fa-calendar"></i> View Room
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Room Info Card -->
                <div class="card shadow-sm mt-3">
                    <div class="card-header">
                        <h6 class="mb-0">
                            <i class="fas fa-info-circle"></i> Room Details
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="row text-center">
                            <div class="col-12 mb-3">
                                <div class="border-bottom pb-2">
                                    <h4 class="text-primary mb-0">${room.roomNumber}</h4>
                                    <small class="text-muted">Room Number</small>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="border-end">
                                    <h6 class="text-info mb-0">${room.branchId}</h6>
                                    <small class="text-muted">Branch ID</small>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <h6 class="text-success mb-0">${room.roomTypeId}</h6>
                                <small class="text-muted">Type ID</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Room Modal -->
    <div class="modal fade" id="editRoomModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form action="room-detail" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="${room.id}">
                    
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-edit"></i> Edit Room ${room.roomNumber}
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="roomNumber" class="form-label">Room Number</label>
                                <input type="text" class="form-control" id="roomNumber" name="roomNumber" 
                                       value="${room.roomNumber}" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="branchId" class="form-label">Branch ID</label>
                                <input type="number" class="form-control" id="branchId" name="branchId" 
                                       value="${room.branchId}" min="1" required>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="roomTypeId" class="form-label">Room Type ID</label>
                                <input type="number" class="form-control" id="roomTypeId" name="roomTypeId" 
                                       value="${room.roomTypeId}" min="1" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="status" class="form-label">Status</label>
                                <select class="form-select" id="status" name="status" required>
                                    <option value="Available" ${room.status == 'Available' ? 'selected' : ''}>Available</option>
                                    <option value="Booked" ${room.status == 'Booked' ? 'selected' : ''}>Booked</option>
                                    <option value="Maintenance" ${room.status == 'Maintenance' ? 'selected' : ''}>Maintenance</option>
                                    <option value="Locked" ${room.status == 'Locked' ? 'selected' : ''}>Locked</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="imageUrl" class="form-label">Image URL</label>
                            <input type="url" class="form-control" id="imageUrl" name="imageUrl" 
                                   value="${room.imageUrl}" placeholder="https://example.com/room-image.jpg">
                        </div>
                    </div>
                    
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-edit text-white">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteRoomModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title text-danger">
                        <i class="fas fa-exclamation-triangle"></i> Confirm Delete
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete <strong>Room ${room.roomNumber}</strong>?</p>
                    <p class="text-danger">
                        <i class="fas fa-warning"></i> This action cannot be undone.
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form action="room-detail" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="${room.id}">
                        <button type="submit" class="btn btn-delete text-white">
                            <i class="fas fa-trash"></i> Delete Room
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Status Update Form (Hidden) -->
    <form id="statusUpdateForm" action="room-detail" method="post" style="display: none;">
        <input type="hidden" name="action" value="updateStatus">
        <input type="hidden" name="id" value="${room.id}">
        <input type="hidden" name="status" id="newStatus">
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function updateStatus(status) {
            if (confirm('Are you sure you want to change the room status to "' + status + '"?')) {
                document.getElementById('newStatus').value = status;
                document.getElementById('statusUpdateForm').submit();
            }
        }
    </script>
</body>
</html>