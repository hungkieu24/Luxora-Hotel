<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Staff Dashboard</title>
    <link rel="stylesheet" href="css/style_1.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<div class="app-container">
    <!-- Sidebar -->
    <nav class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <div class="brand">
                <i class="fas fa-building"></i>
                <span class="brand-text">Branch Panel</span>
            </div>
            <button class="sidebar-toggle" id="sidebarToggle">
                <i class="fas fa-bars"></i>
            </button>
        </div>
        <div class="sidebar-menu">
            <a href="staff-dashboard.jsp" class="menu-item active">
                <i class="fas fa-user-cog"></i>
                <span class="menu-text">Dashboard</span>
            </a>
            <a href="staff-bookings-checkin" class="menu-item">
                <i class="fas fa-calendar-check"></i>
                <span class="menu-text">Today’s Bookings</span>
            </a>
            <a href="staff-rooms" class="menu-item">
                <i class="fas fa-door-closed"></i>
                <span class="menu-text">Room Management</span>
            </a>
            <a href="logout" class="menu-item logout">
                <i class="fas fa-sign-out-alt"></i>
                <span class="menu-text">Logout</span>
            </a>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="main-content">
        <header class="content-header">
            <div class="header-left">
                <h1 class="page-title">Staff Dashboard</h1>
            </div>
            <div class="header-right">
                <button class="theme-toggle" id="themeToggle">
                    <i class="fas fa-moon"></i>
                </button>
                <div class="user-info">
                    <i class="fas fa-user-circle"></i>
                    <span>staff</span>
                </div>
            </div>
        </header>

        <div class="content-body">
            <div class="dashboard-grid">
                <div class="stats-grid">
                    <!-- Today's Bookings -->
                    <div class="stat-card">
                        <div class="stat-icon occupied">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Today</h3>
                            <p>Bookings & Check-in/out</p>
                            <a href="staff-bookings-checkin" class="btn btn-primary btn-sm mt-2">
                                Manage <i class="fas fa-arrow-right"></i>
                            </a>
                        </div>
                    </div>

                    <!-- Room Management -->
                    <div class="stat-card">
                        <div class="stat-icon available">
                            <i class="fas fa-door-closed"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Rooms</h3>
                            <p>Manage room status</p>
                            <a href="staff-rooms" class="btn btn-secondary btn-sm mt-2">
                                View Rooms <i class="fas fa-arrow-right"></i>
                            </a>
                        </div>
                    </div>

                    <!-- Add more cards if needed -->
                </div>
            </div>
        </div>
    </main>
</div>

<script src="js/main.js"></script>
</body>
</html>
 