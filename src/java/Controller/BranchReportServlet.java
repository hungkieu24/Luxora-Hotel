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

@WebServlet("/branch-reports")
public class BranchReportServlet extends HttpServlet {
    
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
        
        // Tạm thời bỏ kiểm tra userId để test
        // if (userId == null || userId.trim().isEmpty()) {
        //     response.sendRedirect("login.jsp");
        //     return;
        // }
        
        try {
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            String reportType = request.getParameter("reportType");
            
            // FIX 3: Validate và set default values
            if (startDate == null || startDate.trim().isEmpty()) {
                startDate = "2024-01-01";
            }
            if (endDate == null || endDate.trim().isEmpty()) {
                endDate = "2024-12-31";
            }
            if (reportType == null || reportType.trim().isEmpty()) {
                reportType = "revenue";
            }
            
            List<BranchReport> branchReports = branchReportDAO.getBranchReports(userId, startDate, endDate, reportType);
            System.out.println("Branch reports size: " + branchReports.size());

            // FIX 4: Tính toán metrics chính xác
            double totalRevenue = 0;
            int totalBookings = 0;
            int totalBranches = branchReports.size(); // Số lượng chi nhánh thay vì tổng phòng
            
            for (BranchReport report : branchReports) {
                totalRevenue += report.getTotalRevenue();
                totalBookings += report.getTotalBookings();
            }
            
            // FIX 5: Tính average occupancy rate chính xác
            double averageOccupancyRate = branchReports.isEmpty() ? 0 : 
                branchReports.stream()
                    .mapToDouble(BranchReport::getOccupancyRate)
                    .average()
                    .orElse(0);
            
            // Tính tổng số phòng từ tất cả chi nhánh (nếu cần)
            int totalRooms = branchReports.stream()
                .mapToInt(BranchReport::getTotalRooms)
                .sum();
            
            request.setAttribute("branchReports", branchReports);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("averageOccupancyRate", Math.round(averageOccupancyRate * 100.0) / 100.0); // Round to 2 decimal places
            request.setAttribute("totalRooms", totalRooms);
            request.setAttribute("totalBranches", totalBranches);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            request.setAttribute("reportType", reportType);
            
            request.getRequestDispatcher("branchReport.jsp").forward(request, response);
            
        } catch (IllegalArgumentException e) {
            // Handle specific exceptions
            e.printStackTrace();
            response.getWriter().println("Error: Invalid input parameters - " + e.getMessage());
        } catch (Exception e) {
            // Handle other unexpected errors
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