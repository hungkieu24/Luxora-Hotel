<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="Model.UserAccount" %>
<%
    UserAccount user = (UserAccount) request.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Information</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<div class="container py-5">
    <a href="javascript:history.back()" class="btn btn-outline-secondary mb-3">
        <i class="bi bi-arrow-left"></i> Back
    </a>
    <div class="card shadow-sm">
        <div class="card-header bg-info text-white">
            <h2 class="mb-0"><i class="bi bi-person"></i> Customer Information</h2>
        </div>
        <div class="card-body">
            <% if(user != null) { %>
            <div class="row mb-3">
                <div class="col-md-2">
                    <% if(user.getAvatar_url() != null && !user.getAvatar_url().isEmpty()) { %>
                        <img src="<%= user.getAvatar_url() %>" class="img-thumbnail" style="max-width: 100px;">
                    <% } else { %>
                        <i class="bi bi-person-circle" style="font-size: 4rem;"></i>
                    <% } %>
                </div>
                <div class="col-md-10">
                    <h4><i class="bi bi-person"></i> <%= user.getUsername() %></h4>
                    <p><i class="bi bi-envelope"></i> <strong>Email:</strong> <%= user.getEmail() %></p>
                    <p><i class="bi bi-phone"></i> <strong>Phone:</strong> <%= user.getPhonenumber() %></p>
                    <p><i class="bi bi-person-badge"></i> <strong>Role:</strong> <%= user.getRole() %></p>
                    <p><i class="bi bi-check-circle"></i> <strong>Status:</strong> <%= user.getStatus() %></p>
                </div>
            </div>
            <% } else { %>
                <div class="alert alert-warning">User not found.</div>
            <% } %>
        </div>
    </div>
</div>
</body>
</html>