package Controller.Staff;

import Dal.BookingDAO;
import Model.Booking;
import Model.UserAccount;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "StaffBookingsListServlet", urlPatterns = {"/staff-bookings-list"})
public class StaffBookingsListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        UserAccount staff = (UserAccount) session.getAttribute("user");
        Integer branchId = staff.getBranchId();
        
        
        if (session.getAttribute("branchName") == null) {
            Integer branchIdInt = branchId;
            if (branchIdInt != null) {
                Dal.HotelBranchDAO branchDAO = new Dal.HotelBranchDAO();
                String branchName = branchDAO.getBranchNameById(branchIdInt);
                session.setAttribute("branchName", branchName);
            }
        }      
        request.setAttribute("branchName", session.getAttribute("branchName"));
        
        // --- Paging & Search ---
        String keyword = request.getParameter("keyword");
        int page = 1, pageSize = 5;
        String pageParam = request.getParameter("page");
        try { if (pageParam != null) page = Integer.parseInt(pageParam); } catch (Exception ignored) {}

        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bookings;
        int totalBooking;
        if (keyword != null && !keyword.trim().isEmpty()) {
            bookings = bookingDAO.searchBookingsTodayByCustomerAndBranchPaging(keyword.trim(), branchId, page, pageSize);
            totalBooking = bookingDAO.countBookingsTodayByCustomerAndBranch(keyword.trim(), branchId);
            request.setAttribute("keyword", keyword.trim());
        } else {
            bookings = bookingDAO.getBookingsTodayByBranchPaging(branchId, page, pageSize);
            totalBooking = bookingDAO.countBookingsTodayByBranch(branchId);
        }
        int totalPage = (int) Math.ceil((double) totalBooking / pageSize);
        if (totalPage == 0) totalPage = 1;
        if (page > totalPage) page = totalPage;

        // Flash messages
        Object checkinMsg = session.getAttribute("checkinMessage");
        if (checkinMsg != null) { request.setAttribute("checkinMessage", checkinMsg); session.removeAttribute("checkinMessage"); }
        Object checkoutMsg = session.getAttribute("checkoutMessage");
        if (checkoutMsg != null) { request.setAttribute("checkoutMessage", checkoutMsg); session.removeAttribute("checkoutMessage"); }
        Object errorMsg = session.getAttribute("errorMessage");
        if (errorMsg != null) { request.setAttribute("errorMessage", errorMsg); session.removeAttribute("errorMessage"); }

       
        request.setAttribute("bookings", bookings);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPage", totalPage);

        // --- AJAX support for live search ---
        if ("1".equals(request.getParameter("ajax"))) {
           
            request.getRequestDispatcher("staff-bookings-tablebody.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("staff-bookings-list.jsp").forward(request, response);
    }
}