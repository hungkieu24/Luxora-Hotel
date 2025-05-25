package controller;

import dao.BookingDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Booking;

@WebServlet(urlPatterns={"/booking-history"})
public class BookingHistoryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userId = request.getParameter("user_id");
        List<Booking> bookings = null;

        if (userId != null && !userId.trim().isEmpty()) {
            BookingDAO bookingDAO = new BookingDAO();
            bookings = bookingDAO.getBookingsByUserId(userId);
            request.setAttribute("user_id", userId);
        }

        request.setAttribute("bookings", bookings);
        RequestDispatcher rd = request.getRequestDispatcher("bookingHistory.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}