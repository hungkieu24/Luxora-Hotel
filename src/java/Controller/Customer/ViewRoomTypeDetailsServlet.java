/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.Customer;

import Dal.FeedbackDAO;
import Dal.RoomTypeDAO;
import Model.Feedback;
import Model.RoomType;
import Model.UserAccount;
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
 * @author KTC
 */
@WebServlet(name = "ViewRoomTypeDetailsServlet", urlPatterns = {"/viewRoomTypeDetail"})
public class ViewRoomTypeDetailsServlet extends HttpServlet {

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
            out.println("<title>Servlet ViewRoomTypeDetailsServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ViewRoomTypeDetailsServlet at " + request.getContextPath() + "</h1>");
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
        String sroomTypeId = request.getParameter("roomTypeId");
        int roomTypeId = 0;
        if (sroomTypeId != null || !sroomTypeId.trim().isEmpty()) {
            roomTypeId = Integer.parseInt(sroomTypeId);
        } else {
            response.sendRedirect("./homepage");
            return;
        }

        RoomTypeDAO roomTypeDAO = new RoomTypeDAO();
        RoomType roomType = roomTypeDAO.getRoomTypeById(roomTypeId);
        List<RoomType> listSimilarRoom = roomTypeDAO.getSimilarRoomTypes(roomTypeId);
        request.setAttribute("roomType", roomType);
        request.setAttribute("listSimilarRoom", listSimilarRoom);

        //phan view feedback
        int page = 1; // trang dau tien
        int pageSize = 5; // 1 trang co 5 row
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        int feedbackListSize = feedbackDAO.getListFeedbackByRoomTypeId(roomTypeId).size();
        int totalPages = (int) Math.ceil((double) feedbackListSize / pageSize);
        List<Feedback> listFeedback = feedbackDAO.getListFeedbackByPage1(page, pageSize, roomTypeId);

        ////////////////////////////////////////////////////////////////////////
        UserAccount user = (UserAccount) request.getSession().getAttribute("user");
        request.setAttribute("user", user);

        ////////////////////////////////////////////////////////////////////////
        request.setAttribute("listFeedback", listFeedback);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("roomTypeId", roomTypeId);
        request.getRequestDispatcher("./viewRoomTypeDetail.jsp").forward(request, response);
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
