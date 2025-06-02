<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.UserAccount" %>
<%
    UserAccount user = (UserAccount) session.getAttribute("user");
    boolean isStaff = (user != null && "Staff".equals(user.getRole()));
%>
<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
  <div class="container">
    <a class="navbar-brand fw-bold" href="homepage.jsp">HotelBooking</a>
    <% if (isStaff) { %>
      <!-- Hamburger menu for staff when logged in -->
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarStaff" aria-controls="navbarStaff" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarStaff">
        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
          <li class="nav-item">
            <a class="nav-link" href="homepage.jsp">Home</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="staff-bookings">Bookings</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="staff-checkin">Check-in/Check-out</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="staff-rooms">Room Management</a>
          </li>
        </ul>
        <div class="dropdown">
          <a class="d-flex align-items-center text-decoration-none dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            <img src="<%= user.getAvatar_url() != null ? user.getAvatar_url() : "https://i.pravatar.cc/30" %>" alt="avatar" width="32" height="32" class="rounded-circle me-2">
            <strong><%= user.getUsername() %></strong>
          </a>
          <ul class="dropdown-menu dropdown-menu-end">
            <li><a class="dropdown-item" href="profile">Profile</a></li>
            <li><a class="dropdown-item" href="change-password">Change Password</a></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item text-danger" href="logout">Logout</a></li>
          </ul>
        </div>
      </div>
    <% } else { %>
      <!-- Only logo and Home for not logged in users -->
      <div class="d-flex">
        <a class="nav-link" href="homepage.jsp">Home</a>
      </div>
    <% } %>
  </div>
</nav>