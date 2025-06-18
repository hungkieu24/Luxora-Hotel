
   <nav class="sidebar" id="sidebar">
                <div class="sidebar-header">
                    <div class="brand">
                        <i class="fas fa-building"></i>
                        <span class="brand-text"><%= branchName %></span>
                    </div>
                    <button class="sidebar-toggle" id="sidebarToggle">
                        <i class="fas fa-bars"></i>
                    </button>
                </div>
                <div class="sidebar-menu">
                    <a href="staff-dashboard.jsp" class="menu-item active">
                        <i class="fas fa-user-cog"></i>
                        <span class="menu-text">Panel</span>
                    </a>
                    <a href="staff-bookings-list" class="menu-item">
                        <i class="fas fa-calendar-check"></i>
                        <span class="menu-text">Today's Bookings</span>
                    </a>
                    <a href="staff-rooms" class="menu-item">
                        <i class="fas fa-door-closed"></i>
                        <span class="menu-text">Room List</span>
                    </a>
                    <a href="searchGuest" class="menu-item">
                        <i class="fas fa-plus-circle"></i>
                        <span class="menu-text">Add New Booking</span>
                    </a>
                    <a href="logout.jsp" class="menu-item logout">
                        <i class="fas fa-sign-out-alt"></i>
                        <span class="menu-text">Logout</span>
                    </a>
                </div>
            </nav>
                    