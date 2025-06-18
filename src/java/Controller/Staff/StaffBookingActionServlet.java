package Controller.Staff;

import Dal.BookingDAO;
import Dal.RoomDAO;
import Model.Booking;
import Model.UserAccount;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "StaffBookingActionServlet", urlPatterns = {"/staff-booking-action"})
public class StaffBookingActionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("bookingId");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        UserAccount staff = (UserAccount) session.getAttribute("user");
        Integer branchId = staff.getBranchId();

        BookingDAO bookingDAO = new BookingDAO();
        RoomDAO roomDAO = new RoomDAO();

        try {
            int bookingId = Integer.parseInt(idParam);
            Booking booking = bookingDAO.getBookingByIdAndBranch(bookingId, branchId);
            if (booking == null) {
                session.setAttribute("errorMessage", "The booking does not belong to your branch or does not exist.");
                response.sendRedirect("staff-bookings-list");
                return;
            }
            if ("checkin".equalsIgnoreCase(action)) {
                bookingDAO.updateBookingStatus(bookingId, "CheckedIn");
                List<Integer> roomIds = bookingDAO.getRoomIdsByBookingAndBranch(bookingId, branchId);
                for (int roomId : roomIds) {
                    roomDAO.updateRoomStatus(roomId, "Occupied"); 
                }
                session.setAttribute("checkinMessage", "Check-in successful.");
            } else if ("checkout".equalsIgnoreCase(action)) {
                bookingDAO.updateBookingStatus(bookingId, "CheckedOut");
                List<Integer> roomIds = bookingDAO.getRoomIdsByBookingAndBranch(bookingId, branchId);
                for (int roomId : roomIds) {
                    roomDAO.updateRoomStatus(roomId, "Available");
                }
                session.setAttribute("checkoutMessage", "Check-out successful.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Booking ID is invalid.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred while processing the booking.");
        }
        response.sendRedirect("staff-bookings-list");
    }
}