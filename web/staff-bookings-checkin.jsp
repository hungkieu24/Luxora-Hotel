<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Booking" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    String keyword = request.getAttribute("keyword") != null ? (String)request.getAttribute("keyword") : "";
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Today's Bookings & Check-in/Check-out</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <a href="staff-dashboard" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left"></i> Back to Dashboard
        </a>
        <!-- Search form -->
        <form class="d-flex" action="staff-bookings-checkin" method="get">
            <input class="form-control me-2" type="search" name="keyword" placeholder="Search by customer name" value="<%= keyword %>">
            <button class="btn btn-primary" type="submit"><i class="bi bi-search"></i> Search</button>
        </form>
    </div>

    <% if(request.getAttribute("error") != null) { %>
        <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
    <% } %>
    <% if(request.getAttribute("checkinMessage") != null) { %>
        <div class="alert alert-success"><%= request.getAttribute("checkinMessage") %></div>
    <% } %>
    <% if(request.getAttribute("checkoutMessage") != null) { %>
        <div class="alert alert-success"><%= request.getAttribute("checkoutMessage") %></div>
    <% } %>
    <% if(request.getAttribute("errorMessage") != null) { %>
        <div class="alert alert-danger"><%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
            <h2 class="mb-0"><i class="bi bi-list-ul"></i> Today's Bookings & Check-in/Check-out</h2>
        </div>
        <div class="card-body p-0">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Customer</th>
                        <th>Room Type</th>
                        <th>Check-in</th>
                        <th>Check-out</th>
                        <th>Status</th>
                        <th>Action</th>
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
                        <td><i class="bi bi-door-closed"></i> <%= b.getRoomTypes() %></td>
                        <td><span class="badge bg-info text-dark"><%= b.getCheckIn() != null ? sdf.format(b.getCheckIn()) : "" %></span></td>
                        <td><span class="badge bg-info text-dark"><%= b.getCheckOut() != null ? sdf.format(b.getCheckOut()) : "" %></span></td>
                        <td>
                            <% String status = b.getStatus() != null ? b.getStatus().toLowerCase() : ""; %>
                            <span class="badge 
                                <% if(status.contains("checkedin")) { %>bg-success
                                <% } else if(status.contains("checkedout")) { %>bg-secondary
                                <% } else if(status.contains("cancel")) { %>bg-danger
                                <% } else if(status.contains("confirmed")) { %>bg-primary<% } else { %>bg-dark<% } %>">
                                <%= b.getStatus() %>
                            </span>
                        </td>
                        <td>
                            <% if ("confirmed".equalsIgnoreCase(b.getStatus())) { %>
                                <form method="post" action="staff-bookings-checkin">
                                    <input type="hidden" name="bookingId" value="<%= b.getId() %>"/>
                                    <input type="hidden" name="action" value="checkin"/>
                                    <button type="submit" class="btn btn-success btn-sm"><i class="bi bi-person-check"></i> Check-in</button>
                                </form>
                            <% } else if ("checkedin".equalsIgnoreCase(b.getStatus())) { %>
                                <form method="post" action="staff-bookings-checkin">
                                    <input type="hidden" name="bookingId" value="<%= b.getId() %>"/>
                                    <input type="hidden" name="action" value="checkout"/>
                                    <button type="submit" class="btn btn-warning btn-sm"><i class="bi bi-box-arrow-right"></i> Check-out</button>
                                </form>
                            <% } else { %>
                                <span class="text-muted">-</span>
                            <% } %>
                        </td>
                    </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="7" class="text-center text-muted">No bookings found for today.</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>