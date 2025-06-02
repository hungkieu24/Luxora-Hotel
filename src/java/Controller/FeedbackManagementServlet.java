package Controller;

import Dal.FeedbackDAO;
import Model.Feedback;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "FeedbackManagementServlet", urlPatterns = {"/feedback"})
public class FeedbackManagementServlet extends HttpServlet {
    
    private FeedbackDAO feedbackDAO;
    
    @Override
    public void init() throws ServletException {
        feedbackDAO = new FeedbackDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user has admin/manager/staff role
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userId");
        
//        if (userRole == null || (!userRole.equals("Admin") && !userRole.equals("Manager") && !userRole.equals("Staff"))) {
//            response.sendRedirect(request.getContextPath() + "/login");
//            return;
//        }
        
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        switch (action) {
            case "list":
                handleListFeedback(request, response);
                break;
            case "view":
                handleViewFeedback(request, response);
                break;
            case "updateStatus":
                handleUpdateStatus(request, response);
                break;
            default:
                handleListFeedback(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private void handleListFeedback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get parameters
        String pageParam = request.getParameter("page");
        String statusFilter = request.getParameter("status");
        String sortBy = request.getParameter("sortBy");
        
        int page = 1;
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        if (statusFilter == null) statusFilter = "all";
        if (sortBy == null) sortBy = "date";
        
        int pageSize = 10;
        
        // Get feedback list
        List<Feedback> feedbacks = feedbackDAO.getAllFeedbackWithPagination(page, pageSize, statusFilter, sortBy);
        int totalCount = feedbackDAO.getTotalFeedbackCount(statusFilter);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        
        // Get statistics
        FeedbackDAO.FeedbackStats stats = feedbackDAO.getFeedbackStats();
        
        // Set attributes
        request.setAttribute("feedbacks", feedbacks);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("stats", stats);
        
        // Forward to JSP
        request.getRequestDispatcher("feedback-list.jsp").forward(request, response);
    }
    
    private void handleViewFeedback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "feedback");
            return;
        }
        
        try {
            int id = Integer.parseInt(idParam);
            Feedback feedback = feedbackDAO.getFeedbackById(id);
            
            if (feedback == null) {
                request.setAttribute("error", "Feedback not found");
                response.sendRedirect(request.getContextPath() + "feedback");
                return;
            }
            
            request.setAttribute("feedback", feedback);
            request.getRequestDispatcher("feedback-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "feedback");
        }
    }
    
    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        String status = request.getParameter("status");
        String adminAction = request.getParameter("adminAction");
        
        if (idParam == null || status == null) {
            response.sendRedirect(request.getContextPath() + "feedback");
            return;
        }
        
        try {
            int id = Integer.parseInt(idParam);
            if (adminAction == null) adminAction = "None";
            
            boolean success = feedbackDAO.updateFeedbackStatus(id, status, adminAction);
            
            if (success) {
                request.getSession().setAttribute("message", "Feedback status updated successfully");
            } else {
                request.getSession().setAttribute("error", "Failed to update feedback status");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid feedback ID");
        }
        
        response.sendRedirect(request.getContextPath() + "feedback");
    }
}