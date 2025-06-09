/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.Customer;

import Dal.LoyaltyPointDAO;
import Dal.UserAccountDAO;
import Model.LoyaltyPoint;
import Model.UserAccount;
import Utility.EmailUtility;
import Utility.UploadImage;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Random;

/**
 *
 * @author KTC
 */
@WebServlet(name = "EditProfileServlet", urlPatterns = {"/editProfile"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class EditProfileServlet extends HttpServlet {

    private final UserAccountDAO useraccountdao = new UserAccountDAO();

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
            out.println("<title>Servlet EditProfileServlet1</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditProfileServlet1 at " + request.getContextPath() + "</h1>");
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

        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

//        LoyaltyPointDAO loyaltypointdao = new LoyaltyPointDAO(); 
//        LoyaltyPoint loyaltypointlp = loyaltypointdao.getLoyaltyPointByUserId(user.getId());
//        
//        session.setAttribute("loyaltypointlp", loyaltypointlp); 
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
        UserAccountDAO useraccountdao = new UserAccountDAO();
        UserAccount user = (UserAccount) session.getAttribute("user");

        UploadImage up = new UploadImage();
        String UPLOAD_DIR = "/img/avatar";
        // duong dan luu tru trong du an
        String image = user.getAvatar_url();
        String pathHost = getServletContext().getRealPath("");   // Lấy thư mục gốc của project trên server, 
        //Lấy đường dẫn thực tế trên ổ đĩa nơi project đang chạy.
        String finalPath = pathHost.replace("build\\", ""); // Xoá build\ nếu dùng NetBeans
        String uploadPath = finalPath + UPLOAD_DIR;

        // upload anh
        String fileName = up.uploadImage(request, "avatar", uploadPath);
        String avatarUrl = "." + UPLOAD_DIR + "/" + fileName;
        if (fileName == null) {
            avatarUrl = image;

        }

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phonenumber = request.getParameter("phonenumber");

        if (!validateForUpdate(user.getId(), username, email, phonenumber, request)) {
            response.sendRedirect("./editProfile");
            return;
        }
        if(!email.equals(user.getEmail())){
            
            sendVerificationCode(request, response, email);
            session.setAttribute("username", username);
            session.setAttribute("phonenumber", phonenumber);
            session.setAttribute("userId", user.getId());
            session.setAttribute("avatarUrl", avatarUrl);
            session.setAttribute("email", email);
            return;
        }
            
        session.setAttribute("username", username);
        session.setAttribute("email", email);
        session.setAttribute("phonenumber", phonenumber);

        boolean updated = useraccountdao.updateUserInfo(user.getId(), username, email, phonenumber, avatarUrl);

        if (updated) {
            UserAccount useraccount = useraccountdao.getUserById(user.getId());
            session.setAttribute("user", useraccount);
            setSessionMessage(session, "Information updated successfully!", "success");
        } else {
            setSessionMessage(session, "Update information failed!!", "error");
        }

        request.getRequestDispatcher("editProfile.jsp").forward(request, response);

    }

    private void setSessionMessage(HttpSession session, String message, String type) {
        session.setAttribute("message", message);
        session.setAttribute("messageType", type);
    }

    public boolean validateForUpdate(String id, String username, String email, String phonenumber, HttpServletRequest request)   {
        HttpSession session = request.getSession();
        if (useraccountdao.isFieldExists("username", username, id)) {
            setSessionMessage(session, "Username already exists!", "error");
            return false;
        }

        if (useraccountdao.isFieldExists("email", email, id)) {
            setSessionMessage(session, "Email already exists!", "error");
            return false;
        }
        

        if (useraccountdao.isFieldExists("phonenumber", phonenumber, id)) {
            setSessionMessage(session, "Phone already exists!", "error");
            return false;
        }

        return true;
    }

    public void sendVerificationCode(HttpServletRequest request, HttpServletResponse response, String email) throws IOException {
        HttpSession session = request.getSession();

        // Sinh mã xác nhận 6 chữ số
        String verificationCode = String.format("%06d", new Random().nextInt(1000000));
        int duration = 1 * 60; // 1 phút (60 giây)
        long expiryTime = System.currentTimeMillis() + duration * 1000;

        try {
            // Gửi email xác nhận
            EmailUtility.sendEmail(email, "Verify your email to edit profile", verificationCode);
        } catch (Exception e) {
            e.printStackTrace();
            setSessionMessage(session, "Unable to send email, please check your email", "error");
            response.sendRedirect("./editProfile");
            return;
        }
        // Lưu thông tin xác nhận vào session
        session.setAttribute("duration", duration);
        session.setAttribute("expiryTime", expiryTime);
        session.setAttribute("authCode", verificationCode);

        // Điều hướng đến trang xác minh
        response.sendRedirect("verifyEmailForEditProfile.jsp");
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
