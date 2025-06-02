/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller;

import Dal.BookingDAO;
import Model.Booking;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Admin
 */
@WebServlet(name="StaffBookingServlet", urlPatterns={"/staff-bookings"})
public class StaffBookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bookings;

        if (keyword != null && !keyword.trim().isEmpty()) {
            bookings = bookingDAO.searchBookingsTodayByCustomer(keyword.trim());
            request.setAttribute("keyword", keyword); // để hiển thị lại trên ô input
        } else {
            bookings = bookingDAO.getBookingsToday();
        }

        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("staff-bookings.jsp").forward(request, response);
    }
}