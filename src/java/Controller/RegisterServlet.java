/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Dal.UserAccountDAO;
import Model.UserAccount;
import Utility.EmailUtility;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;

/**
 *
 * @author hungk
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private static final String GOOGLE_CLIENT_ID = "370841450880-23fiie6auhj74f5f5lel16b2gujnt2ui.apps.googleusercontent.com";

    private static final String GOOGLE_CLIENT_SECRET = "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";

    private static final String GOOGLE_REDIRECT_URI = "http://localhost:8080/ParadiseHotel/register";

    private static final String GOOGLE_LINK_GET_TOKEN = "https://accounts.google.com/o/oauth2/token";

    private static final String GOOGLE_LINK_GET_USER_INFO = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=";

    private static final String GOOGLE_GRANT_TYPE = "authorization_code";

    private void setSessionMessage(HttpSession session, String message, String type) {
        session.setAttribute("message", message);
        session.setAttribute("messageType", type);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        String accessToken = getToken(code);

        JsonObject userInfo = getUserInfoJson(accessToken);
        // necessary fields
        String emailGG = userInfo.get("email").getAsString();
        String nameGG = userInfo.get("name").getAsString();
        String avatar_url = userInfo.get("picture") != null ? userInfo.get("picture").getAsString() : null;

        UserAccountDAO userDAO = new UserAccountDAO();
        boolean registered = userDAO.register(nameGG, "1234", emailGG, avatar_url, null);
        if (registered) {
            HttpSession session = request.getSession();
            UserAccount user = userDAO.getUserByEmail(emailGG);
            session.setAttribute("user", user);
            response.sendRedirect("./homepage");
        } else {
            request.setAttribute("error", "Google login failed. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    public static String getToken(String code) throws ClientProtocolException, IOException {
        // Call API to get token
        String response = Request.Post(GOOGLE_LINK_GET_TOKEN)
                .bodyForm(Form.form()
                        .add("client_id", GOOGLE_CLIENT_ID)
                        .add("client_secret", GOOGLE_CLIENT_SECRET)
                        .add("redirect_uri", GOOGLE_REDIRECT_URI)
                        .add("code", code)
                        .add("grant_type", GOOGLE_GRANT_TYPE).build())
                .execute().returnContent().asString();
        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
        String accessToken = jobj.get("access_token").toString().replaceAll("\"", "");
        return accessToken;
    }

    public static JsonObject getUserInfoJson(String accessToken) throws ClientProtocolException, IOException {
        String link = GOOGLE_LINK_GET_USER_INFO + accessToken;
        String response = Request.Get(link).execute().returnContent().asString();
        return new Gson().fromJson(response, JsonObject.class);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");

        boolean isValidRegistration = isValidRegistration(email, username, password, request);

        if (!isValidRegistration) {
            response.sendRedirect("./register.jsp");
            return;
        }

        // Sinh mã xác nhận
        String verificationCode = String.valueOf((int) (Math.random() * 900000 + 100000));

        // Gửi email
        try {
            EmailUtility.sendEmail(email, "Verify your email to register", verificationCode);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to send email");
            request.getRequestDispatcher("./register.jsp").forward(request, response);
            return;
        }

        // Lưu thông tin tạm vào session
        session.setAttribute("authCode", verificationCode);
        session.setAttribute("username", username);
        session.setAttribute("email", email);
        session.setAttribute("password", password);
        session.setAttribute("phone", phone);
        response.sendRedirect("verify.jsp");
    }

    public boolean isValidRegistration(String email, String username, String password, HttpServletRequest request) {
        HttpSession session = request.getSession();

        // Regex pattern
        String letterRegex = ".*[a-zA-Z].*";
        String specialCharRegex = ".*[!@#$%^&*(),.?\":{}|<>].*";
        String digitRegex = ".*[0-9].*";

      
        if (!password.matches(letterRegex)
                || !password.matches(specialCharRegex)
                || !password.matches(digitRegex)) {
            setSessionMessage(session, "Password must include at least one letter, one digit, and one special character!", "error");
            return false;
        }

        // Kiểm tra email và username đã tồn tại chưa
        UserAccountDAO accountDAO = new UserAccountDAO();
        if (accountDAO.isEmailExist(email)) {
            setSessionMessage(session, "Email already exists!", "error");
            return false;
        }

        if (accountDAO.isUsernameExist(username)) {
            setSessionMessage(session, "Username already exists!", "error");
            return false;
        }

        // Nếu qua hết thì hợp lệ
        return true;
    }
}
