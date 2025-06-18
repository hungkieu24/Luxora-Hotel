<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Booking" %>
<%@ page import="Model.UserAccount" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    String keyword = request.getAttribute("keyword") != null ? (String)request.getAttribute("keyword") : "";
    SimpleDateFormat sdfDateTime = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    int currentPage = request.getAttribute("currentPage") != null ? (Integer)request.getAttribute("currentPage") : 1;
    int totalPage = request.getAttribute("totalPage") != null ? (Integer)request.getAttribute("totalPage") : 1;
    String staffName = "";
    if (session.getAttribute("user") != null) {
        staffName = ((UserAccount)session.getAttribute("user")).getUsername();
    }
    String branchName = (session.getAttribute("branchName") != null && !session.getAttribute("branchName").toString().isEmpty())
        ? session.getAttribute("branchName").toString()
        : "Branch";
    java.util.Date now = new java.util.Date();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Booking List</title>
        <link rel="stylesheet" href="css/style_1.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            .room-img {
                width: 80px;
                border-radius: 6px;
                box-shadow: 0 2px 6px rgba(0,0,0,.09);
            }
            .pagination {
                margin: 20px 0 0 0;
                display: flex;
                justify-content: center;
            }
            .pagination a, .pagination span {
                margin: 0 4px;
                padding: 6px 14px;
                border-radius: 5px;
                border: 1px solid #ddd;
                text-decoration: none;
            }
            .pagination .active, .pagination span[aria-current="page"] {
                background: #ffc107;
                color: #222;
                font-weight: bold;
                border-color: #ffc107;
            }
            .sidebar {
                height: 100vh;
                width: 220px;
                position: fixed;
                top: 0;
                left: 0;
                background: #22223b;
                color: #fff;
                z-index: 1000;
            }
            .sidebar-header {
                padding: 20px;
                font-size: 1.25rem;
                font-weight: bold;
            }
            .sidebar-menu {
                padding: 0 0 20px 0;
            }
            .sidebar-menu .menu-item {
                display: flex;
                align-items: center;
                gap: 10px;
                color: #fff;
                padding: 12px 20px;
                text-decoration: none;
                transition: background 0.2s;
            }
            .sidebar-menu .menu-item.active, .sidebar-menu .menu-item:hover {
                background: #4a4e69;
                border-left: 4px solid #ffc107;
            }
            .sidebar-menu .logout {
                color: #fa5252;
            }
            .main-content {
                margin-left: 220px;
                padding: 0;
                min-height: 100vh;
                background: #f4f5fa;
            }
            .content-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 28px 40px 0 40px;
            }
            .user-info {
                display: flex;
                align-items: center;
                gap: 7px;
                font-weight: 600;
            }
            .content-body {
                margin: 35px 40px 0 40px;
            }
            .form-container {
                max-width: 1200px;
                margin: 0 auto;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="app-container">
            <!-- Sidebar -->
            <%@ include file="sidebar.jsp" %>
            <!-- Main Content -->
            <main class="main-content">
                <header class="content-header">
                    <div class="header-left">
                        <h1 class="page-title">Today's Bookings &amp; Check-in/Check-out</h1>
                    </div>
                    <div class="header-right">
                        <div class="user-info">
                            <i class="fas fa-user-circle"></i>
                            <span><%= staffName != null && !staffName.isEmpty() ? staffName : "staff" %></span>
                        </div>
                    </div>
                </header>
                <div class="content-body">
                    <div class="form-container">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <a href="staff-dashboard.jsp" class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-left"></i> Back to Panel
                            </a>
                            <!-- Live search form -->
                            <form class="d-flex" id="live-search-form" onsubmit="return false;">
                                <input class="form-control me-2" type="search" name="keyword" id="live-search-keyword" placeholder="Search by customer name" autocomplete="off" value="<%= keyword %>">
                            </form>
                        </div>

                        <% if(request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
                        <% } %>
                        <% if(request.getAttribute("checkinMessage") != null) { %>
                        <div class="alert alert-success"><%= request.getAttribute("checkinMessage") %></div>
                        <% } %>
                        <% if(request.getAttribute("checkoutMessage") != null) { %>
                        <div class="alert alert-success"><%= request.getAttribute("checkoutMessage") %></div>
                        <% } %>
                        <% if(request.getAttribute("errorMessage") != null) { %>
                        <div class="alert alert-danger"><%= request.getAttribute("errorMessage") %></div>
                        <% } %>

                        <div class="card shadow-sm">
                            <div class="card-header bg-primary text-white">
                                <h2 class="mb-0"><i class="bi bi-list-ul"></i> Today's Bookings & Check-in/Check-out</h2>
                            </div>
                            <div class="card-body p-0">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>ID</th>
                                            <th>Customer</th>
                                            <th>Room Type</th>
                                            <th>Room Number</th>
                                            <th>Check-in</th>
                                            <th>Check-out</th>
                                            <th>Total Price</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                            <th>View</th>
                                        </tr>
                                    </thead>
                                    <tbody id="bookings-table-body">
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
                                            <td>
                                                <i class="bi bi-hash"></i>
                                                <%= b.getRoomNumbers() != null ? b.getRoomNumbers() : "" %>
                                            </td>
                                            <td>
                                                <span class="badge bg-info text-dark">
                                                    <%= b.getCheckIn() != null ? sdfDateTime.format(b.getCheckIn()) : "" %>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge bg-info text-dark">
                                                    <%= b.getCheckOut() != null ? sdfDateTime.format(b.getCheckOut()) : "" %>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge bg-warning text-dark">
                                                    <%= b.getTotalPrice() != 0 ? String.format("%,.0f", b.getTotalPrice()) : "0" %> đ
                                                </span>
                                            </td>
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
                                                    <button class="btn btn-success btn-sm" 
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#confirmModal"
                                                            data-action="checkin"
                                                            data-booking-id="<%= b.getId() %>">
                                                        <i class="bi bi-person-check"></i> Check-in
                                                    </button>
                                                <% } else if ("confirmed".equalsIgnoreCase(b.getStatus())) { %>
                                                    <span class="text-muted" title="Cannot check-in before scheduled time">
                                                        <i class="bi bi-clock"></i> Wait for check-in (<%= b.getCheckIn() != null ? sdfDateTime.format(b.getCheckIn()) : "" %>)
                                                    </span>
                                                <% } else if ("checkedin".equalsIgnoreCase(b.getStatus())) { %>
                                                    <button class="btn btn-warning btn-sm" 
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#confirmModal"
                                                            data-action="checkout"
                                                            data-booking-id="<%= b.getId() %>">
                                                        <i class="bi bi-box-arrow-right"></i> Check-out
                                                    </button>
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
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Pagination Bar -->
                        <div class="pagination" id="pagination-bar">
                            <%
                                String queryStr = "";
                                if (keyword != null && !keyword.isEmpty()) {
                                    queryStr += "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8");
                                }
                                if (totalPage > 1) {
                                    if(currentPage > 1){
                            %>
                            <a href="staff-bookings-list?page=<%=currentPage-1%><%=queryStr%>">&laquo;</a>
                            <%
                                    }
                                    for (int i = 1; i <= totalPage; i++) {
                                        if (i == currentPage) {
                            %>
                            <span class="active" aria-current="page"><%=i%></span>
                            <%
                                        } else {
                            %>
                            <a href="staff-bookings-list?page=<%=i%><%=queryStr%>"><%=i%></a>
                            <%
                                        }
                                    }
                                    if(currentPage < totalPage){
                            %>
                            <a href="staff-bookings-list?page=<%=currentPage+1%><%=queryStr%>">&raquo;</a>
                            <%
                                    }
                                }
                            %>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <!-- Modal Confirm Check-in/Check-out -->
        <div class="modal fade" id="confirmModal" tabindex="-1" aria-labelledby="confirmModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content" style="border-radius:16px;">
                    <form method="post" action="staff-booking-action">
                        <div class="modal-header" style="border-bottom:1px solid #ececec;">
                            <h4 class="modal-title fw-bold" id="confirmModalLabel">Confirm <span id="modalActionLabel">Check-in</span></h4>
                            <button type="button" class="btn-close fs-3" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body text-center" style="font-size:1.2rem;">
                            <span id="confirmModalText">
                                Are you sure you want to <b id="modalAction" class="fw-bold">Check-in</b> for booking ID <b id="modalBookingId">24</b>?
                            </span>
                            <input type="hidden" name="bookingId" id="confirmModalBookingId" value=""/>
                            <input type="hidden" name="action" id="confirmModalAction" value=""/>
                        </div>
                        <div class="modal-footer d-flex justify-content-end" style="border-top:1px solid #ececec;">
                            <button type="submit" class="btn btn-primary px-4" style="font-size:1.1rem;">Confirm</button>
                            <button type="button" class="btn btn-secondary ms-2 px-4" style="font-size:1.1rem;" data-bs-dismiss="modal">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            let typingTimer;
            const doneTypingInterval = 350; // milliseconds
            const keywordInput = document.getElementById('live-search-keyword');

            function fetchBookings() {
                const keyword = keywordInput.value;
                let url = 'staff-bookings-list?ajax=1';
                if (keyword)
                    url += '&keyword=' + encodeURIComponent(keyword);

                fetch(url)
                        .then(response => response.text())
                        .then(html => {
                            document.getElementById('bookings-table-body').innerHTML = html;
                        });
            }

            keywordInput.addEventListener('input', function () {
                clearTimeout(typingTimer);
                typingTimer = setTimeout(fetchBookings, doneTypingInterval);
            });

            // Modal handling for check-in/check-out
            document.addEventListener('DOMContentLoaded', function () {
                var confirmModal = document.getElementById('confirmModal');
                if (confirmModal) {
                    confirmModal.addEventListener('show.bs.modal', function (event) {
                        var button = event.relatedTarget;
                        var action = button.getAttribute('data-action');
                        var bookingId = button.getAttribute('data-booking-id');
                        var actionLabel = action === 'checkin' ? 'Check-in' : 'Check-out';

                        // Set modal title and content
                        document.getElementById('modalActionLabel').textContent = actionLabel;
                        document.getElementById('modalAction').textContent = actionLabel;
                        document.getElementById('modalBookingId').textContent = bookingId;
                        document.getElementById('confirmModalBookingId').value = bookingId;
                        document.getElementById('confirmModalAction').value = action;
                    });
                }
            });
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="js/main.js"></script>
    </body>
</html>