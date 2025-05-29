/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Dal.LoyaltyPointDAO;
import Dal.UserAccountDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Model.LoyaltyPoint;
import Model.UserAccount;
import org.eclipse.jdt.internal.compiler.util.Messages;
import Utility.UploadImage;

/**
 *
 * @author KTC
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)

public class EditProfileServlet extends HttpServlet {

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
            out.println("<title>Servlet editProfile</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet editProfile at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        UserAccountDAO uad = new UserAccountDAO();
        
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        LoyaltyPointDAO lpd = new LoyaltyPointDAO(); 
        LoyaltyPoint lp = lpd.getLoyaltyPointByUserId(user.getId());
        
        session.setAttribute("lp", lp); 
        request.getRequestDispatcher("editProfile.jsp").forward(request, response);
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
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        UserAccountDAO uad = new UserAccountDAO();
        UserAccount user = (UserAccount) session.getAttribute("user");

        UploadImage up = new UploadImage();
        String UPLOAD_DIR = "/img/avatar";
        
        response.setContentType("text/html;charset=UTF-8");

        // Đường dẫn lưu trữ trong dự án
        String image = user.getAvatar_url();
        String pathHost = getServletContext().getRealPath("");
        String finalPath = pathHost.replace("build\\", ""); 
        String uploadPath = finalPath + UPLOAD_DIR;
        
        // Upload ảnh
        String fileName = up.uploadImage(request, "avatar", uploadPath);
        if (fileName == null) {
            fileName = image;
        }
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");

        if (username != null && !username.trim().isEmpty()) {
            session.setAttribute("username", username);
        }
        if (email != null && !email.trim().isEmpty()) {
            session.setAttribute("email", email);
        }

        boolean updated = uad.updateUserInfo(user.getId(), username, email, fileName);
        
        if (updated) {
            UserAccount ua = uad.getUserById(user.getId());
            session.setAttribute("user", ua);
            session.setAttribute("message", "Information updated successfully!");
        } else {
            session.setAttribute("message", "Update information failed!");
        }
        
        
        
        
        request.getRequestDispatcher("editProfile.jsp").forward(request, response);
        
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
