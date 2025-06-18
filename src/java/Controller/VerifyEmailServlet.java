package Controller;

import Dal.UserAccountDAO;
import Model.UserAccount;
import Utility.EmailUtility;
import Utility.PasswordUtils;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Random;

@WebServlet(name = "VerifyEmailServlet", urlPatterns = {"/verifyemail"})
public class VerifyEmailServlet extends HttpServlet {

    private void setSessionMessage(HttpSession session, String message, String type) {
        session.setAttribute("message", message);
        session.setAttribute("messageType", type);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Không dùng GET cho verify email
        response.sendRedirect("login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String inputCode = request.getParameter("code");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        // Nếu là yêu cầu gửi lại mã xác nhận
        if (action != null && action.equals("resend")) {
            sendVerificationCode(request, response);
            return;
        }

        // Kiểm tra các trường cần thiết
        String username = (String) session.getAttribute("username");
        String rawPassword = (String) session.getAttribute("password");
        String phone = (String) session.getAttribute("phone");
        String email = (String) session.getAttribute("email");
        if (email == null || username == null || rawPassword == null || phone == null) {
            setSessionMessage(session, "You need to register", "error");
            response.sendRedirect("register.jsp");
            return;
        }

        // Kiểm tra sessionCode và expiryTime
        String sessionCode = (String) session.getAttribute("authCode");
        Long expiryTime = (Long) session.getAttribute("expiryTime");
        long currentTime = System.currentTimeMillis();

        if (expiryTime == null || sessionCode == null) {
            setSessionMessage(session, "You need to register", "error");
            response.sendRedirect("register.jsp");
            return;
        }

        if (currentTime > expiryTime) {
            setSessionMessage(session, "The verification code has expired. Please request a new code.", "error");
            response.sendRedirect("verifyEmail.jsp");
            return;
        }

        // kiểm tra code -> Lưu user vào DB
        if (sessionCode.equals(inputCode)) {
            PasswordUtils passwordUtils = new PasswordUtils();
            String hashedPassword = passwordUtils.hashPassword(rawPassword);
            UserAccountDAO uadao = new UserAccountDAO();
            boolean registered = uadao.register(username, hashedPassword, email, "img/avatar/avatar.jpg", phone);
            if (registered) {
                setSessionMessage(session, "Register successfully!", "success");
                // SAU KHI XÁC THỰC THÀNH CÔNG, CHUYỂN VỀ TRANG searchGuest.jsp
                response.sendRedirect("searchGuest.jsp");
            } else {
                setSessionMessage(session, "Registration failed, please try again!", "error");
                response.sendRedirect("register.jsp");
            }
        } else {
            setSessionMessage(session, "The verification code is incorrect!", "error");
            response.sendRedirect("verifyEmail.jsp");
        }
    }

    public void sendVerificationCode(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");

        // Sinh mã xác nhận 6 chữ số
        String verificationCode = String.format("%06d", new Random().nextInt(1000000));
        int duration = 3 * 60; // 3 phút (180 giây)
        long expiryTime = System.currentTimeMillis() + duration * 1000;

        try {
            // Gửi email xác nhận
            EmailUtility.sendEmail(email, "Verify your email to register", verificationCode);
        } catch (Exception e) {
            e.printStackTrace();
            setSessionMessage(session, "Unable to send email, please check your email", "error");
            response.sendRedirect("register.jsp");
            return;
        }
           // Get staff from session to get branchId
        UserAccount staff = (UserAccount) request.getSession().getAttribute("user");
        Integer branchId = (staff != null) ? staff.getBranchId() : null;

        // Lưu thông tin xác nhận vào session
        session.setAttribute("duration", duration);
        session.setAttribute("expiryTime", expiryTime);
        session.setAttribute("authCode", verificationCode);

        // Điều hướng đến trang xác minh
        response.sendRedirect("verifyEmail.jsp");
    }
}