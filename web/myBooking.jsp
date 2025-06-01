<%-- 
    Document   : myBooking
    Created on : Jun 1, 2025, 1:23:52 PM
    Author     : KTC
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>My Booking Room</title>
        <link rel="stylesheet" href="css/my_booking.css">
    </head>
    <body>
        <!-- Header -->
        <header>
            <nav>
                <div class="sidebar">
                    <img class="avatar" src="./img/avatar/${sessionScope.user.getAvatar_url()}" alt="Profile Avatar"/>
                    <div class="logo">My Booking Room</div>
                    <ul>
                        <li><a href="#">Booking Room</a></li>
                        <li><a href="myBooking">My Booking Room</a></li>
                        <li><a href="sendFeedback">Feedback Room</a></li>
                    </ul>

                </div>
            </nav>
        </header>

        <!-- Main Content -->
        <main>
            <form action="myBooking" method="post">
                <h1>Reservation Management</h1>
                <c:if test="${not empty message}">
                    <p style="color: green;">${message}</p>
                </c:if>
                <c:if test="${not empty error}">
                    <p style="color: red;">${error}</p>
                </c:if>
                <c:if test="${empty bookings}">
                    <p>No bookings yet.</p>
                </c:if>
                <c:if test="${not empty bookings}">
                    <div class="booking-list">
                        <c:forEach var="booking" items="${bookings}">
                            <div class="booking-card">
                                <h3>${booking.roomNumbers}</h3>
                                <p>Booking Id: ${booking.id}</p>
                                <p>Check in Date - Check out Date: ${booking.checkIn} - ${booking.checkOut}</p>
                                <p>Booking status: ${booking.status}</p>
                                <p>Total Price: ${booking.totalPrice}</p>
                                <c:if test="${booking.status == 'Pending' || booking.status == 'Confirmed'}">
                                    <button onclick="showCancelForm('${booking.id}')">Cancle booking room</button>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>

                <!-- Cancel Form (Pop-up) -->
                <div id="cancelModal" class="modal">
                    <div class="modal-content">
                        <span class="close" onclick="closeCancelForm()">×</span>
                        <h2>Cancle booking room</h2>
                        <form action="myBooking" method="post">
                            <input type="hidden" name="action" value="cancel">
                            <input type="hidden" name="bookingId" id="cancelBookingId">
                            <p>Are you sure you want to cancel this reservation?</p>
                            <label>Reason for Cancellation:</label>
                            <textarea name="cancelReason" rows="4" placeholder="Enter cancellation reason (required)" required></textarea>
                            <button type="submit">Confirm Cancellation</button>
                            <button type="button" onclick="closeCancelForm()">Close</button>
                        </form>
                    </div>
                </div>
            </form>

        </main>

        <!-- Footer -->
        <footer>
            <p>Liên hệ: 090xxxxxxx | support@bookingapp.com</p>
            <p>© 2025 Ứng Dụng Đặt Phòng</p>
        </footer>

        <script>
            function showCancelForm(bookingId) {
                document.getElementById('cancelBookingId').value = bookingId;
                document.getElementById('cancelModal').style.display = 'flex';
            }

            function closeCancelForm() {
                document.getElementById('cancelModal').style.display = 'none';
            }
        </script>
    </body>
</html>
