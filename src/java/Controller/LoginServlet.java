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
/**
 *
 * @author thien
 */
@WebServlet(name="LoginServlet", urlPatterns={"/login"})
public class LoginServlet extends HttpServlet {
   
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
    } 


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
       // Xử lý đăng nhập bằng username/password
       String username = request.getParameter("username");
       String password = request.getParameter("password");
       UserAccountDAO u = new UserAccountDAO();
       UserAccount user = u.login(username, password);
       if(user != null && user.getStatus().equals("Active")){
           HttpSession session = request.getSession();
           session.setAttribute("user", user);
           if(user.getRole().equals("admin")){
               response.sendRedirect("admindashboard.jsp");// phản hồi lại trang page mặc định khi đăng nhập vào của admin
           }
           // tương tự như các useraccount còn lại 
           else{
               response.sendRedirect("home");// phản hồi lại trang home mặc định khi đăng nhập vào của customer
           }
       } else{
           request.setAttribute("error", "Invalid credentials or account banned");
           request.getRequestDispatcher("login.jsp").forward(request, response);
       }
    }


}
