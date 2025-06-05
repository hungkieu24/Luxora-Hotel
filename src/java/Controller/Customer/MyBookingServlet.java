/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.Customer;

import Dal.BookingDAO;
import Model.Booking;
import Model.UserAccount;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author KTC
 */
@WebServlet(name="MyBookingServlet", urlPatterns={"/myBooking"})
public class MyBookingServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet MyBookingServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MyBookingServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

//        String userId = String.valueOf(user.getId());

        // Lấy danh sách booking của người dùng
        BookingDAO bookingdao = new BookingDAO();
        List<Booking> bookings = bookingdao.getBookingsByUserId(user.getId());

        // Đặt danh sách booking vào request để JSP hiển thị
        request.setAttribute("bookings", bookings);

        // Chuyển hướng đến JSP
        request.getRequestDispatcher("myBooking.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Xử lý yêu cầu hủy booking
        String action = request.getParameter("action");
        if ("cancel".equals(action)) {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            String cancelReason = request.getParameter("cancelReason");

            BookingDAO bd = new BookingDAO();
            boolean success = bd.cancelBooking(bookingId, cancelReason);

            if (success) {
                request.setAttribute("message", "Booking cancelled successfully.");
            } else {
                request.setAttribute("error", "Reservation cannot be canceled. Please try again.");
            }

            // Làm mới danh sách booking
            HttpSession session = request.getSession();
            UserAccount user = (UserAccount) session.getAttribute("user");
            String userId = String.valueOf(user.getId());
            List<Booking> bookings = bd.getBookingsByUserId(userId);
            request.setAttribute("bookings", bookings);
        }

        // Chuyển hướng lại JSP
        request.getRequestDispatcher("myBooking.jsp").forward(request, response);
    }
    

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
   }

