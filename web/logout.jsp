<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    session.invalidate(); // Hủy session đăng nhập
    response.sendRedirect("homepage.jsp"); // Chuyển về trang homepage (đổi tên nếu homepage bạn khác)
%>