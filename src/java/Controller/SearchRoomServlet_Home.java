/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Dal.RoomTypeDAO;
import Model.RoomType;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;

/**
 *
 * @author hungk
 */
@WebServlet(name = "SearchRoomServlet_Home", urlPatterns = {"/searchroom"})
public class SearchRoomServlet_Home extends HttpServlet {

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
            out.println("<title>Servlet SearchRoomServlet_Home</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SearchRoomServlet_Home at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    private void setSessionMessage(HttpSession session, String message, String type) {
        session.setAttribute("message", message);
        session.setAttribute("messageType", type);
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
        HttpSession session = request.getSession();

        String adults = request.getParameter("adults");
        String childs = request.getParameter("childs");
        String dates = request.getParameter("dates");

        if (adults == null || childs == null || dates == null || dates.isEmpty()) {
            setSessionMessage(session, "Please fill in all information to search!", "error");
            response.sendRedirect("./homepage");
            return;
        }

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM-dd-yy");

        // Tách chuỗi theo dấu ">"
        String[] parts = dates.split(">");
        if (parts.length < 2) {
            setSessionMessage(session, "Please select check-in and check-out dates.", "error");
            response.sendRedirect("./homepage");
            return;
        }
        String checkInStr = parts[0].trim();   // "05-26-25"
        String checkOutStr = parts[1].trim();  // "05-29-25"

        // Chuyển sang LocalDate
        LocalDate checkIn = LocalDate.parse(checkInStr, formatter);
        LocalDate checkOut = LocalDate.parse(checkOutStr, formatter);

        // Parst adults, childs -> int 
        int childsNum = Integer.parseInt(childs);
        int adultsNum = Integer.parseInt(adults);
        int totalPeople = childsNum + adultsNum;

        RoomTypeDAO roomTypeDAO = new RoomTypeDAO();
        List<RoomType> availableRoomTypes = roomTypeDAO.searchAvailableRoomTypes(checkIn, checkOut, totalPeople);

        request.setAttribute("availableRoomTypes", availableRoomTypes);
        request.getRequestDispatcher("./searchRoomResult.jsp").forward(request, response);
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
        processRequest(request, response);
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
