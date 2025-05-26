<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Booking" %>
<%
    String userId = (String) request.getAttribute("user_id");
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Lịch sử đặt phòng theo User ID</title>
    <style>
        table { border-collapse: collapse; width: 90%; margin: 20px auto; }
        th, td { border: 1px solid #ccc; padding: 8px 12px; text-align: center; }
        th { background: #f2f2f2; }
        h2 { text-align: center; }
        form { text-align: center; margin: 20px; }
    </style>
</head>
<body>
    <h2>Lịch sử đặt phòng theo User ID</h2>
    <form method="get" action="booking-history">
        <label for="user_id">Nhập User ID: </label>
        <input type="text" name="user_id" id="user_id" value="<%= userId != null ? userId : "" %>" required>
        <button type="submit">Xem lịch sử</button>
    </form>
    <%
        if (bookings != null) {
    %>
    <table>
        <tr>
            <th>Mã đặt phòng</th>
            <th>User ID</th>
            <th>Tên khách sạn</th>
            <th>Phòng</th>
            <th>Ngày nhận phòng</th>
            <th>Ngày trả phòng</th>
            <th>Trạng thái</th>
            <th>Tổng tiền</th>
        </tr>
        <%
            if (!bookings.isEmpty()) {
                for (Booking b : bookings) {
        %>
        <tr>
            <td><%= b.getId() %></td>
            <td><%= b.getUserId() %></td>
            <td><%= b.getHotelName() %></td>
            <td><%= b.getRoomName() %></td>
            <td><%= b.getCheckInDate() %></td>
            <td><%= b.getCheckOutDate() %></td>
            <td><%= b.getStatus() %></td>
            <td><%= b.getTotalPrice() %></td>
        </tr>
        <%
                }
            } else {
        %>
        <tr>
            <td colspan="8">Không có lịch sử đặt phòng cho User ID này.</td>
        </tr>
        <%
            }
        %>
    </table>
    <%
        }
    %>
</body>
</html>