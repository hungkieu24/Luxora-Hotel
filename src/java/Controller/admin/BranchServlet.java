/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.admin;

import Dal.HotelBranchDAO;
import Dal.UserAccountDAO;
import Model.HotelBranch;
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
 * @author hungk
 */
@WebServlet(name="BranchServlet", urlPatterns={"/admin/branch"})
public class BranchServlet extends HttpServlet {
   
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
            out.println("<title>Servlet BranchServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BranchServlet at " + request.getContextPath () + "</h1>");
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
        String action = request.getParameter("action");
        String keyword = request.getParameter("searchKeyword");
        
        int page = 1; // trang đầu tiên
        int pageSize = 5; // 1 trang có 10 row
        int totalPages = 0;
        int brancheListSize = 0;
        
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }
        
        HotelBranchDAO branchDAO = new HotelBranchDAO();
        List<HotelBranch> brancheList = branchDAO.getListHotelBranchByPage(page, pageSize);
        
        if (action != null && action.equals("search")) {
            
            if (keyword != null) {
                keyword = keyword.trim(); // Xóa dấu cách đầu và cuối
                keyword = keyword.replaceAll("\\s+", " ");
            }

            brancheList = branchDAO.searchHotelBranches(keyword, page, pageSize);
            brancheListSize = branchDAO.getTotalHotelBranchAfterSearching(keyword);

            totalPages = (int) Math.ceil((double) brancheListSize / pageSize);
        } else {
            List<HotelBranch> listAll = branchDAO.getAllHotelBranchesSimple();
            brancheListSize = listAll.size();
            totalPages = (int) Math.ceil((double) brancheListSize / pageSize);
        }
        
        UserAccountDAO accountDAO = new UserAccountDAO();
        UserAccount owner = accountDAO.getHotelOwner();
        List<UserAccount> staffList =  accountDAO.getAllStaff();
        
        request.setAttribute("action", action);
        request.setAttribute("keyword", keyword);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("owner", owner);
        request.setAttribute("staffList", staffList);
        request.setAttribute("brancheListSize", brancheListSize);
        request.setAttribute("brancheList", brancheList);
        request.getRequestDispatcher("./branch.jsp").forward(request, response);
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
        processRequest(request, response);
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
