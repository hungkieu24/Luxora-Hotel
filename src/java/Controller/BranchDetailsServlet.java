/*
 * BranchDetailsServlet.java
 * Handles branch selection and report generation for hotel owners
 */
package Controller;

import Dal.BranchReportDAO;
import Model.BranchReport;
import Model.UserAccount;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/branch-details")
public class BranchDetailsServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(BranchDetailsServlet.class.getName());
    private static final String DEFAULT_START_DATE = LocalDate.now().withDayOfYear(1).toString(); // First day of current year
    private static final String DEFAULT_END_DATE = LocalDate.now().toString(); // Today
    private static final String JSP_PAGE = "branch-details.jsp";
    
    private BranchReportDAO branchReportDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        branchReportDAO = new BranchReportDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check session and user authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            LOGGER.warning("No session or user found, redirecting to login");
            response.sendRedirect("login.jsp");
            return;
        }

        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user == null || user.getId() == null || user.getId().trim().isEmpty()) {
            LOGGER.warning("Invalid user in session, redirecting to login");
            response.sendRedirect("login.jsp");
            return;
        }
        
        String userId = user.getId();
        LOGGER.info("Processing branch details request for user: " + userId);

        try {
            // Get parameters from request
            String branchId = request.getParameter("id");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            
            LOGGER.info("Parameters - branchId: " + branchId + ", startDate: " + startDate + ", endDate: " + endDate);

            // Validate and set default dates
            startDate = validateAndSetDefaultDate(startDate, DEFAULT_START_DATE);
            endDate = validateAndSetDefaultDate(endDate, DEFAULT_END_DATE);

            // Validate date format and logical order
            if (!isValidDateFormat(startDate) || !isValidDateFormat(endDate)) {
                setErrorAndForward(request, response, "Invalid date format. Please use YYYY-MM-DD format.", 
                                 startDate, endDate);
                return;
            }

            if (!isValidDateRange(startDate, endDate)) {
                setErrorAndForward(request, response, "Start date must be before or equal to end date.", 
                                 startDate, endDate);
                return;
            }

            // Get all branches for the user
            List<BranchReport> branches = branchReportDAO.getAllBranches(userId);
            LOGGER.info("Branches retrieved: " + (branches != null ? branches.size() : 0));
            
            request.setAttribute("branches", branches);

            // Check if user has any branches
            if (branches == null || branches.isEmpty()) {
                LOGGER.warning("No branches found for user: " + userId);
                setErrorAndForward(request, response, "No branches found for your account. Please contact support.", 
                                 startDate, endDate);
                return;
            }

            // Validate and set branch ID
            branchId = validateAndSetBranchId(branchId, branches);
            LOGGER.info("Selected branchId: " + branchId);

            // Get detailed branch report
            BranchReport branchReport = branchReportDAO.getIndividualBranchReport(userId, branchId, startDate, endDate);
            
            if (branchReport == null) {
                LOGGER.warning("No branch report found for branchId: " + branchId);
                request.setAttribute("errorMessage", "No data available for the selected branch and date range.");
            } else {
                LOGGER.info("Successfully retrieved branch report for branch: " + branchReport.getBranchName());
            }

            // Set attributes for JSP
            request.setAttribute("branchReport", branchReport);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            request.setAttribute("selectedBranchId", branchId);
            
            request.getRequestDispatcher(JSP_PAGE).forward(request, response);

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error while processing branch details", ex);
            setErrorAndForward(request, response, "Database connection error. Please try again later.", 
                             request.getParameter("startDate"), request.getParameter("endDate"));
        } catch (NumberFormatException ex) {
            LOGGER.log(Level.WARNING, "Invalid branch ID format", ex);
            setErrorAndForward(request, response, "Invalid branch selection. Please try again.", 
                             request.getParameter("startDate"), request.getParameter("endDate"));
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Unexpected error in BranchDetailsServlet", ex);
            setErrorAndForward(request, response, "An unexpected error occurred. Please contact support if the problem persists.", 
                             request.getParameter("startDate"), request.getParameter("endDate"));
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Handle POST requests the same way as GET
        doGet(request, response);
    }
    
    /**
     * Helper method to set error message and forward to JSP
     */
    private void setErrorAndForward(HttpServletRequest request, HttpServletResponse response, 
                                   String errorMessage, String startDate, String endDate) 
            throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.getRequestDispatcher(JSP_PAGE).forward(request, response);
    }
    
    /**
     * Validates date format and sets default if invalid or empty
     */
    private String validateAndSetDefaultDate(String date, String defaultDate) {
        if (date == null || date.trim().isEmpty()) {
            return defaultDate;
        }
        
        String trimmedDate = date.trim();
        if (isValidDateFormat(trimmedDate)) {
            return trimmedDate;
        }
        
        LOGGER.warning("Invalid date format provided: " + date + ", using default: " + defaultDate);
        return defaultDate;
    }
    
    /**
     * Validates date format (YYYY-MM-DD)
     */
    private boolean isValidDateFormat(String date) {
        if (date == null || date.trim().isEmpty()) {
            return false;
        }
        
        try {
            LocalDate.parse(date.trim(), DateTimeFormatter.ISO_LOCAL_DATE);
            return true;
        } catch (DateTimeParseException e) {
            LOGGER.warning("Invalid date format: " + date);
            return false;
        }
    }
    
    /**
     * Validates that start date is before or equal to end date
     */
    private boolean isValidDateRange(String startDate, String endDate) {
        try {
            LocalDate start = LocalDate.parse(startDate.trim(), DateTimeFormatter.ISO_LOCAL_DATE);
            LocalDate end = LocalDate.parse(endDate.trim(), DateTimeFormatter.ISO_LOCAL_DATE);
            return !start.isAfter(end);
        } catch (DateTimeParseException e) {
            LOGGER.warning("Error parsing dates for range validation: " + startDate + " to " + endDate);
            return false;
        }
    }
    
    /**
     * Validates and sets branch ID, defaults to first branch if invalid
     */
    private String validateAndSetBranchId(String branchId, List<BranchReport> branches) {
        // Safety check - should not happen due to earlier validation
        if (branches == null || branches.isEmpty()) {
            LOGGER.severe("validateAndSetBranchId called with empty branches list");
            throw new IllegalStateException("No branches available for validation");
        }
        
        if (branchId == null || branchId.trim().isEmpty()) {
            String defaultBranchId = String.valueOf(branches.get(0).getBranchId());
            LOGGER.info("No branch ID provided, defaulting to first branch: " + defaultBranchId);
            return defaultBranchId;
        }
        
        String trimmedBranchId = branchId.trim();
        if (isValidBranchId(trimmedBranchId, branches)) {
            return trimmedBranchId;
        }
        
        // If invalid, return first branch ID
        String defaultBranchId = String.valueOf(branches.get(0).getBranchId());
        LOGGER.warning("Invalid branch ID provided: " + branchId + ", defaulting to first branch: " + defaultBranchId);
        return defaultBranchId;
    }
    
    /**
     * Checks if branch ID is valid and exists in the user's branches
     */
    private boolean isValidBranchId(String branchId, List<BranchReport> branches) {
        if (branchId == null || branchId.trim().isEmpty() || branches == null || branches.isEmpty()) {
            return false;
        }
        
        try {
            int id = Integer.parseInt(branchId.trim());
            return branches.stream().anyMatch(branch -> branch.getBranchId() == id);
        } catch (NumberFormatException e) {
            LOGGER.warning("Non-numeric branch ID: " + branchId);
            return false;
        }
    }
    
    /**
     * Cleanup resources
     */
    @Override
    public void destroy() {
        super.destroy();
        // Cleanup any resources if needed
        if (branchReportDAO != null) {
            // Close any connections if branchReportDAO has cleanup methods
            LOGGER.info("Cleaning up BranchReportDAO resources");
        }
        LOGGER.info("BranchDetailsServlet destroyed");
    }
}