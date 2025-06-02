/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author thien
 */
@WebServlet(name = "VerifyCodeServlet", urlPatterns = {"/verifyCode"})
public class VerifyCodeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String code = request.getParameter("code");

        HttpSession session = request.getSession();
        String sessionCode = (String) session.getAttribute("resetCode");
        Long expiryTime = (Long) session.getAttribute("resetExpiry");
        String sessionEmail = (String) session.getAttribute("resetEmail");
        long currentTime = System.currentTimeMillis();
        if (sessionCode == null || sessionEmail == null || expiryTime == null) {
            request.setAttribute("error", "Your session has expired. Please request a new verification code.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("verifyCode.jsp").forward(request, response);
            return;

        }
        if (!sessionEmail.equals(email)) {
            request.setAttribute("error", "Invalid email verification.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("verifyCode.jsp").forward(request, response);
            return;
        }
        if (currentTime > expiryTime) {
            request.setAttribute("error", "The verification code has expired. Please request a new code.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("verifyCode.jsp").forward(request, response);
            return;
        }

        if (!sessionCode.equals(code)) {
            request.setAttribute("error", "Incorrect verification code.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("verifyCode.jsp").forward(request, response);
            return;
        }
        session.setAttribute("email", email); // Giữ lại email để reset
        response.sendRedirect("resetPassword.jsp");
    }

}
