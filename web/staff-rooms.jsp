<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Room" %>
<%
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Room Management</title>
</head>
<body>
    <h1>Room Management</h1>
    <a href="staff-dashboard">← Back to Dashboard</a>
    <table border="1" cellpadding="4">
        <tr>
            <th>ID</th>
            <th>Room Number</th>
            <th>Branch</th>
            <th>Room Type</th>
            <th>Status</th>
            <th>Image</th>
            <th>Change Status</th>
        </tr>
        <%
        if (rooms != null && !rooms.isEmpty()) {
            for (Room r : rooms) {
        %>
        <tr>
            <td><%= r.getId() %></td>
            <td><%= r.getRoomNumber() %></td>
            <td><%= r.getBranchId() %></td>
            <td><%= r.getRoomTypeId() %></td>
            <td><%= r.getStatus() %></td>
            <td>
                <% if (r.getImageUrl() != null) { %>
                    <img src="<%= r.getImageUrl() %>" alt="room image" width="80"/>
                <% } %>
            </td>
            <td>
                <form method="post" action="staff-rooms">
                    <input type="hidden" name="roomId" value="<%= r.getId() %>"/>
                    <select name="status">
                        <option value="Available" <%= "Available".equals(r.getStatus()) ? "selected" : "" %>>Available</option>
                        <option value="Booked" <%= "Booked".equals(r.getStatus()) ? "selected" : "" %>>Booked</option>
                        <option value="Occupied" <%= "Occupied".equals(r.getStatus()) ? "selected" : "" %>>Occupied</option>
                        <option value="Maintenance" <%= "Maintenance".equals(r.getStatus()) ? "selected" : "" %>>Maintenance</option>
                    </select>
                    <input type="submit" value="Update"/>
                </form>
            </td>
        </tr>
        <%
            }
        } else {
        %>
        <tr><td colspan="7">No rooms found.</td></tr>
        <% } %>
    </table>
</body>
</html>