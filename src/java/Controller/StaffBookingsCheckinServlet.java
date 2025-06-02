package Controller;

import Dal.BookingDAO;
import Dal.RoomDAO;
import Model.Booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "StaffBookingsCheckinServlet", urlPatterns = {"/staff-bookings-checkin"})
public class StaffBookingsCheckinServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bookings;

        try {
            if (keyword != null && !keyword.trim().isEmpty()) {
                bookings = bookingDAO.searchBookingsTodayByCustomer(keyword.trim());
                request.setAttribute("keyword", keyword);
            } else {
                bookings = bookingDAO.getBookingsToday();
            }
            request.setAttribute("bookings", bookings);

            // Move messages from session to request if any
            HttpSession session = request.getSession(false);
            if (session != null) {
                String checkinMessage = (String) session.getAttribute("checkinMessage");
                String checkoutMessage = (String) session.getAttribute("checkoutMessage");
                String errorMessage = (String) session.getAttribute("errorMessage");
                if (checkinMessage != null) {
                    request.setAttribute("checkinMessage", checkinMessage);
                    session.removeAttribute("checkinMessage");
                }
                if (checkoutMessage != null) {
                    request.setAttribute("checkoutMessage", checkoutMessage);
                    session.removeAttribute("checkoutMessage");
                }
                if (errorMessage != null) {
                    request.setAttribute("errorMessage", errorMessage);
                    session.removeAttribute("errorMessage");
                }
            }
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred while fetching the booking list.");
            e.printStackTrace();
        }

        request.getRequestDispatcher("staff-bookings-checkin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        String action = request.getParameter("action");
        String idParam = request.getParameter("bookingId");
        BookingDAO bookingDAO = new BookingDAO();
        RoomDAO roomDAO = new RoomDAO();

        try {
            int bookingId = Integer.parseInt(idParam);
            if ("checkin".equalsIgnoreCase(action)) {
                bookingDAO.updateBookingStatus(bookingId, "CheckedIn");
                List<Integer> roomIds = roomDAO.getRoomIdsByBooking(bookingId);
                for (int roomId : roomIds) {
                    roomDAO.updateRoomStatus(roomId, "Booked");
                }
                request.getSession().setAttribute("checkinMessage", "Check-in successful.");
            } else if ("checkout".equalsIgnoreCase(action)) {
                bookingDAO.updateBookingStatus(bookingId, "CheckedOut");
                List<Integer> roomIds = roomDAO.getRoomIdsByBooking(bookingId);
                for (int roomId : roomIds) {
                    roomDAO.updateRoomStatus(roomId, "Available");
                }
                request.getSession().setAttribute("checkoutMessage", "Check-out successful.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Booking ID is invalid.");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "An error occurred while processing.");
        }
        response.sendRedirect("staff-bookings-checkin");
    }
}