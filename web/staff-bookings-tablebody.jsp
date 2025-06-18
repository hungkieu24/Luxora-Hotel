<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Booking" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    SimpleDateFormat sdfDateTime = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    java.util.Date now = new java.util.Date();
%>
<%
if (bookings != null && !bookings.isEmpty()) {
    for (Booking b : bookings) {
        boolean canCheckin = "confirmed".equalsIgnoreCase(b.getStatus())
            && b.getCheckIn() != null
            && !now.before(b.getCheckIn());
%>
<tr>
    <td><%= b.getId() %></td>
    <td><i class="bi bi-person-circle"></i> <%= b.getUserName() %></td>
    <td><i class="bi bi-door-closed"></i> <%= b.getRoomTypes() %></td>
    <td><i class="bi bi-hash"></i> <%= b.getRoomNumbers() != null ? b.getRoomNumbers() : "" %></td>
    <td><span class="badge bg-info text-dark"><%= b.getCheckIn() != null ? sdfDateTime.format(b.getCheckIn()) : "" %></span></td>
    <td><span class="badge bg-info text-dark"><%= b.getCheckOut() != null ? sdfDateTime.format(b.getCheckOut()) : "" %></span></td>
    <td><span class="badge bg-warning text-dark"><%= b.getTotalPrice() != 0 ? String.format("%,.0f", b.getTotalPrice()) : "0" %> đ</span></td>
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
        <% if (canCheckin) { %>
            <a href="staff-bookings-confirm?action=checkin&bookingId=<%= b.getId() %>" class="btn btn-success btn-sm">
                <i class="bi bi-person-check"></i> Check-in
            </a>
        <% } else if ("confirmed".equalsIgnoreCase(b.getStatus())) { %>
            <span class="text-muted" title="Cannot check-in before scheduled time">
                <i class="bi bi-clock"></i> Wait for check-in (<%= b.getCheckIn() != null ? sdfDateTime.format(b.getCheckIn()) : "" %>)
            </span>
        <% } else if ("checkedin".equalsIgnoreCase(b.getStatus())) { %>
            <a href="staff-bookings-confirm?action=checkout&bookingId=<%= b.getId() %>" class="btn btn-warning btn-sm">
                <i class="bi bi-box-arrow-right"></i> Check-out
            </a>
        <% } else { %>
            <span class="text-muted">-</span>
        <% } %>
    </td>
    <td>
        <a href="view-user-info?userId=<%= b.getUserId() %>" class="btn btn-info btn-sm" title="View Customer Info">
            <i class="bi bi-eye"></i> View
        </a>
    </td>
</tr>
<%
    }
} else {
%>
<tr>
    <td colspan="10" class="text-center text-muted">No bookings found for today.</td>
</tr>
<%
}
%>