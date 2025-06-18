package Controller.Staff;

import Dal.BookingDAO;
import Dal.RoomDAO;
import Dal.UserAccountDAO;
import Model.Room;
import Model.RoomType;
import Model.UserAccount;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet(name = "CreateWalkInBookingServlet", urlPatterns = {"/createWalkInBooking"})
public class CreateWalkInBookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Prevent direct GET access, redirect to search guest page
        response.sendRedirect("searchGuest");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get guest info from form
        String guestId = request.getParameter("guestId");
        String roomTypeIdStr = request.getParameter("roomTypeId");
        String roomIdStr = request.getParameter("roomId");
        String checkInStr = request.getParameter("checkIn");
        String checkOutStr = request.getParameter("checkOut");

        UserAccountDAO userDao = new UserAccountDAO();
        UserAccount guest = userDao.findById(guestId);

        // Get staff from session to get branchId
        UserAccount staff = (UserAccount) request.getSession().getAttribute("user");
        Integer branchId = (staff != null) ? staff.getBranchId() : null;

        RoomDAO roomDao = new RoomDAO();

        // Load room types by branch
        List<RoomType> roomTypes = (branchId != null) ? roomDao.getRoomTypesByBranch(branchId) : null;

        // Load available rooms by branch and room type if chosen, otherwise by branch only
        List<Room> rooms = null;
        if (branchId != null && roomTypeIdStr != null && !roomTypeIdStr.trim().isEmpty()) {
            try {
                int roomTypeId = Integer.parseInt(roomTypeIdStr);
                rooms = roomDao.getAvailableRoomsByBranchAndRoomType(branchId, roomTypeId);
            } catch (NumberFormatException e) {
                rooms = roomDao.getAvailableRoomsByBranch(branchId);
            }
        } else if (branchId != null) {
            rooms = roomDao.getAvailableRoomsByBranch(branchId);
        }

        request.setAttribute("guest", guest);
        request.setAttribute("roomTypes", roomTypes);
        request.setAttribute("rooms", rooms);

        // Validate input data
        if (guestId == null || guestId.trim().isEmpty()
                || roomTypeIdStr == null || roomTypeIdStr.trim().isEmpty()
                || roomIdStr == null || roomIdStr.trim().isEmpty()
                || checkInStr == null || checkInStr.trim().isEmpty()
                || checkOutStr == null || checkOutStr.trim().isEmpty()) {
            request.setAttribute("errorMsg", "Please fill in all required information.");
            request.getRequestDispatcher("createWalkInBooking.jsp").forward(request, response);
            return;
        }

        int roomId;
        try {
            roomId = Integer.parseInt(roomIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "Invalid room selection.");
            request.getRequestDispatcher("createWalkInBooking.jsp").forward(request, response);
            return;
        }

        Timestamp checkIn, checkOut;
        try {
            checkIn = Timestamp.valueOf(checkInStr.replace('T', ' ') + ":00");
            checkOut = Timestamp.valueOf(checkOutStr.replace('T', ' ') + ":00");
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMsg", "Invalid date/time format.");
            request.getRequestDispatcher("createWalkInBooking.jsp").forward(request, response);
            return;
        }

        // Create booking
        BookingDAO bookingDao = new BookingDAO();
        boolean bookingSuccess = bookingDao.createWalkInBookingSimple(guestId, roomId, checkIn, checkOut);

        // If booking successful, update room status
        if (bookingSuccess) {
            boolean updateRoom = roomDao.updateRoomStatus(roomId, "Booked");
            if (updateRoom) {
                request.setAttribute("successMsg", "Booking successful!");
            } else {
                request.setAttribute("errorMsg", "Booking was successful but failed to update room status.");
            }
        } else {
            request.setAttribute("errorMsg", "Booking failed, please try again.");
        }

        // Reload available rooms after booking to avoid double booking
        if (branchId != null && roomTypeIdStr != null && !roomTypeIdStr.trim().isEmpty()) {
            try {
                int roomTypeId = Integer.parseInt(roomTypeIdStr);
                rooms = roomDao.getAvailableRoomsByBranchAndRoomType(branchId, roomTypeId);
            } catch (NumberFormatException e) {
                rooms = roomDao.getAvailableRoomsByBranch(branchId);
            }
        } else if (branchId != null) {
            rooms = roomDao.getAvailableRoomsByBranch(branchId);
        }
        request.setAttribute("rooms", rooms);

        request.getRequestDispatcher("createWalkInBooking.jsp").forward(request, response);
    }
}