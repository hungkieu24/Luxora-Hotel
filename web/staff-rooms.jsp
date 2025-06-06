<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="Model.Room" %>
<%
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
    Map<Integer, String> roomTypeMap = (Map<Integer, String>) request.getAttribute("roomTypeMap");
    String keyword = request.getParameter("keyword");
    int currentPage = (request.getAttribute("currentPage") != null) ? (Integer)request.getAttribute("currentPage") : 1;
    int totalPage = (request.getAttribute("totalPage") != null) ? (Integer)request.getAttribute("totalPage") : 1;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Room Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        .room-img { width: 80px; border-radius: 6px; box-shadow: 0 2px 6px rgba(0,0,0,.09); }
        .pagination { margin: 20px 0 0 0; display: flex; justify-content: center; }
        .pagination a, .pagination span {
            margin: 0 4px;
            padding: 6px 14px;
            border-radius: 5px;
            border: 1px solid #ddd;
            text-decoration: none;
        }
        .pagination .active, .pagination span[aria-current="page"] {
            background: #ffc107;
            color: #222;
            font-weight: bold;
            border-color: #ffc107;
        }
    </style>
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="d-flex mb-3 justify-content-between align-items-center">
        <a href="staff-dashboard" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left"></i> Back to Dashboard
        </a>
        <form class="d-flex" method="get" action="staff-rooms">
            <input type="text" name="keyword" class="form-control me-2" placeholder="Search by Room Type Name..."
                   value="<%= keyword != null ? keyword : "" %>">
            <button class="btn btn-outline-success" type="submit">
                <i class="bi bi-search"></i> Search
            </button>
        </form>
    </div>

    <div class="card shadow-sm">
        <div class="card-header bg-warning">
            <h2 class="mb-0"><i class="bi bi-door-open"></i> Room Management</h2>
        </div>
        <div class="card-body p-0">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Room Number</th>
                        <th>Branch</th>
                        <th>Room Type</th>
                        <th>Status</th>
                        <th>Image</th>
                        <th>Change Status</th>
                    </tr>
                </thead>
                <tbody>
                <%
                if (rooms != null && !rooms.isEmpty()) {
                    for (Room r : rooms) {
                        String typeName = roomTypeMap != null ? roomTypeMap.get(r.getRoomTypeId()) : "Unknown";
                %>
                <tr>
                    <td><%= r.getId() %></td>
                    <td><i class="bi bi-door-closed"></i> <%= r.getRoomNumber() %></td>
                    <td><%= r.getBranchId() %></td>
                    <td><%= typeName != null ? typeName : "Unknown" %></td>
                    <td>
                        <% String status = r.getStatus(); %>
                        <span class="badge 
                            <% if("Available".equalsIgnoreCase(status)) { %>bg-success
                            <% } else if("Booked".equalsIgnoreCase(status)) { %>bg-primary
                            <% } else if("Occupied".equalsIgnoreCase(status)) { %>bg-warning text-dark
                            <% } else if("Maintenance".equalsIgnoreCase(status)) { %>bg-secondary
                            <% } else { %>bg-light text-dark<% } %>">
                            <%= status %>
                        </span>
                    </td>
                    <td>
                        <% if (r.getImageUrl() != null && !r.getImageUrl().isEmpty()) { %>
                            <img src="<%= r.getImageUrl() %>" alt="room image" class="room-img"/>
                        <% } %>
                    </td>
                    <td>
                        <form method="post" action="staff-rooms" class="d-flex align-items-center">
                            <input type="hidden" name="roomId" value="<%= r.getId() %>"/>
                            <select name="status" class="form-select form-select-sm me-2">
                                <option value="Available" <%= "Available".equals(status) ? "selected" : "" %>>Available</option>
                                <option value="Booked" <%= "Booked".equals(status) ? "selected" : "" %>>Booked</option>
                                <option value="Occupied" <%= "Occupied".equals(status) ? "selected" : "" %>>Occupied</option>
                                <option value="Maintenance" <%= "Maintenance".equals(status) ? "selected" : "" %>>Maintenance</option>
                            </select>
                            <button type="submit" class="btn btn-outline-primary btn-sm">
                                <i class="bi bi-arrow-repeat"></i> Update
                            </button>
                        </form>
                    </td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="7" class="text-center text-muted">No rooms found.</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <%-- Pagination Bar --%>
    <div class="pagination">
        <%
            String queryStr = "";
            if (keyword != null && !keyword.isEmpty()) {
                queryStr += "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8");
            }
            if (totalPage > 1) {
                // Previous
                if(currentPage > 1){
        %>
            <a href="staff-rooms?page=<%=currentPage-1%><%=queryStr%>">&laquo;</a>
        <%
                }

                // Page numbers
                for (int i = 1; i <= totalPage; i++) {
                    if (i == currentPage) {
        %>
            <span class="active" aria-current="page"><%=i%></span>
        <%
                    } else {
        %>
            <a href="staff-rooms?page=<%=i%><%=queryStr%>"><%=i%></a>
        <%
                    }
                }

                // Next
                if(currentPage < totalPage){
        %>
            <a href="staff-rooms?page=<%=currentPage+1%><%=queryStr%>">&raquo;</a>
        <%
                }
            }
        %>
    </div>
</div>
</body>
</html>