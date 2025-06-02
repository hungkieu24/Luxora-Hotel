/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

/*
 * Updated BranchDetailsServlet.java to handle branch selection
 */
package Controller;

import Dal.BranchReportDAO;
import Model.BranchReport;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/branchDetails")
public class BranchDetailsServlet extends HttpServlet {
    
    private BranchReportDAO branchReportDAO;
    
    @Override
    public void init() throws ServletException {
        branchReportDAO = new BranchReportDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String userId = (String) session.getAttribute("userId");
        
        // Check if user is logged in
//        if (userId == null || userId.trim().isEmpty()) {
//            response.sendRedirect("login.jsp");
//            return;
//        }
        
        try {
            
            String branchId = request.getParameter("id");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            
            // Validate and set default values
            if (startDate == null || startDate.trim().isEmpty()) {
                startDate = "2024-01-01";
            }
            if (endDate == null || endDate.trim().isEmpty()) {
                endDate = "2024-12-31";
            }
            
            // Fetch all branches for dropdown
            List<BranchReport> branches = branchReportDAO.getAllBranches(userId);
            request.setAttribute("branches", branches);
            
            // If no branchId is provided, use the first branch in the list (if available)
            if (branchId == null || branchId.trim().isEmpty()) {
                if (!branches.isEmpty()) {
                    branchId = String.valueOf(branches.get(0).getBranchId());
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No branches available");
                    return;
                }
            }
            
            // Fetch individual branch report
            BranchReport branchReport = branchReportDAO.getIndividualBranchReport(userId, branchId, startDate, endDate);
            
            if (branchReport == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Branch report not found");
                return;
            }
            
            request.setAttribute("branchReport", branchReport);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            request.setAttribute("selectedBranchId", branchId);
            
            
            request.getRequestDispatcher("branchDetails.jsp").forward(request, response);
            
        
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
