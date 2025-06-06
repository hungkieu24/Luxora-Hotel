package Controller.Staff;

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
        
          // --- VALIDATION: Check staff session/role ---
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userRole") == null
                || !"staff".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String keyword = request.getParameter("keyword");
        int page = 1;
        int pageSize = 8; // Số booking/trang, bạn có thể tùy chỉnh

        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bookings;
        int totalBooking = 0;

        if (keyword != null && !keyword.trim().isEmpty()) {
            bookings = bookingDAO.searchBookingsTodayByCustomerPaging(keyword.trim(), page, pageSize);
            totalBooking = bookingDAO.countBookingsTodayByCustomer(keyword.trim());
            request.setAttribute("keyword", keyword);
        } else {
            bookings = bookingDAO.getBookingsTodayPaging(page, pageSize);
            totalBooking = bookingDAO.countBookingsToday();
        }

        int totalPage = (int) Math.ceil((double) totalBooking / pageSize);

        request.setAttribute("bookings", bookings);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPage", totalPage);

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
