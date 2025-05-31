<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Booking" %>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Today's Bookings List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="d-flex mb-3">
        <a href="staff-dashboard" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left"></i> Back to Dashboard
        </a>
    </div>
    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
            <h2 class="mb-0"><i class="bi bi-list-ul"></i> Today's Bookings List</h2>
        </div>
        <div class="card-body p-0">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Customer</th>
                        <th>Rooms</th>
                        <th>Check-in</th>
                        <th>Check-out</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                <%
                if (bookings != null && !bookings.isEmpty()) {
                    for (Booking b : bookings) {
                %>
                    <tr>
                        <td><%= b.getId() %></td>
                        <td><i class="bi bi-person-circle"></i> <%= b.getUserName() %></td>
                        <td><i class="bi bi-door-closed"></i> <%= b.getRoomNumbers() %></td>
                        <td><span class="badge bg-info text-dark"><%= b.getCheckIn() %></span></td>
                        <td><span class="badge bg-info text-dark"><%= b.getCheckOut() %></span></td>
                        <td>
                            <% String status = b.getStatus().toLowerCase(); %>
                            <span class="badge 
                                <% if(status.contains("checkedin")) { %>bg-success
                                <% } else if(status.contains("checkedout")) { %>bg-secondary
                                <% } else if(status.contains("cancel")) { %>bg-danger
                                <% } else { %>bg-primary<% } %>">
                                <%= b.getStatus() %>
                            </span>
                        </td>
                    </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="6" class="text-center text-muted">No bookings today.</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>