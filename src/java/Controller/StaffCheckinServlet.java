/*
 * StaffCheckinServlet.java
 * Handles staff check-in/check-out operations
 */
package Controller;

import Dal.BookingDAO;
import Dal.RoomDAO;
import Model.Booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "StaffCheckinServlet", urlPatterns = {"/staff-checkin"})
public class StaffCheckinServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        BookingDAO bookingDAO = new BookingDAO();
        List<Model.Booking> bookings = bookingDAO.getBookingsToday();
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("staff-checkin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        String action = request.getParameter("action");
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        BookingDAO bookingDAO = new BookingDAO();
        RoomDAO roomDAO = new RoomDAO();

        if ("checkin".equals(action)) {
            bookingDAO.updateBookingStatus(bookingId, "CheckedIn");
            List<Integer> roomIds = roomDAO.getRoomIdsByBooking(bookingId);
            for (int roomId : roomIds) {
                roomDAO.updateRoomStatus(roomId, "Booked");
            }
        } else if ("checkout".equals(action)) {
            bookingDAO.updateBookingStatus(bookingId, "CheckedOut");
            List<Integer> roomIds = roomDAO.getRoomIdsByBooking(bookingId);
            for (int roomId : roomIds) {
                roomDAO.updateRoomStatus(roomId, "Available");
            }
        }
        response.sendRedirect("staff-checkin");
    }
}