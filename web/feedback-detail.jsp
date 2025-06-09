<%-- 
    Document   : feedback-detail
    Created on : 9 thg 6, 2025, 00:27:39
    Author     : pc
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Feedback Detail - HotelBooki Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .rating-stars {
            color: #ffc107;
            font-size: 24px;
        }
        .feedback-image {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
        }
        .status-badge {
            font-size: 14px;
            padding: 8px 16px;
        }
        .sidebar {
            min-height: 100vh;
            background: #fff;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
        }
        .nav-link {
            color: #6c757d;
            padding: 12px 20px;
            border-radius: 8px;
            margin: 2px 10px;
        }
        .nav-link:hover, .nav-link.active {
            background: #e3f2fd;
            color: #1976d2;
        }
        .main-content {
            background: #f8f9fa;
            min-height: 100vh;
        }
        .header {
            background: white;
            padding: 15px 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 sidebar">
                <div class="p-3">
                    <div class="d-flex align-items-center mb-4">
                        <div class="bg-primary rounded p-2 me-2">
                            <i class="fas fa-hotel text-white"></i>
                        </div>
                        <span class="fw-bold text-primary">Sample Branch</span>
                    </div>
                    
                    <nav class="nav flex-column">
                        <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                            <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/rooms">
                            <i class="fas fa-bed me-2"></i> Room Management
                        </a>
                        <a class="nav-link active" href="${pageContext.request.contextPath}/feedback">
                            <i class="fas fa-comments me-2"></i> Feedback
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/services">
                            <i class="fas fa-concierge-bell me-2"></i> Services
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/promotions">
                            <i class="fas fa-tags me-2"></i> Promotions
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/members">
                            <i class="fas fa-users me-2"></i> Members
                        </a>
                        <hr>
                        <a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt me-2"></i> Logout
                        </a>
                    </nav>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 main-content">
                <!-- Header -->
                <div class="header d-flex justify-content-between align-items-center">
                    <div>
                        <h4 class="mb-0">Feedback Detail</h4>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb mb-0">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/feedback">Feedback</a></li>
                                <li class="breadcrumb-item active">Detail</li>
                            </ol>
                        </nav>
                    </div>
                    <div class="d-flex align-items-center">
                        <span class="me-2">admin</span>
                        <div class="bg-secondary rounded-circle" style="width: 32px; height: 32px;"></div>
                    </div>
                </div>
                
                <div class="p-4">
                    <div class="row">
                        <div class="col-md-8">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">Feedback Information</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <strong>Customer:</strong>
                                            <div class="d-flex align-items-center mt-2">
                                                <c:choose>
                                                    <c:when test="${not empty feedback.userAvatarUrl}">
                                                        <img src="${feedback.userAvatarUrl}" alt="Avatar" class="rounded-circle me-2" style="width: 40px; height: 40px;">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="bg-secondary rounded-circle me-2 d-flex align-items-center justify-content-center text-white" style="width: 40px; height: 40px;">
                                                            <i class="fas fa-user"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <span>${feedback.username}</span>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <strong>Booking ID:</strong>
                                            <div class="mt-2">${feedback.booking_id}</div>
                                        </div>
                                    </div>
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <strong>Rating:</strong>
                                            <div class="rating-stars mt-2">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <c:choose>
                                                        <c:when test="${i <= feedback.rating}">
                                                            <i class="fas fa-star"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="far fa-star"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                                <span class="ms-2 text-muted">${feedback.rating}/5</span>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <strong>Created at:</strong>
                                            <div class="mt-2">
                                                <fmt:formatDate value="${feedback.created_at}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <strong>Feedback Content:</strong>
                                        <div class="mt-2 p-3 bg-light rounded">
                                            ${feedback.comment}
                                        </div>
                                    </div>
                                    
                                    <c:if test="${not empty feedback.image_url}">
                                        <div class="mb-3">
                                            <strong>Attached Image:</strong>
                                            <div class="mt-2">
                                                <img src="${feedback.image_url}" alt="Feedback Image" class="feedback-image">
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">Status & Actions</h5>
                                </div>
                                <div class="card-body">
                                    <div class="mb-3">
                                        <strong>Current Status:</strong>
                                        <div class="mt-2">
                                            <c:choose>
                                                <c:when test="${feedback.status == 'Visible'}">
                                                    <span class="badge bg-success status-badge">Visible</span>
                                                </c:when>
                                                <c:when test="${feedback.status == 'Hidden'}">
                                                    <span class="badge bg-warning status-badge">Hidden</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger status-badge">Blocked</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <strong>Admin Action:</strong>
                                        <div class="mt-2">
                                            <c:choose>
                                                <c:when test="${feedback.admin_action == 'None' || empty feedback.admin_action}">
                                                    <span class="text-muted">No action yet</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-info">${feedback.admin_action}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    
                                    <hr>
                                    
                                    <div class="d-grid gap-2">
                                        <c:if test="${feedback.status == 'Visible'}">
                                            <a href="${pageContext.request.contextPath}/feedback?action=updateStatus&id=${feedback.id}&status=Hidden&adminAction=Warned" 
                                               class="btn btn-warning"
                                               onclick="return confirm('Hide this feedback?')">
                                                <i class="fas fa-eye-slash"></i> Hide Feedback
                                            </a>
                                        </c:if>
                                        
                                        <c:if test="${feedback.status == 'Hidden'}">
                                            <a href="${pageContext.request.contextPath}/feedback?action=updateStatus&id=${feedback.id}&status=Visible&adminAction=None" 
                                               class="btn btn-success"
                                               onclick="return confirm('Show this feedback?')">
                                                <i class="fas fa-eye"></i> Show Feedback
                                            </a>
                                        </c:if>
                                        
                                        <c:if test="${feedback.status != 'Blocked'}">
                                            <a href="${pageContext.request.contextPath}/feedback?action=updateStatus&id=${feedback.id}&status=Blocked&adminAction=Banned" 
                                               class="btn btn-danger"
                                               onclick="return confirm('Block this feedback? This action cannot be undone.')">
                                                <i class="fas fa-ban"></i> Block Feedback
                                            </a>
                                        </c:if>
                                        
                                        <a href="${pageContext.request.contextPath}/feedback" class="btn btn-outline-secondary">
                                            <i class="fas fa-arrow-left"></i> Back to list
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>