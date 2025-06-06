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
import Dal.UserAccountDAO;
import Model.UserAccount;
import jakarta.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.fluent.Request;
import org.apache.http.client.fluent.Form;

/**
 *
 * @author thien
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    public static final String CLIENT_ID = "202740089898-biog485gnu7f0i8v8q0sma4bjtl6effc.apps.googleusercontent.com";
    public static final String CLIENT_SECRET = "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";
    public static final String REDIRECT_URI = "http://localhost:8080/ParadiseHotel/login";
    public static final String LINK_GET_TOKEN = "https://accounts.google.com/o/oauth2/token";
    public static final String LINK_GET_USER_INFO = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=";
    public static final String GRANT_TYPE = "authorization_code";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            // Xử lý logout nếu action=logout
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) session.invalidate();
            response.sendRedirect("homepage.jsp");
            return;
        }

        String code = request.getParameter("code");
        try {
            // get access token from gg
            String accessToken = getToken(code);
            // get user info from gg
            JsonObject userInfo = getUserInfoJson(accessToken);
            // necessary fields
            String email = userInfo.get("email").getAsString();
            String name = userInfo.get("name").getAsString();
            String avatar_url = userInfo.get("picture") != null ? userInfo.get("picture").getAsString() : null;

            // save or update user in database
            UserAccountDAO userDAO = new UserAccountDAO();
            UserAccount user = userDAO.saveUserToDatabase(email, name, avatar_url);
            // get user to login
            UserAccount user1 = userDAO.getUserByEmail(email);
            if (user1 != null && user1.getStatus().equals("Active")) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user1);
                response.sendRedirect("homepage");
            }
        } catch (IOException e) {
            request.setAttribute("error", "Google login failed. Please try again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }

    }

    public static String getToken(String code) throws ClientProtocolException, IOException {
        // Call API to get token
        String response = Request.Post(LINK_GET_TOKEN)
                .bodyForm(Form.form()
                        .add("client_id", CLIENT_ID)
                        .add("client_secret", CLIENT_SECRET)
                        .add("redirect_uri", REDIRECT_URI)
                        .add("code", code)
                        .add("grant_type", GRANT_TYPE).build())
                .execute().returnContent().asString();
        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
        String accessToken = jobj.get("access_token").toString().replaceAll("\"", "");
        return accessToken;
    }

    public static JsonObject getUserInfoJson(final String accessToken) throws ClientProtocolException, IOException {
        String link = LINK_GET_USER_INFO + accessToken;
        String response = Request.Get(link).execute().returnContent().asString();
        return new Gson().fromJson(response, JsonObject.class);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý đăng nhập bằng username/password
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        UserAccountDAO u = new UserAccountDAO();
        UserAccount user = u.login(username, password);
        if (user != null && user.getStatus().equals("Active")) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            if (user.getRole().equals("admin")) {
                response.sendRedirect("admindashboard.jsp");// phản hồi lại trang page mặc định khi đăng nhập vào của admin
            } // tương tự như các useraccount còn lại 
            else if (user.getRole().equals("Customer")) {
                response.sendRedirect("homepage");
            } else if (user.getRole().equalsIgnoreCase("staff")) {
                response.sendRedirect("staff-dashboard.jsp");
            } else {
                response.sendRedirect("homepage");// phản hồi lại trang home mặc định khi đăng nhập vào của customer
            }
        } else {
            request.setAttribute("error", "Invalid credentials or account banned");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

}
