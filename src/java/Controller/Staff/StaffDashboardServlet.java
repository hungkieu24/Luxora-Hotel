package Controller.Staff;

import Dal.HotelBranchDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "StaffDashboardServlet", urlPatterns = {"/staff-dashboard"})
public class StaffDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // --- VALIDATION: Check staff session/role ---
        HttpSession session = request.getSession(false);
        Object roleObj = (session != null) ? session.getAttribute("userRole") : null;
        String role = (roleObj != null) ? roleObj.toString() : "";

        if (session == null || role.isEmpty() || !"staff".equalsIgnoreCase(role)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
         // --- Đảm bảo branchName luôn có trong session ---
        if (session.getAttribute("branchName") == null) {
            Object branchIdObj = session.getAttribute("branchId");
            Integer branchId = null;
            if (branchIdObj instanceof Integer) {
                branchId = (Integer) branchIdObj;
            } else if (branchIdObj instanceof String) {
                try {
                    branchId = Integer.parseInt((String) branchIdObj);
                } catch (NumberFormatException e) {
                    branchId = null;
                }
            }
            if (branchId != null) {
                HotelBranchDAO branchDAO = new HotelBranchDAO();
                String branchName = branchDAO.getBranchNameById(branchId);
                session.setAttribute("branchName", branchName);
            }
        }
        
        request.getRequestDispatcher("staff-dashboard.jsp").forward(request, response);
    }
}
