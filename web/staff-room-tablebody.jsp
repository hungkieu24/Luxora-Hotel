<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="Model.Room" %>
<%
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
    Map<Integer, String> roomTypeMap = (Map<Integer, String>) request.getAttribute("roomTypeMap");
    Map<Integer, Double> roomTypePriceMap = (Map<Integer, Double>) request.getAttribute("roomTypePriceMap");
%>
<%
if (rooms != null && !rooms.isEmpty()) {
    for (Room r : rooms) {
        String typeName = roomTypeMap != null ? roomTypeMap.get(r.getRoomTypeId()) : "Unknown";
        Double price = roomTypePriceMap != null ? roomTypePriceMap.get(r.getRoomTypeId()) : null;
        String status = r.getStatus();
%>
<tr>
    <td><%= r.getId() %></td>
    <td><i class="bi bi-door-closed"></i> <%= r.getRoomNumber() %></td>
    <td><%= typeName != null ? typeName : "Unknown" %></td>
    <td>
        <%
            if (price != null) {
                out.print(String.format("%,.0f VND", price));
            } else {
                out.print("N/A");
            }
        %>
    </td>
    <td>
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
        <select name="status_<%= r.getId() %>" class="form-select form-select-sm">
            <option value="Available" <%= "Available".equals(status) ? "selected" : "" %>>Available</option>
            <option value="Booked" <%= "Booked".equals(status) ? "selected" : "" %>>Booked</option>
            <option value="Occupied" <%= "Occupied".equals(status) ? "selected" : "" %>>Occupied</option>
            <option value="Maintenance" <%= "Maintenance".equals(status) ? "selected" : "" %>>Maintenance</option>
        </select>
        <input type="hidden" name="roomId" value="<%= r.getId() %>"/>
    </td>
</tr>
<%
    }
} else {
%>
<tr>
    <td colspan="7" class="text-center text-muted">No rooms found.</td>
</tr>
<%
}
%>