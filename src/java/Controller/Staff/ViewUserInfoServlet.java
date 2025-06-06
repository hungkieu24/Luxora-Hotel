/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.Staff;

import Dal.UserAccountDAO;
import Model.UserAccount;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Admin
 */
@WebServlet(name="ViewUserInfoServlet", urlPatterns={"/view-user-info"})
public class ViewUserInfoServlet extends HttpServlet {
    private final UserAccountDAO userAccountDAO = new UserAccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
         // --- VALIDATION: Check staff session/role ---
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userRole") == null
                || !"staff".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        
        String userId = request.getParameter("userId");
        if (userId != null && !userId.trim().isEmpty()) {
            UserAccount user = userAccountDAO.getUserInfoById(userId);
            request.setAttribute("user", user);
        }
        request.getRequestDispatcher("view-user-info.jsp").forward(request, response);
    }
}