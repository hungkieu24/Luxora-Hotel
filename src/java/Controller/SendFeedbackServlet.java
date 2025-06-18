/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Dal.BookingDAO;
import Dal.FeedbackDAO;
import Dal.LoyaltyPointDAO;
import Dal.UserAccountDAO;
import Model.Booking;
import Model.Feedback;
import Model.LoyaltyPoint;
import Model.UserAccount;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author KTC
 */
@WebServlet(name = "SendFeedbackServlet", urlPatterns = {"/sendFeedback"})
public class SendFeedbackServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
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
            out.println("<title>Servlet SendFeedbackServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SendFeedbackServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int page = 1; // trang đầu tiên
        int pageSize = 5; // 1 trang có 5 row
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        int feedbackListSize = feedbackDAO.getAllFeedBack().size();
        int totalPages = (int) Math.ceil((double) feedbackListSize / pageSize);
        List<Feedback> listFeedback = feedbackDAO.getListFeedbackByPage(page, pageSize);
        request.setAttribute("listFeedback", listFeedback);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("sendFeedback.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserAccountDAO uad = new UserAccountDAO();
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("./login.jsp");
            return;
        }
        BookingDAO bkd = new BookingDAO();
        Booking bk = (Booking) session.getAttribute("bk");
//        bk = bkd.getBookingByUserId(user.getId());
        FeedbackDAO feedbackDAO = new FeedbackDAO();

        if (user == null) {
            response.sendRedirect("./login.jsp");
            return;
        }

        // Get form parameters
        String ratingStr = request.getParameter("rating");
        int rating = 0;
        if (ratingStr != null && !ratingStr.isEmpty()) {
            rating = Integer.parseInt(ratingStr);
        } else {
            request.setAttribute("message", "Rating is required.");
            request.getRequestDispatcher("sendFeedback.jsp").forward(request, response);
            return;
        }
        String comment = request.getParameter("comment");
        Timestamp createdAt = new Timestamp(System.currentTimeMillis());
        Feedback feedback = new Feedback(user.getId(), bk.getId(), rating, comment, createdAt, "Visible");

        try {
            feedbackDAO.addFeedback(feedback);
            request.setAttribute("message", "Feedback submitted successfully!");
        } catch (Exception e) {
            request.setAttribute("message", "Error submitting feedback: " + e.getMessage());
        }

        response.sendRedirect("./sendFeedback");

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
