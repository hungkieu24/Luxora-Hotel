<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Booking" %>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Check-in/Check-out</title>
</head>
<body>
    <h1>Check-in / Check-out</h1>
    <a href="staff-dashboard">← Back to Dashboard</a>
    <table border="1" cellpadding="4">
        <tr>
            <th>ID</th>
            <th>Customer</th>
            <th>Rooms</th>
            <th>Check-in</th>
            <th>Check-out</th>
            <th>Status</th>
            <th>Action</th>
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
            <td>
                <form method="post" action="staff-checkin" style="display:inline;">
                    <input type="hidden" name="bookingId" value="<%= b.getId() %>"/>
                    <input type="hidden" name="action" value="checkin"/>
                    <input type="submit" value="Check-in"/>
                </form>
                <form method="post" action="staff-checkin" style="display:inline;">
                    <input type="hidden" name="bookingId" value="<%= b.getId() %>"/>
                    <input type="hidden" name="action" value="checkout"/>
                    <input type="submit" value="Check-out"/>
                </form>
            </td>
        </tr>
        <%
            }
        } else {
        %>
        <tr><td colspan="7">No bookings today.</td></tr>
        <% } %>
    </table>
</body>
</html>