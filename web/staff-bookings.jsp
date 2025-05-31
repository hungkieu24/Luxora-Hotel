<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Booking" %>
<%@ page import="Model.Room" %>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Today's Bookings List</title>
</head>
<body>
    <h1>Today's Bookings List</h1>
    <a href="staff-dashboard">← Back to Dashboard</a>
    <table border="1" cellpadding="4">
        <tr>
            <th>ID</th>
            <th>Customer</th>
            <th>Rooms</th>
            <th>Check-in</th>
            <th>Check-out</th>
            <th>Status</th>
        </tr>
        <%
        if (bookings != null && !bookings.isEmpty()) {
            for (Booking b : bookings) {
        %>
        <tr>
            <td><%= b.getId() %></td>
            <td><%= b.getUserName() %></td>
            <td><%= b.getRoomNumbers() %></td>
            <td><%= b.getCheckIn() %></td>
            <td><%= b.getCheckOut() %></td>
            <td><%= b.getStatus() %></td>
        </tr>
        <%
            }
        } else {
        %>
        <tr><td colspan="6">No bookings today.</td></tr>
        <% } %>
    </table>
</body>
</html>